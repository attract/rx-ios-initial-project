//
//  TargetHelper.swift
//  DeliveryApp
//
//  Created by Stanislav on 1/14/19.
//  Copyright © 2019 Stanislav. All rights reserved.
//

import Foundation

enum AppTarget {
    case customer
    case driver
    case unknown
}

fileprivate struct TargetHelperConstants {
    static let customerDev      = "DeliveryApp"
    static let customerProd     = "DeliveryApp Prod"
    static let driverDev        = "DeliveryDriver"
    static let driverProd       = "DeliveryDriver Prod"
}

final class TargetHelper {
    static let shared = TargetHelper()
    
    var current: AppTarget {
        guard let targetName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String else {
            return .unknown
        }
        
        switch targetName {
        case TargetHelperConstants.customerDev:
            return .customer
        case TargetHelperConstants.customerProd:
            return .customer
        case TargetHelperConstants.driverDev:
            return .driver
        case TargetHelperConstants.driverProd:
            return .driver
        default:
            return .unknown
        }
    }
}
