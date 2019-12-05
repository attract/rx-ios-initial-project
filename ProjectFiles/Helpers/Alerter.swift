//
//  Alerter.swift
//
//
//  Created by Stanislav Makushov on 12/10/2017.
//  Copyright © 2017 Stanislav Makushov. All rights reserved.
//

import Foundation
import UIKit
import BLTNBoard

fileprivate struct AlerterConstants {
    static let closeTitle   = "Close".localized
    static let retryTitle   = "Retry".localized
    static let cancelTitle  = "Cancel".localized
}

class Alerter: NSObject {
    class func success(title: String, description: String, image: UIImage? = nil, continueAction: (() -> Void)?) -> BLTNItemManager {
        
        let bulletinManager: BLTNItemManager = {
            
            let rootItem = BLTNPageItem(title: title == "" ? "Success" : title)
            rootItem.descriptionText = description
            rootItem.actionButtonTitle = "Continue".localized
            rootItem.isDismissable = true
            rootItem.requiresCloseButton = false
            
            rootItem.appearance.actionButtonColor = Constants.UI.Popup.Color.success
            rootItem.appearance.descriptionTextColor = .white
            rootItem.appearance.titleTextColor = .white
            rootItem.appearance.alternativeButtonTitleColor = UIColor(hexString: "#8991A0")
            
            rootItem.image = image == nil ? Constants.UI.Popup.Image.success : image
            
            rootItem.actionHandler = { item in
                item.manager?.dismissBulletin(animated: true)
                if let action = continueAction {
                    action()
                }
            }
            
            return BLTNItemManager(rootItem: rootItem)
        }()
        
        return bulletinManager
    }
    
    class func error(title: String, description: String, image: UIImage? = nil, retryAction: (() -> Void)?) -> BLTNItemManager {
        let bulletinManager: BLTNItemManager = {
            
            let rootItem = BLTNPageItem(title: title == "" ? "Error" : title)
            rootItem.descriptionText = description
            rootItem.isDismissable = true
            rootItem.requiresCloseButton = false
            
            rootItem.appearance.actionButtonColor = Constants.UI.Popup.Color.error
            rootItem.appearance.descriptionTextColor = .white
            rootItem.appearance.titleTextColor = .white
            rootItem.appearance.alternativeButtonTitleColor = UIColor(hexString: "#8991A0")
            //            rootItem.shouldCompactDescriptionText = true
            
            rootItem.image = image == nil ? Constants.UI.Popup.Image.error : image
            
            if let action = retryAction {
                rootItem.actionButtonTitle = "Retry".localized
                rootItem.actionHandler = { item in
                    item.manager?.dismissBulletin(animated: true)
                    action()
                }
                
                rootItem.alternativeButtonTitle = "Cancel".localized
                rootItem.alternativeHandler = { item in
                    item.manager?.dismissBulletin(animated: true)
                    // do nothing
                }
            } else {
                rootItem.actionButtonTitle = "Close".localized
                rootItem.actionHandler = { item in
                    item.manager?.dismissBulletin(animated: true)
                    // do nothing
                }
            }
            
            return BLTNItemManager(rootItem: rootItem)
        }()
        
        return bulletinManager
    }
    
    class func warning(title: String, description: String, image: UIImage? = nil, continueAction: (() -> Void)?) -> BLTNItemManager {
        
        let bulletinManager: BLTNItemManager = {
            
            let rootItem = BLTNPageItem(title: title == "" ? "Error" : title)
            rootItem.descriptionText = description
            rootItem.actionButtonTitle = "OK".localized
            rootItem.isDismissable = true
            rootItem.requiresCloseButton = false
            
            rootItem.appearance.actionButtonColor = Constants.UI.Popup.Color.warning
            
            rootItem.appearance.descriptionTextColor = .white
            rootItem.appearance.titleTextColor = .white
            rootItem.appearance.alternativeButtonTitleColor = UIColor(hexString: "#8991A0")
            
            rootItem.image = image == nil ? Constants.UI.Popup.Image.warning : image
            
            rootItem.actionHandler = { item in
                item.manager?.dismissBulletin(animated: true)
                if let action = continueAction {
                    action()
                }
            }
            
            return BLTNItemManager(rootItem: rootItem)
        }()
        
        return bulletinManager
    }
    
    class func custom(title: String, description: String, mainActionTitle: String, mainAction: (() -> Void)?, secondaryActionTitle: String? = nil, secondaryAction: (()->Void)? = nil, icon: UIImage? = nil, color: UIColor? = nil) -> BLTNItemManager {
        
