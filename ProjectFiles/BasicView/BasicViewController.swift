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

fileprivate struct BasicControllerConstants {
    static let alerterItemTitle = "title"
    static let userKey = "userDict"
}

class BasicViewController: UIViewController {
    

    let disposeBag = DisposeBag()
    
    fileprivate var _currentUser: BehaviorSubject<User> = BehaviorSubject(value: User())
    
    fileprivate var _tokenManager: BehaviorSubject<TokenManager> = BehaviorSubject(value: TokenManager())
    
    var tokenManager: Observable<TokenManager> {
        return self._tokenManager.asObservable()
    }
    
    var currentUser: Observable<User> {
        return self._currentUser.asObservable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        UserDefaults.standard
            .rx.observe(User.self, BasicControllerConstants.userKey)
            .subscribe(onNext: { [weak self] user in
                self?._currentUser.onNext(user ?? User())
            })
            .disposed(by: disposeBag)
    }
}
