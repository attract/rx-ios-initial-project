//
//  User.swift
//
//  Created by Artem Boyko on 5/7/19.
//  Copyright © 2019 Artem Boyko. All rights reserved.
//

import Foundation
import RxSwift

final class User: Codable {
    // var id: Int?
    
    init() {
        let defaults = UserDefaults.standard
        let userObject = defaults.data(forKey: "userDict")
        
        guard let object = userObject else {
            print("No keyedArchiver with userDict")
            return
        }
        
        do {
            let instance = try JSONDecoder().decode(User.self, from: object)
        } catch {
            print("can't decode user object: \(error)")
        }
    }
    
    func saveUser() -> Bool {
        do {
            let data = try JSONEncoder().encode(self)
            UserDefaults.standard.set(data, forKey: "userDict")
            return true
        } catch {
            return false
        }
    }
    
    func cleanInfo() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "userDict")
    }
}