        let bulletinManager: BLTNItemManager = {
            
            let rootItem = BLTNPageItem(title: title)
            rootItem.descriptionText = description
            rootItem.requiresCloseButton = false
            rootItem.appearance.descriptionTextColor = .white
            rootItem.appearance.titleTextColor = .white
            rootItem.appearance.alternativeButtonTitleColor = UIColor(hexString: "#8991A0")
            
            if let tintColor = color {
                rootItem.appearance.actionButtonColor = tintColor
            }
            
            if let icon = icon {
                rootItem.image = icon
            }
            
            rootItem.actionButtonTitle = mainActionTitle
            rootItem.alternativeButtonTitle = secondaryActionTitle
            //            rootItem.shouldCompactDescriptionText = true
            
            rootItem.isDismissable = true
            
            rootItem.actionHandler = { item in
                item.manager?.dismissBulletin(animated: true)
                if let mainAction = mainAction {
                    mainAction()
                }
            }
            
            if let alternativeAction = secondaryAction {
                rootItem.alternativeHandler = { item in
                    item.manager?.dismissBulletin(animated: true)
                    alternativeAction()
                }
            }
            
            return BLTNItemManager(rootItem: rootItem)
        }()
        
        return bulletinManager
    }
    
    class func confirm(title: String, description: String, color: UIColor? = nil, image: UIImage? = nil, actionTitle: String, action: @escaping() -> Void) -> BLTNItemManager {
        let bulletinManager: BLTNItemManager = {
            
            let rootItem = BLTNPageItem(title: title == "" ? "Confirmation" : title)
            rootItem.descriptionText = description
            rootItem.isDismissable = true
            rootItem.requiresCloseButton = false
            
            rootItem.appearance.descriptionTextColor = .white
            rootItem.appearance.titleTextColor = .white
            rootItem.appearance.alternativeButtonTitleColor = UIColor(hexString: "#8991A0")
            
            if let tintColor = color {
                rootItem.appearance.actionButtonColor = tintColor
            }
            //            rootItem.shouldCompactDescriptionText = true
            
            rootItem.image = image
            
            rootItem.actionButtonTitle = actionTitle
            rootItem.actionHandler = { item in
                item.manager?.dismissBulletin(animated: true)
                action()
            }
            
            rootItem.alternativeButtonTitle = "Cancel".localized
            rootItem.alternativeHandler = { item in
                item.manager?.dismissBulletin(animated: true)
                // do nothing
            }
            
            return BLTNItemManager(rootItem: rootItem)
        }()
        
        return bulletinManager
    }
    
    class func info(title: String = "", description: NSAttributedString, image: UIImage? = nil) -> BLTNItemManager {
        let bulletinManager: BLTNItemManager = {
            
            let rootItem = BLTNPageItem(title: title)
            rootItem.attributedDescriptionText = description
            rootItem.isDismissable = true
            rootItem.requiresCloseButton = false
            rootItem.appearance.descriptionTextColor = .white
            rootItem.appearance.titleTextColor = .white
            rootItem.appearance.alternativeButtonTitleColor = UIColor(hexString: "#8991A0")
            
            rootItem.image = image
            
            //            rootItem.shouldCompactDescriptionText = true
            
            return BLTNItemManager(rootItem: rootItem)
        }()
        
        return bulletinManager
    }
}

