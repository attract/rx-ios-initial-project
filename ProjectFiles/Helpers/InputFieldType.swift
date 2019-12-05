//
//  InputFieldType.swift
//  DeliveryApp
//
//  Created by Dmytro Aprelenko on 1/15/19.
//  Copyright © 2019 Stanislav. All rights reserved.
//


import UIKit
import RxCocoa
import RxSwift

public enum InputFieldType {
    case password
    case email
    case plain
    case upcase_plain
    case phonenumber
    case numpad
}

extension Reactive where Base: UITextField {
    public var fieldType: Binder<InputFieldType> {
        return Binder(self.base) { input, type in
            switch type {
            case .email:
                input.keyboardType = .emailAddress
                input.textContentType = .emailAddress
                input.autocorrectionType = .no
            case .password:
                input.keyboardType = .default
                input.textContentType = .password
                input.autocorrectionType = .no
                input.isSecureTextEntry = true
            case .plain:
                input.keyboardType = .default
                input.textContentType = nil
                input.autocorrectionType = .default
                input.isSecureTextEntry = false
            case .upcase_plain:
                input.keyboardType = .default
                input.textContentType = nil
                input.autocorrectionType = .default
                input.isSecureTextEntry = false
                input.autocapitalizationType = .words
            case .phonenumber:
                input.keyboardType = .phonePad
                input.textContentType = .telephoneNumber
                input.smartInsertDeleteType = .yes
                input.isSecureTextEntry = false
            case .numpad:
                input.keyboardType = .numberPad
                input.textContentType = nil
                input.autocorrectionType = .default
                input.smartInsertDeleteType = .yes
                input.isSecureTextEntry = false
            }
        }
    }
    public var returnKeyType: Binder<UIReturnKeyType> {
        return Binder(self.base) { input, type in
            input.returnKeyType = type
        }
    }
    public var placeholder: Binder<String> {
        return Binder(self.base) { input, placeholder in
            input.placeholder = placeholder
        }
    }
    public var beFirst: Binder<Void> {
        return Binder(self.base) { input, _ in
            input.becomeFirstResponder()
        }
    }
    public var resignFirst: Binder<Void> {
        return Binder(self.base) { input, _ in
            input.resignFirstResponder()
        }
    }
}
