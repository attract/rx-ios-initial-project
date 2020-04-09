//
//  Binding+Additions.swift
//  crm-ios
//
//  Created by Artem Boyko on 07.02.2020.
//  Copyright © 2020 Stanislav. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIView {
    public var isVisible: Binder<Bool> {
        return Binder(self.base) { view, visible in
            view.isHidden = !visible
        }
    }
}

extension Reactive where Base: UIImageView {
    public var tintColor: Binder<UIColor> {
        return Binder(self.base) { base, color in
            base.tintColor = color
        }
    }
}

extension Reactive where Base: UIView {
    public var isVisibleAnimate: Binder<Bool> {
        return Binder(self.base) { view, isVisibleAnimate in
            guard isVisibleAnimate == view.isHidden else {
                return
            }
            if isVisibleAnimate {
                view.isHidden = false
                view.alpha = 0.0
                view.superview?.layoutIfNeeded()
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                    view.alpha = 1.0
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                    view.alpha = 0.0
                }, completion: { (completed) in
                    view.isHidden = true
                })
            }
        }
    }
}

public protocol OptionalType {
    associatedtype Wrapped
    
    var optional: Wrapped? { get }
}

extension Optional: OptionalType {
    public var optional: Wrapped? { return self }
}

// Unfortunately the extra type annotations are required, otherwise the compiler gives an incomprehensible error.
extension Observable where Element: OptionalType {
    func ignoreNil() -> Observable<Element.Wrapped> {
        return flatMap { value in
            value.optional.map { Observable<Element.Wrapped>.just($0) } ?? Observable<Element.Wrapped>.empty()
        }
    }
}

extension Driver where Element: OptionalType {
    func ignoreNil() -> Driver<Element.Wrapped> {
        return flatMap { value in
            value.optional.map { Driver<Element.Wrapped>.just($0) } ?? Driver<Element.Wrapped>.empty()
        }
    }
}
