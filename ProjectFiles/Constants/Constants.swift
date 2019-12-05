//
//  Constants.swift
//
//  Created by Artem Boyko on 5/5/19.
//  Copyright © 2019 Artem Boyko. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    struct backend {
        struct apiRequests {
            static let getToken = "/some-getToken-request"
            static let refreshToken = "/some-refreshToken-request"
        }
        
        struct fieldNames {
            static let sampleField              = "sample-field"
        }
    }
    
    struct UI {
        struct Popup {
            struct Color {
                static let success = UIColor(hexString: "#1CCF4E")
                static let error = UIColor(hexString: "#F14358")
                static let warning = UIColor(hexString: "#F14358")
            }
            
            struct Image {
                static let success = #imageLiteral(resourceName: "BigNewCheck")
                static let error = #imageLiteral(resourceName: "error")
                static let warning = #imageLiteral(resourceName: "error")
            }
        }
    }
    
    struct application {
        public enum Environment {
            case development
            case production
        }
        
        struct errors {
            static let noConnectionErrorText    = "NoConnection".localized
            static let requestErrorText         = "RequestError".localized
            static let unknownErrorText         = "UnknownError".localized
        }
        
        static let currentLocalization = Bundle.main.localizations.first!
        static let environment: application.Environment = .development
    }
    
    public enum ErrorType: String {
        case noConnection       = "errNoInternetConnection"
        case responseError      = "errResponseError"
    }
}
