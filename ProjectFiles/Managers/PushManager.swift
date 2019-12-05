//
//  PushManager.swift
//  Beehives
//
//  Created by Stanislav on 19.06.2018.
//  Copyright © 2018 Stanislav Makushov. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications
import RxSwift
import RxCocoa

class PushManager {
    static let shared = PushManager()
    
    fileprivate let tokenKey                = "push_token"
    fileprivate let authRequestedKey        = "auth_requested"
    fileprivate let tokenWasSavedOnBack     = "tokenWasSavedOnBack"
    fileprivate let firebaseTokenKey        = "fb_token"
    
    let disposeBag = DisposeBag()
    
    var token: String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    var fbToken: String? {
        return UserDefaults.standard.string(forKey: firebaseTokenKey)
    }
    
    var authWasRequested: Bool {
        return UserDefaults.standard.bool(forKey: authRequestedKey)
    }
    
    var isTokenSavedOnBack: Bool {
        return UserDefaults.standard.bool(forKey: tokenWasSavedOnBack)
    }
    
    func registerForNotifications(_ completion: @escaping ((Bool, Error?) -> Void)) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .alert, .sound]) { (isSuccess, error) in
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                completion(isSuccess, error)
            }
        }

        UserDefaults.standard.set(true, forKey: authRequestedKey)
    }
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    func saveFirebaseToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: firebaseTokenKey)
        
//        if self.token != nil {
//            self.subscribeToPushes()
//        }
    }
    
//    func subscribeToPushes() {
//        guard let pushToken = self.fbToken else { return }
//
//        let params: [String:Any] = [
//            "token" : pushToken,
//            "device_id" : (UIDevice.current.identifierForVendor?.uuidString ?? ""),
//            "os": "ios"
//        ]
//
//        APIManager.shared.subscribeForPushes(dict: params)
//            .subscribe(onNext: { (responseModel) in
//                guard !responseModel.isNil else { return }
//
//                if let _ = responseModel.data {
//                    UserDefaults.standard.set(true, forKey: self.tokenWasSavedOnBack)
//                    print("Successfully subscribed for pushes")
//                }
//            }, onError: { (error) in
//                if let apiError = error as? APIError {
//                    print(apiError.subtitle ?? "")
//                } else {
//                    print(error.localizedDescription)
//                }
//            })
//            .disposed(by: disposeBag)
//    }
}
