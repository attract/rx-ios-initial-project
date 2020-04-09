//
//  LottieView.swift
//  crm-ios
//
//  Created by Artem Boyko on 25.02.2020.
//  Copyright © 2020 Stanislav. All rights reserved.
//

import UIKit
import Lottie
import RxSwift
import RxCocoa

class LottieView: UIView {
    
    // MARK: - Variable
    let animationNamed: BehaviorSubject<String?> = BehaviorSubject(value: nil)
    let playWithMode: BehaviorSubject<LottieLoopMode?> = BehaviorSubject(value: nil)
    let animationView = AnimationView()
    let disposeBag = DisposeBag()
    // MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Observable.combineLatest(self.playWithMode, self.animationNamed)
            .filter({ (mode, name) -> Bool in
                self.animationView.isHidden = mode == nil || name == nil
                return mode != nil && name != nil
            })
            .subscribe(onNext: { (loopMode, name) in
                self.animationView.animation = Animation.named(name!)
                self.animationView.play(fromProgress: 0,
                    toProgress: 1,
                    loopMode: loopMode,
                    completion: nil)
            })
            .disposed(by: disposeBag)
        animationView.contentMode = .scaleAspectFit
        animationView.backgroundBehavior = .pauseAndRestore
        
        self.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: animationView,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .trailing,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: animationView,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .leading,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: animationView,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .top,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: animationView,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .bottom,
                           multiplier: 1,
                           constant: 0).isActive = true
    }
}
