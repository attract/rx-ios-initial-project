//
//  AppDelegate.swift
//  rx-ios-initial-project
//
//  Created by Stanislav on 05.12.2019.
//  Copyright © 2019 Stanislav. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var rootController: UINavigationController {
      return self.window!.rootViewController as! UINavigationController
    }
    
    private lazy var applicationCoordinator: Coordinator = self.makeCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let notification = launchOptions?[.remoteNotification] as? [String: AnyObject]
        let deepLink = DeepLinkOption.build(with: notification)
        applicationCoordinator.start(with: deepLink)
        
        return true
    }
    
    //MARK: Handle push notifications and deep links
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
      let dict = userInfo as? [String: AnyObject]
      let deepLink = DeepLinkOption.build(with: dict)
      applicationCoordinator.start(with: deepLink)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
      let deepLink = DeepLinkOption.build(with: userActivity)
      applicationCoordinator.start(with: deepLink)
      return true
    }
}

extension AppDelegate {
    private func makeCoordinator() -> Coordinator {
        return ApplicationCoordinator(
          router: RouterImp(rootController: self.rootController),
          coordinatorFactory: CoordinatorFactoryImp()
        )
    }
}
