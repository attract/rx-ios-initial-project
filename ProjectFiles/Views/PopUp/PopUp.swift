//
//  PopUp.swift
//  Blue Moon
//
//  Created by Dmytro Aprelenko on 01.11.2019.
//  Copyright © 2019 Attract Group. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie

class PopUp: BasicViewController {

    private var window: UIWindow?
    
    @IBOutlet private weak var popUpView: UIView!
    @IBOutlet private weak var holdView: UIView!
    @IBOutlet private weak var popUpImage: UIImageView!
    @IBOutlet private weak var popUpText: UILabel!
    @IBOutlet weak var lottieView: LottieView!
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    
    let popImage: BehaviorSubject<UIImage?> = BehaviorSubject(value: nil)
    let lottieNamed: BehaviorSubject<String?> = BehaviorSubject(value: nil)
    let lottiePlayWithMode: BehaviorSubject<LottieLoopMode?> = BehaviorSubject(value: nil)
    let popText: BehaviorSubject<String?> = BehaviorSubject(value: nil)
    let popDidDisaper: BehaviorSubject<Void?> = BehaviorSubject(value: nil)
    let firstAction: BehaviorSubject<Void?> = BehaviorSubject(value: nil)
    let secondAction: BehaviorSubject<Void?> = BehaviorSubject(value: nil)
    let firstBtnTitle: BehaviorSubject<String?> = BehaviorSubject(value: nil)
    let secondBtnTitle: BehaviorSubject<String?> = BehaviorSubject(value: nil)
    
    
    private let returnToSuggestedHeight: BehaviorSubject<Void?> = BehaviorSubject(value: nil)
    private var originCenter: CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        configureView()
        bind()
        
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
        
        popUpView.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updatePopView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        popDidDisaper.onNext(())
        window = nil
    }
    
    func preparePopUp() {
        let vc = UIViewController()
        vc.view.backgroundColor = .clear

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = vc
        window?.windowLevel = UIWindow.Level.alert + 1
        window?.makeKeyAndVisible()
        
        vc.present(self, animated: false, completion: nil)
    }
    
    // Handle tap gesture recognizer
    @objc func handleCardTap(recognzier:UITapGestureRecognizer) {
        switch recognzier.state {
        case .ended:
            closeView()
        default:
            break
        }
    }
    
    // Handle pan gesture recognizer
    @objc func handleCardPan (recognizer:UIPanGestureRecognizer) {
        
        if recognizer.state == .began || recognizer.state == .changed {
            
            let translation = recognizer.translation(in: self.view)
            guard translation.y > 0 || self.originCenter.y < recognizer.view!.center.y else {
                return
            }
            guard let recognizerView = recognizer.view else {return}
            recognizerView.center = CGPoint(x: recognizerView.center.x, y: recognizerView.center.y + translation.y)
            
            let difference = recognizerView.center.y - self.originCenter.y
            
            if translation.y > 8 || difference > 100 {
                closeView()
            }
            
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    
    func bind() {
        self.popImage
            .asObservable()
            .bind(to: self.popUpImage.rx.image)
            .disposed(by: disposeBag)
        
        self.popImage
            .asObservable()
            .map{$0 == nil}
            .bind(to: self.popUpImage.rx.isHidden)
            .disposed(by: disposeBag)
        
        self.popText
            .asObservable()
            .bind(to: self.popUpText.rx.text)
            .disposed(by: disposeBag)
        
        self.firstButton.rx.tap
            .bind(to: self.firstAction)
            .disposed(by: disposeBag)
        
        self.secondButton.rx.tap
            .bind(to: self.secondAction)
            .disposed(by: disposeBag)
        
        self.firstBtnTitle
            .bind(to: self.firstButton.rx.title())
            .disposed(by: disposeBag)
        
        self.secondBtnTitle
            .bind(to: self.secondButton.rx.title())
            .disposed(by: disposeBag)
        
        self.firstBtnTitle
            .map({$0?.isEmpty ?? true})
            .bind(to: self.firstButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        self.secondBtnTitle
            .map({$0?.isEmpty ?? true})
            .bind(to: self.secondButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        self.lottieNamed
            .bind(to: self.lottieView.animationNamed)
            .disposed(by: disposeBag)
        
        self.lottiePlayWithMode
            .bind(to: self.lottieView.playWithMode)
            .disposed(by: disposeBag)
    }
    
    func updatePopView() {
        UIView.animate(withDuration: 0.6, animations: {
            self.bottomConstraint.constant = -30
            self.popUpText.alpha = 1
            self.view.layoutIfNeeded()
            self.originCenter = self.popUpView.center
        })
    }
    
    func configureView() {
        let popUpHeight = popUpView.bounds.height - 60
        bottomConstraint.constant = -popUpHeight
        self.popUpText.alpha = 0
        self.view.layoutIfNeeded()
    }
    
    func closeView() {
        UIView.animate(withDuration: 0.6, animations: {
            self.bottomConstraint.constant = -self.popUpView.bounds.height + 30
            self.view.layoutSubviews()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            self.dismiss(animated: false, completion: nil)
        })
    }
}
