//
//  TokenManager.swift
//  DeliveryApp
//
//  Created by Stanislav on 12/25/18.
//  Copyright © 2018 Stanislav. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

fileprivate struct TokenConstants {
    static let tokenKey = "access_token"
}

final class TokenManager: Codable {
    fileprivate var _accessToken: String?
    fileprivate var _refreshToken: String?
    fileprivate var _clientToken: String?
    
    var accessToken: String? {
        return self._accessToken
    }
    
    var refreshToken: String? {
        return self._refreshToken
    }
    
    var clientToken: String? {
        return self._clientToken
    }
    
    init() {
        let defaults = UserDefaults.standard
        let tokenObject = defaults.data(forKey: TokenConstants.tokenKey)
        
        guard let object = tokenObject else {
            print("No keyedArchiver with tokenObject")
            return
        }
        
        do {
            let instance = try JSONDecoder().decode(TokenManager.self, from: object)
            self._accessToken = instance._accessToken
            self._clientToken = instance._clientToken
            self._refreshToken = instance._refreshToken
        } catch {
            print("can't decode token object: \(error)")
        }
    }
    
    func set(_ clientToken: String?, _ accessToken: String?, _ refreshToken: String?) {
        if let token = clientToken {
            self._clientToken = token
        }
        if let token = accessToken {
            self._accessToken = token
        }
        if let token = refreshToken {
            self._refreshToken = token
        }
    }
    
    func saveToken() -> Bool {
        do {
            let data = try JSONEncoder().encode(self)
            UserDefaults.standard.set(data, forKey: TokenConstants.tokenKey)
            return true
        } catch {
            return false
        }
    }
    
    func clear() {
        self._accessToken = nil
        self._clientToken = nil
        self._refreshToken = nil
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: TokenConstants.tokenKey)
    }
}
