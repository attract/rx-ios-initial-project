//
//  APIManager.swift
//  Food truck
//
//  Created by Dmytro Aprelenko on 22.07.2019.
//  Copyright © 2019 Dmytro Aprelenko. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RxCocoa
import RxAlamofire
import Reachability

// ------ APIManager class ------
final class APIManager {
    static let shared = APIManager()
    fileprivate let disposeBag = DisposeBag()

    let dict = BehaviorSubject<[String: Any]>(value: [:])

    private static var sessionManager: Alamofire.SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            ServerConstants.serverName : .disableEvaluation
        ]

        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders

        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )

        return manager
    }()

    fileprivate func makeRequest<T: Codable>(method: HTTPMethod, url: String, parameters: [String:Any]?, checkConnection: Bool = true) -> Single<ResponseModel<T>> {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        var urlRequest = URLRequest(url: URL(string: url)!)

        if let params = parameters {
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        }

        urlRequest.httpMethod = method.rawValue

        urlRequest.setValue("X-Requested-With", forHTTPHeaderField: "XMLHttpRequest")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        if let token = TokenManager().accessToken, token.length > 0 {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            #if DEBUG
            print("user token: \(token)")
            #endif
        } else if let clientToken = TokenManager().clientToken, clientToken.length > 0 {
            urlRequest.setValue("Bearer \(clientToken)", forHTTPHeaderField: "Authorization")
            #if DEBUG
            print("client token: \(clientToken)")
            #endif
        } else {
            return Single.create(subscribe: { (single) -> Disposable in
                self.getClientToken().subscribe(onSuccess: { (token) in
                    let manager = TokenManager()
                    manager.set(token.access_token, nil, nil)
                    _ = manager.saveToken()
                    self.makeRequest(method: method, url: url, parameters: parameters)
                        .subscribe(onSuccess: { (response) in
                            single(.success(response))
                        }, onError: { (error) in
                            single(.error(error))
                        }).disposed(by: self.disposeBag)
                }, onError: { (error) in
                    single(.error(error))
                })
                .disposed(by: self.disposeBag)

                return Disposables.create()
            })
        }

        return Single.create(subscribe: { (single) in
            if checkConnection {
                guard let reachability = try? Reachability(), reachability.connection != .unavailable else {
                    let apiError = APIError()
                    apiError.title = "No internet connection"
                    apiError.subtitle = "Check internet connection"
                    apiError.statusCode = 100
                    apiError.type = "Connection"
                    single(.error(AppError.APIError(apiError: apiError)))
                    return Disposables.create()
                }
            }

            APIManager.sessionManager.rx.request(urlRequest: urlRequest).responseData()
                .subscribeOn(MainScheduler.asyncInstance)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (response, data) in
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    let decodedData = self.decoderJSON(data: data, codable: ResponseModel<T>.self)
                    //print(String(data: data, encoding: .utf8))

                    guard response.statusCode >= 200, response.statusCode < 300 else {
                        let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                        var apiErrors = [APIError]()
                        if let errors = jsonDict?["errors"] as? [[String:Any]] {
                           apiErrors = errors.compactMap { (error) -> APIError? in
                                let apiError = APIError()
                                apiError.title = (error["errors"] as? [String])?.first
                                apiError.statusCode = response.statusCode
                                apiError.subtitle = error["field"] as? String
                                apiError.type = error["type"] as? String

                            return apiError
                            }
                        }


                        let apiError = APIError()
                        apiError.title = apiErrors.first?.title
                        apiError.subtitle = apiErrors.first?.subtitle
                        apiError.statusCode = response.statusCode
                        apiError.type = apiErrors.first?.type

                        if response.statusCode == 422 {
                            apiError.validationErrors = [APIError]()
                            apiError.title = apiErrors.first?.title
                            apiError.subtitle = apiErrors.first?.subtitle
                            apiError.statusCode = response.statusCode
                            apiError.type = apiErrors.first?.type
                            for error in apiErrors {
                                let validationError = APIError()
                                validationError.title = error.title
                                validationError.subtitle = error.subtitle

                                apiError.validationErrors?.append(validationError)
                            }
                            single(.error(AppError.APIError(apiError: apiError)))
                        } else if response.statusCode == 401 {
//                            let bag = DisposeBag()
                            let tokenManager = TokenManager()
                            if let refreshToken = tokenManager.refreshToken {
                                self.refreshToken(token: refreshToken).subscribe(onSuccess: { (response) in
                                    let tokenManager = TokenManager()
                                    tokenManager.set(response.apiToken?.token, response.accessToken, response.refreshToken)
                                    _ = tokenManager.saveToken()
                                    self.makeRequest(method: method, url: url, parameters: parameters)
                                        .subscribe(onSuccess: { (response) in
                                            single(.success(response))
                                        }, onError: { (error) in
                                            single(.error(error))
                                        }).disposed(by: self.disposeBag)
                                }, onError: { (error) in
                                    self.getClientToken().subscribe(onSuccess: { (token) in
                                        let manager = TokenManager()
                                        manager.set(token.access_token, nil, nil)
                                        _ = manager.saveToken()
                                        self.makeRequest(method: method, url: url, parameters: parameters)
                                            .subscribe(onSuccess: { (response) in
                                                single(.success(response))
                                            }, onError: { (error) in
                                                single(.error(error))
                                            }).disposed(by: self.disposeBag)
                                    }, onError: { (error) in
                                        single(.error(error))
                                    })
                                        .disposed(by: self.disposeBag)
                                }).disposed(by: self.disposeBag)
                            } else if apiError.type == "invalid_credentials" && tokenManager.clientToken != nil {
                                single(.error(AppError.APIError(apiError: apiError)))
                            } else {
                                let smallBag = DisposeBag()
                                self.getClientToken().subscribe(onSuccess: { (token) in
                                    let manager = TokenManager()
                                    manager.set(token.access_token, nil, nil)
                                    _ = manager.saveToken()
                                    self.makeRequest(method: method, url: url, parameters: parameters)
                                        .subscribe(onSuccess: { (response) in
                                            single(.success(response))
                                        }, onError: { (error) in
                                            single(.error(error))
                                        }).disposed(by: smallBag)
                                }, onError: { (error) in
                                    single(.error(error))
                                })
                                    .disposed(by: smallBag)
                            }
                        } else {
                            if let serverError = apiErrors.first {
                                apiError.title = serverError.title
                                apiError.subtitle = serverError.subtitle
                                apiError.statusCode = response.statusCode
                                apiError.type = serverError.type
                                single(.error(AppError.APIError(apiError: apiError)))
                            }
                        }
                        return
                    }

                    guard decodedData.1 == nil else {
                                           single(.error(decodedData.1!))
                                           return
                                       }

                    guard let data = decodedData.0 else {
                        let error = APIError()
                        error.title = "Error".localized
                        error.subtitle = "UnknownError".localized
                        single(.error(AppError.APIError(apiError: error)))
                        return
                    }

                    let tokenManager = TokenManager()
                    tokenManager.set(data.apiToken?.token, data.accessToken, data.refreshToken)
                    _ = tokenManager.saveToken()

                    single(.success(data))
                }, onError: { (error) in
                    single(.error(error))
                }).disposed(by: self.disposeBag)

            return Disposables.create()
        })
    }

    fileprivate func decoderJSON<T: Codable>(data: Data, codable: T.Type) -> (T?, Error?) {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decode = try decoder.decode(codable.self, from: data)
            let object: (T?, Error?) = (decode, nil)
            return object
        } catch {
            print(error)
            let object: (T?, Error?) = (nil, error)
            return object
        }
    }

    fileprivate func getClientToken() -> Single<ClientToken> {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        var urlRequest = URLRequest(url: URL(string: ServerConstants.fullApiPath + Constants.backend.apiRequests.getToken)!)

        let params = [
            "grant_type": "client_credentials",
            "client_id": "3",
            "client_secret": "OHzlIwvMXSeApDXFSjksywXCtJcwGlQWTpJdneQk"
        ]

        let postString = getPostString(params: params)
        urlRequest.httpBody = postString.data(using: .utf8)

        urlRequest.httpMethod = HTTPMethod.post.rawValue

        urlRequest.setValue("Accept", forHTTPHeaderField: "application/json")
        urlRequest.setValue("Content-Type", forHTTPHeaderField: "multipart/form-data")
        urlRequest.setValue("X-Requested-With", forHTTPHeaderField: "XMLHttpRequest")


        return Single.create(subscribe: { (single) in
            APIManager.sessionManager.rx.request(urlRequest: urlRequest).responseData()
                .subscribeOn(MainScheduler.asyncInstance)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (response, data) in
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false

                    let decodedData = self.decoderJSON(data: data, codable: ClientToken.self)

                    guard decodedData.1 == nil else {
                        single(.error(decodedData.1!))
                        return
                    }

                    guard let data = decodedData.0 else {
                        let error = APIError()
                        error.title = "Error".localized
                        error.subtitle = "UnknownError".localized
                        single(.error(error))
                        return
                    }

                    guard response.statusCode >= 200, response.statusCode < 300 else {
                        let apiError = APIError()
                        apiError.statusCode = response.statusCode

                        single(.error(AppError.APIError(apiError: apiError)))

                        return
                    }

                    #if DEBUG
                    print("Token is \(data.access_token ?? "nil")")
                    #endif

                    single(.success(data))
                }, onError: { (error) in
                    single(.error(error))
                }).disposed(by: self.disposeBag)

            return Disposables.create()
        })
    }
    
    func refreshToken(token: String) -> Single<ResponseModel<User>> {
        let url = ServerConstants.fullApiPath + Constants.backend.apiRequests.refreshToken
        let param = ["refresh_token": token]

        return self.makeRequest(method: .post, url: url, parameters: param)
    }

    fileprivate func getPostString(params:[String:Any]) -> String {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
}

// ------ API call methods ------
extension APIManager {

}
