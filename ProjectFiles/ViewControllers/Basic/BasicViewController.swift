//
//  BasicViewController.swift
//  VeezApp
//
//  Created by Artem Boyko on 5/6/19.
//  Copyright © 2019 Artem Boyko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reachability
import RxKeyboard
import BLTNBoard

fileprivate struct BasicControllerConstants {
    static let alerterItemTitle = "title"
    static let userKey = "userDict"
    static let authStoryboardName = "Start"
    static let mainStoryboardName = "Main"
}

class BasicViewController: UIViewController {
    
    lazy var bulletinManager: BLTNItemManager = {
        
        let rootItem = BLTNPageItem(title: "title")
        return BLTNItemManager(rootItem: rootItem)
    }()

    fileprivate let reachability = try! Reachability()
    fileprivate let isReachableConnectivity: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: true)
    let disposeBag = DisposeBag()
    
    fileprivate let alerter = Alerter()
    
    fileprivate var _currentUser: BehaviorSubject<User> = BehaviorSubject(value: User())
    
    fileprivate var _tokenManager: BehaviorSubject<TokenManager> = BehaviorSubject(value: TokenManager())
    
    var tokenManager: Observable<TokenManager> {
        return self._tokenManager.asObservable()
    }
    
    var currentUser: Observable<User> {
        return self._currentUser.asObservable()
    }

    var isReachable: Observable<Bool> {
        return isReachableConnectivity.asObservable()
    }
    
    var isNowReachable: Bool {
        do {
            return try self.isReachableConnectivity.value()
        } catch {
            print(error)
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupReachabilityObserver()
        
        
        UserDefaults.standard
            .rx.observe(User.self, BasicControllerConstants.userKey)
            .subscribe(onNext: { [weak self] user in
                self?._currentUser.onNext(user ?? User())
            })
            .disposed(by: disposeBag)
    }
}

// Reachability
extension BasicViewController {
    fileprivate func setupReachabilityObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            self.isReachableConnectivity.onNext(false)
        }
    }
    
    @objc fileprivate func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
            self.isReachableConnectivity.onNext(true)
        case .cellular:
            print("Reachable via Cellular")
            self.isReachableConnectivity.onNext(true)
        case .none, .unavailable:
            print("Network not reachable")
            self.isReachableConnectivity.onNext(false)
        }
    }
}

// Auth
extension BasicViewController {
    
    func logout() {
        User().cleanInfo()
        TokenManager().clear()
        UIApplication.shared.applicationIconBadgeNumber = 0
        self.showAuthScreen()
    }
    
    func showAuthScreen() {
        if let vc = UIStoryboard(name: BasicControllerConstants.authStoryboardName, bundle: nil).instantiateInitialViewController() {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                UIApplication.shared.delegate?.window??.rootViewController = vc
            }
        }
    }
    
    func showMainScreen() {
        DispatchQueue.main.async {
            if let vc = UIStoryboard(name: BasicControllerConstants.mainStoryboardName, bundle: nil).instantiateInitialViewController() {
                UIApplication.shared.delegate?.window??.rootViewController = vc
            }
        }
    }
    
    func handle(error: Error, repeatAction: @escaping () -> Void) {
        guard let apiError = error as? APIError else {
            print(error.localizedDescription)
            self.showErrorScreen(withType: .responseError, andRefreshAction: repeatAction)
            return
        }
        
        guard apiError.statusCode != 401 else {
            self.logout()
            return
        }
        
        let apiErrorCodes = [400, 403, 404]
        
        guard !apiErrorCodes.contains(apiError.statusCode ?? 0) else {
            if let errorText = apiError.subtitle {
                self.showError(title: "", description: errorText)
                return
            }
            
            self.showErrorScreen(withType: .responseError, andRefreshAction: repeatAction)
            return
        }
        
        guard apiError.statusCode != 500 else {
            self.showErrorScreen(withType: .responseError, andRefreshAction: repeatAction)
            return
        }
        
        self.showError(title: "", description: apiError.subtitle ?? "")
    }
    
    func showErrorScreen(withType type: Constants.ErrorType, text: String? = nil, andRefreshAction action: @escaping () -> Void) {
        
        let errorText: String = text == nil ? (type == .noConnection ? Constants.application.errors.noConnectionErrorText : Constants.application.errors.requestErrorText) : text!
        
        self.showError(title: "", description: errorText, retryAction: action)
    }
}

// MARK: Alerter actions
extension BasicViewController {
        func showSuccess(title: String, description: String, image: UIImage? = nil, continueAction: (() -> Void)? = nil) {
            guard self.bulletinManager.isShowingBulletin == false else {
                return
            }
            self.bulletinManager = Alerter.success(title: title, description: description, image: image, continueAction: continueAction)
            
            self.finishDisplayingBulletin(.success)
        }
        
        func showWarning(title: String, description: String, image: UIImage? = nil, continueAction: (() -> Void)? = nil) {
            guard self.bulletinManager.isShowingBulletin == false else {
                return
            }
            self.bulletinManager = Alerter.warning(title: title, description: description, image: image, continueAction: continueAction)
            
            self.finishDisplayingBulletin(.warning)
        }
        
        func showError(title: String, description: String, image: UIImage? = nil, retryAction: (() -> Void)? = nil) {
            guard self.bulletinManager.isShowingBulletin == false else {
                return
            }
            self.bulletinManager = Alerter.error(title: title, description: description, image: image, retryAction: retryAction)
            
            self.finishDisplayingBulletin(.error)
        }
        
        func showCustom(title: String, description: String, mainActionTitle: String, mainAction: (() -> Void)? = nil, secondaryActionTitle: String? = nil, secondaryAction: (() -> Void)? = nil, icon: UIImage? = nil, color: UIColor? = nil) {
            guard self.bulletinManager.isShowingBulletin == false else {
                return
            }
            
            self.bulletinManager = Alerter.custom(title: title, description: description, mainActionTitle: mainActionTitle, mainAction: mainAction, secondaryActionTitle: secondaryActionTitle, secondaryAction: secondaryAction, icon: icon, color: color)
            
            self.finishDisplayingBulletin(.success)
        }
        
        func showConfirm(title: String, description: String, color: UIColor?, image: UIImage?, actionTitle: String, cancelTitle: String = "Cancel", action: @escaping() -> Void) {
            
            guard self.bulletinManager.isShowingBulletin == false else {
                return
            }
            
            self.bulletinManager = Alerter.confirm(title: title, description: description, color: color, image: image, actionTitle: actionTitle, action: action)
            
            self.finishDisplayingBulletin(.success)
        }
        
        func showInfo(title: String = "", description: NSAttributedString, image: UIImage? = nil) {
            guard self.bulletinManager.isShowingBulletin == false else {
                return
            }
            
            self.bulletinManager = Alerter.info(title: title, description: description, image: image)
            
            self.finishDisplayingBulletin(.success)
        }
        
        fileprivate func finishDisplayingBulletin(_ type: TapticEngine.TapticType) {
            let viewControllerToPresent = self.tabBarController == nil ? self : self.tabBarController!
            self.bulletinManager.backgroundColor = UIColor(hexString: "#3E424C")
            self.bulletinManager.showBulletin(above: viewControllerToPresent, animated: true, completion: nil)
            self.makeTapticFeedback(type)
        }
        
        func makeTapticFeedback(_ type: TapticEngine.TapticType) {
            TapticEngine.shared.makeTapticFeedback(type)
        }
}