//final class Alerter {
//
//    func showSuccess(text: String, description: NSAttributedString?, in viewController: BasicViewController, closeAction: (() -> Void)? = nil) {
//        let alerterView = AlerterView.instanceFromNib(type: .success, text: text, description: description)
//        self.showAlerter(alerterView: alerterView, in: viewController, closeAction: closeAction, retryAction: nil)
//    }
//
//    func showError(text: String, description: NSAttributedString?, in viewController: BasicViewController, closeAction: (() -> Void)? = nil, retryAction: (() -> Void)? = nil) {
//        let alerterView = AlerterView.instanceFromNib(type: .error, text: text, description: description)
//        self.showAlerter(alerterView: alerterView, in: viewController, closeAction: closeAction, retryAction: retryAction)
//    }
//
//    func showConfirm(text: String, in viewController: BasicViewController, confirmTitle: String, confirmAction: @escaping (() -> Void)) {
//        let alertController = self.createAlerter(with: text)
//        alertController.addAction(UIAlertAction(title: confirmTitle, style: .destructive, handler: { (action) in
//            confirmAction()
//        }))
//
//        alertController.addAction(UIAlertAction(title: AlerterConstants.cancelTitle, style: .cancel, handler: nil))
//
//        viewController.present(alertController, animated: true, completion: nil)
//    }
//
//    func showAttributedConfirm(text: String, description: NSAttributedString? = nil, in viewController: BasicViewController, confirmTitle: String, confirmAction: @escaping (() -> Void)) {
//        let alerterView = AlerterView.instanceFromNib(type: .error, text: text, description: description)
//
//        self.showAlerter(alerterView: alerterView, in: viewController, closeAction: nil, retryAction: confirmAction, closeTitle: "Cancel".localized, retryTitle: confirmTitle)
//    }
//
//    func showAttributedInfo(title: NSAttributedString, description: NSAttributedString, messageLocation viewController: BasicViewController, actionTitle: String, action:  @escaping (() -> Void)) {
//
//        let alerterView = AlerterView.instanceAttributedInfoAlerter(title: title, text: description)
//
//        self.showAlerter(alerterView: alerterView, in: viewController, closeAction: action, retryAction: nil, closeTitle: actionTitle, retryTitle: nil, forInfo: true)
//    }
//
//    func showCustom(title: String, description: String,  messageLocation viewController: BasicViewController, firstActionTitle: String, firstAction:  @escaping (() -> Void), secondActionTitle: String? = nil, secondAction:(() -> Void)? = nil){
//        let alertController = self.createAlerter(with: description, title: title)
//        alertController.addAction(UIAlertAction(title: firstActionTitle, style: .default, handler: { (action) in
//            firstAction()
//        }))
//        if let secondTitle = secondActionTitle, secondAction != nil{
//            alertController.addAction(UIAlertAction(title: secondTitle, style: .default, handler: { (action) in
//                secondAction!()
//            }))
//        }
//        alertController.addAction(UIAlertAction(title: AlerterConstants.cancelTitle, style: .cancel, handler: { action in
//        }))
//        viewController.present(alertController, animated: true, completion: nil)
//    }
//}
//
//private extension Alerter {
//    func addConstraints(to alerterView: AlerterView) {
//        alerterView.translatesAutoresizingMaskIntoConstraints = false
//        alerterView.addConstraint(NSLayoutConstraint(item: alerterView,
//                                                    attribute: .height,
//                                                    relatedBy: .equal,
//                                                    toItem: nil,
//                                                    attribute: .notAnAttribute,
//                                                    multiplier: 1,
//                                                    constant: alerterView.bounds.size.height - 40))
//    }
//
//    func addInfoConstraints(to alerterView: AlerterView) {
//        alerterView.translatesAutoresizingMaskIntoConstraints = false
//        alerterView.addConstraint(NSLayoutConstraint(item: alerterView,
//                                                     attribute: .height,
//                                                     relatedBy: .equal,
//                                                     toItem: nil,
//                                                     attribute: .notAnAttribute,
//                                                     multiplier: 1,
//                                                     constant: alerterView.descriptionLabelHeight + alerterView.textLabelHeight + 46))
//    }
//
//    func createAlerter(with alerterView: AlerterView) -> UIAlertController {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return UIAlertController(title: nil, customView: alerterView, preferredStyle: .actionSheet)
//        } else {
//            return UIAlertController(title: nil, customView: alerterView, preferredStyle: .alert)
//        }
//    }
//
//    func createAlerter(with text: String, title: String? = nil) -> UIAlertController {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return UIAlertController(title: title, message: text, preferredStyle: .actionSheet)
//        } else {
//            return UIAlertController(title: title, message: text, preferredStyle: .alert)
//        }
//    }
//
//    func showAlerter(alerterView: AlerterView, in viewController: BasicViewController, closeAction: (() -> Void)? = nil, retryAction: (() -> Void)? = nil, closeTitle: String? = nil, retryTitle: String? = nil, forInfo: Bool = false) {
//
//        if forInfo {
//            self.addInfoConstraints(to: alerterView)
//        } else {
//            self.addConstraints(to: alerterView)
//        }
//
//        alerterView.layoutIfNeeded()
//        let controller = self.createAlerter(with: alerterView)
//
//        controller.addAction(UIAlertAction(title: closeTitle == nil ? AlerterConstants.closeTitle : closeTitle ?? AlerterConstants.closeTitle, style: .cancel, handler: { action in
//            if let action = closeAction {
//                action()
//            }
//        }))
//
//        if let rAction = retryAction {
//            controller.addAction(UIAlertAction(title: retryTitle == nil ? AlerterConstants.retryTitle : retryTitle ?? AlerterConstants.retryTitle, style: .default, handler: { action in
//                rAction()
//            }))
//        }
//
//        viewController.present(controller, animated: true, completion: nil)
//        TapticEngine.shared.makeTapticFeedback(alerterView.type == .success ? .success : .error)
//    }
//}

