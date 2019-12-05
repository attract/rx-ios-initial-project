//
//  UITextFieldExtension.swift
//  
//
//  Created by Alex Kupchak on 29.08.17.
//  Copyright © 2017 Attract Group. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension UITextField {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.keyboardAppearance = .dark
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UITextField {
    public var rx_textColor: AnyObserver<UIColor> {
        return AnyObserver { [weak self] event in
            MainScheduler.ensureExecutingOnScheduler()
            
            switch event {
            case .next(let value):
                self?.textColor = value
            default:
                break
            }
        }
    }
}
