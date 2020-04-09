//
//  AppCoordinator.swift
//  crm-ios
//
//  Created by Dmytro Aprelenko on 31.03.2020.
//  Copyright © 2020 Stanislav. All rights reserved.
//

import Foundation
import UIKit

fileprivate enum LaunchInstructor {
  case main, auth
  
  static func configure() -> LaunchInstructor {
    
    var isAuthenticated = false
    if let token = TokenManager().accessToken, token.length > 0 {
        isAuthenticated = true
    }
    
    return isAuthenticated ? .main : .auth
  }
}

final class ApplicationCoordinator: BaseCoordinator {
  
  private let coordinatorFactory: CoordinatorFactory
  private let router: Router
  
  private var instructor: LaunchInstructor {
    return LaunchInstructor.configure()
  }
  
  init(router: Router, coordinatorFactory: CoordinatorFactory) {
    self.router = router
    self.coordinatorFactory = coordinatorFactory
  }
  
  override func start(with option: DeepLinkOption?) {
    //start with deepLink
    if let option = option {
      switch option {
      case .signUp: runAuthFlow()
      default: childCoordinators.forEach { coordinator in
        coordinator.start(with: option)
        }
      }
    // default start
    } else {
      switch instructor {
      case .auth: runAuthFlow()
      case .main: runMainFlow()
      }
    }
  }
  
  private func runAuthFlow() {
//    let coordinator = coordinatorFactory.makeAuthCoordinatorBox(router: router)
//    coordinator.finishFlow = { [weak self, weak coordinator] in
//      self?.start()
//      self?.removeDependency(coordinator)
//    }
//    addDependency(coordinator)
//    coordinator.start()
  }
  
  
  private func runMainFlow() {
//    let (coordinator, module) = coordinatorFactory.makeTabbarCoordinator()
//    addDependency(coordinator)
//    router.setRootModule(module, hideBar: true)
//    coordinator.start()
  }
}
