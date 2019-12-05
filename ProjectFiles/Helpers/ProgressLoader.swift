//
//  ProgressLoader.swift
//  DeliveryApp
//
//  Created by Stanislav on 1/11/19.
//  Copyright © 2019 Stanislav. All rights reserved.
//

import Foundation

import Foundation
import SVProgressHUD

fileprivate struct ProgressLoaderConstants {
    static let defaultTitle = "Loading".localized
}

final class ProgressLoader: NSObject {
    class func show(with title: String = ProgressLoaderConstants.defaultTitle) {
        SVProgressHUD.show(withStatus: "")
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setBackgroundColor(.clear)
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.setForegroundColor(.blue)
        SVProgressHUD.setMinimumSize(CGSize(width: 40, height: 40))
        SVProgressHUD.setRingRadius(40)
        SVProgressHUD.setRingThickness(3)
        SVProgressHUD.setRingNoTextRadius(40)
    }
    
    class func hide(withCompletion completion: @escaping SVProgressHUDDismissCompletion) {
        SVProgressHUD.dismiss(completion: completion)
    }
    
    class func hide() {
        SVProgressHUD.dismiss()
    }
}
