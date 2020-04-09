//
//  Alerter.swift
//  crm-ios
//
//  Created by Dmytro Aprelenko on 20.02.2020.
//  Copyright © 2020 Stanislav. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

fileprivate struct AlerterConstants {
    static let closeTitle   = "Close".localized
    static let retryTitle   = "Retry".localized
    static let cancelTitle  = "Cancel".localized
}

class Alerter {
    var disposeBag = DisposeBag()
    
    func showPopUp(title: String, image: UIImage? = nil, lottieNamed: String? = nil, onDisapear: (() -> Void)? = nil) {
        let vc = UIStoryboard(name: "PopUp", bundle: nil).instantiateInitialViewController() as! PopUp
        vc.preparePopUp()
        vc.modalPresentationStyle = .overFullScreen
        vc.popText.onNext(title)
        vc.popImage.onNext(image)
        vc.lottieNamed.onNext(lottieNamed)
        vc.lottiePlayWithMode.onNext(.playOnce)
        vc.popDidDisaper
            .asObservable()
            .ignoreNil()
            .bind { (_) in
                if let action = onDisapear {
                    action()
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    func showPopUpWithActions(title: String, image: UIImage? = nil, lottieNamed: String? = nil, firstAction: BehaviorSubject<Void?>? = nil, secondAction: BehaviorSubject<Void?>? = nil, onDisapear: BehaviorSubject<Void?>? = nil, firstBtnTitle: String? = nil, secondBtnTitle: String? = nil) {
        let vc = UIStoryboard(name: "PopUp", bundle: nil).instantiateInitialViewController() as! PopUp
        /// Must be
        vc.preparePopUp()
        vc.modalPresentationStyle = .overFullScreen
        vc.popText.onNext(title)
        vc.popImage.onNext(image)
        vc.lottieNamed.onNext(lottieNamed)
        vc.lottiePlayWithMode.onNext(.loop)
        if let disaper = onDisapear {
            vc.popDidDisaper
                .asObservable()
                .ignoreNil()
                .bind(to: disaper)
                .disposed(by: vc.disposeBag)
        }
        
        if let firstTitle = firstBtnTitle {
            vc.firstBtnTitle.onNext(firstTitle)
        }
        
        if let secondTitle = secondBtnTitle {
            vc.secondBtnTitle.onNext(secondTitle)
        }
        
        if firstAction != nil {
            vc.firstAction
                .asObservable()
                .ignoreNil()
                .subscribe(onNext: { (_) in
                    firstAction!.onNext(())
                    vc.dismiss(animated: true, completion: nil)
                })
                .disposed(by: vc.disposeBag)
        }
        
        if let secondAction = secondAction {
            vc.secondAction
                .asObservable()
                .ignoreNil()
                .bind(to: secondAction)
                .disposed(by: vc.disposeBag)
        } else {
            vc.secondAction.asObservable().ignoreNil().subscribe(onNext: { (_) in
                vc.dismiss(animated: true, completion: nil)
            }).disposed(by: vc.disposeBag)
        }
    }
    
    func showError(title: String, description: NSAttributedString? = nil, continueAction: (() -> Void)? = nil, retryAction: (() -> Void)? = nil) {
        self.showPopUp(title: title, lottieNamed: "error")
    }
}
