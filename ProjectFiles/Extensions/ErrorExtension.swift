//
//  ErrorExtension.swift
//  Beehives
//
//  Created by Mac on 8/1/18.
//  Copyright © 2018 Stanislav Makushov. All rights reserved.
//

import UIKit

public enum MyError: Error {
    case customError
}

class LocalError: NSObject, LocalizedError {
    var desc = ""
    init(_ str: String) {
        desc = str
    }
    override var description: String {
        get {
            return "\(desc)"
        }
    }
    
    public var errorDescription: String? {
        get {
            return self.description
        }
    }
}
