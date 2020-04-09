//
//  HoLoGoInput.swift
//  Hologo
//
//  Created by Dmytro Aprelenko on 13.09.2019.
//  Copyright © 2019 Stanislav. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class Input: NibReusable {

    private(set) var disposeBag = DisposeBag()
    
    
    @IBOutlet weak var inputStack: UIStackView!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var viewWithShadow: UIView!
    
    @IBOutlet weak var lowerLabel: UILabel!
    
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var imgForRightView: UIImageView!
    @IBOutlet weak var rightViewBtn: UIButton!
    
    /// Change input type for your needs
    var inputType: InputType = .regular(title: "Title", textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.602770762), needsRightView: false) {
        didSet {
            disposeBag = DisposeBag()
            bind()
            stylize()
            createToolbar()
        }
    }
    
    /// Drive an AppError to 'error' for the ui error changes
    var error: BehaviorSubject<AppError?> = BehaviorSubject(value: nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bind()
        stylize()
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let _ = viewWithShadow{
            DispatchQueue.main.async {
                self.viewWithShadow.layer.cornerRadius = 14
                self.viewWithShadow.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
                self.viewWithShadow.layer.shadowOpacity = 1
                self.viewWithShadow.layer.shadowPath = UIBezierPath(roundedRect: self.viewWithShadow.bounds, cornerRadius: 12).cgPath
                self.viewWithShadow.layer.masksToBounds = false
                self.viewWithShadow.layer.shadowOffset = CGSize(width: 0, height: 4)
            }
        }
    }
    
    func bind() {
        inputField.rx.controlEvent([.allEvents])
            .withLatestFrom(inputField.rx.text)
            .bind { (text) in
                self.inputField.textColor = self.inputType.textColor

            }
            .disposed(by: disposeBag)

        inputField.rx.controlEvent(.editingChanged)
            .bind { (_) in
                self.error.onNext(nil)
            }
            .disposed(by: disposeBag)

        error.bind { (error) in
                guard let error = error else {
                    self.inputField.textColor = self.inputType.textColor
                    self.lowerLabel.textColor = .white
                    self.lowerLabel.isHidden = true
                    return
                }
            self.inputField.textColor = #colorLiteral(red: 0.768627451, green: 0.1882352941, blue: 0.1882352941, alpha: 1)
            self.lowerLabel.textColor = #colorLiteral(red: 0.768627451, green: 0.1882352941, blue: 0.1882352941, alpha: 1)
            self.lowerLabel.isHidden = false
            self.lowerLabel.text = error.localizedDescription

            self.layoutSubviews()
            }
            .disposed(by: disposeBag)
    }
    
    func stylize() {
        inputField.attributedPlaceholder = NSAttributedString(string: inputType.title, attributes: [
            .foregroundColor: inputType.textColor,
            ])
        
//        inputField.keyboardAppearance = .dark
        
        switch inputType {
        case .regular(title: _, textColor: _, needsRightView: let needsRightView, alwaysShowTitle: _):
            inputField.keyboardType = .default
            inputField.isSecureTextEntry = false
            
            rightView.isHidden = !needsRightView
        case .address(title: _, textColor: _, needsRightView: let needsRightView, alwaysShowTitle: _):
            inputField.keyboardType = .default
            inputField.isSecureTextEntry = false
            
            rightView.isHidden = !needsRightView
        case .phone(title: _, textColor: _, needsRightView: let needsRightView, alwaysShowTitle: _):
            inputField.keyboardType = .phonePad
            inputField.isSecureTextEntry = false
            
            rightView.isHidden = !needsRightView
        case .email(title: _, textColor: _, needsRightView: let needsRightView, alwaysShowTitle: _):
            inputField.keyboardType = .emailAddress
            inputField.isSecureTextEntry = false
            
            rightView.isHidden = !needsRightView
//            imgForRightView.image = #imageLiteral(resourceName: "icon-profile")
        case .password(title: _, textColor: _, needsRightView: let needsRightView, alwaysShowTitle: _):
            inputField.keyboardType = .default
            inputField.isSecureTextEntry = true
            
            rightView.isHidden = !needsRightView
//            imgForRightView.image = #imageLiteral(resourceName: "key_icon")
        case .numeric(title: _, textColor: _, needsRightView: let needsRightView, alwaysShowTitle: _):
            inputField.keyboardType = .numberPad
            inputField.isSecureTextEntry = false
            
            rightView.isHidden = !needsRightView
//            imgForRightView.image = #imageLiteral(resourceName: "icon-profile")
        case .passwordReset(title: _, textColor: _, needsRightView: let needsRightView, alwaysShowTitle: _):
            inputField.keyboardType = .default
            inputField.isSecureTextEntry = true
            
            rightView.isHidden = !needsRightView
//            imgForRightView.image = #imageLiteral(resourceName: "ic_lock_eye")
        }
        
        inputField.textColor = inputType.textColor
    }

    private func createToolbar() {
        let toolbar = UIToolbar()
        let frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: 44)
        toolbar.frame = frame
        let doneButton = UIBarButtonItem.init(title: "Done".localized, style: .done, target: self, action: #selector(hideKeyboard))
        let space = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.barTintColor = .white
        doneButton.tintColor = .systemBlue
        toolbar.items = [space,doneButton]
        
        self.inputField.inputAccessoryView = toolbar
    }
    
    @objc private func hideKeyboard() {
        self.endEditing(true)
    }
}

extension Input {
    enum InputType {
        case regular(title: String, textColor: UIColor, needsRightView: Bool, alwaysShowTitle: Bool = false)
        case address(title: String, textColor: UIColor, needsRightView: Bool, alwaysShowTitle: Bool = false)
        case phone(title: String, textColor: UIColor, needsRightView: Bool, alwaysShowTitle: Bool = false)
        case email(title: String, textColor: UIColor, needsRightView: Bool, alwaysShowTitle: Bool = false)
        case password(title: String, textColor: UIColor, needsRightView: Bool, alwaysShowTitle: Bool = false)
        case passwordReset(title: String, textColor: UIColor, needsRightView: Bool, alwaysShowTitle: Bool = false)
        case numeric(title: String, textColor: UIColor, needsRightView: Bool, alwaysShowTitle: Bool = false)
        
        var title: String {
            get {
                switch self {
                case .regular(title: let title, textColor: _, needsRightView: _, alwaysShowTitle: _):
                    return title
                case .address(title: let title, textColor: _, needsRightView: _, alwaysShowTitle: _):
                    return title
                case .phone(title: let title, textColor: _, needsRightView: _, alwaysShowTitle: _):
                    return title
                case .email(title: let title, textColor: _, needsRightView: _, alwaysShowTitle: _):
                    return title
                case .password(title: let title, textColor: _, needsRightView: _, alwaysShowTitle: _):
                    return title
                case .numeric(title: let title, textColor: _, needsRightView: _, alwaysShowTitle: _):
                    return title
                case .passwordReset(title: let title, textColor: _, needsRightView: _, alwaysShowTitle: _):
                    return title
                }
            }
        }
        var textColor: UIColor {
            get {
                switch self {
                case .regular(title: _, textColor: let title, needsRightView: _, alwaysShowTitle: _):
                    return title
                case .address(title: _, textColor: let title, needsRightView: _, alwaysShowTitle: _):
                    return title
                case .phone(title: _, textColor: let title, needsRightView: _, alwaysShowTitle: _):
                    return title
                case .email(title: _, textColor: let title, needsRightView: _, alwaysShowTitle: _):
                    return title
                case .password(title: _, textColor: let title, needsRightView: _, alwaysShowTitle: _):
                    return title
                case .numeric(title: _, textColor: let title, needsRightView: _, alwaysShowTitle: _):
                    return title
                case .passwordReset(title: _, textColor: let title, needsRightView: _, alwaysShowTitle: _):
                    return title
                }
            }
        }
        
        
        var needsTitleAlways: Bool {
            get {
                switch self {
                case .regular(title: _, textColor: _, needsRightView: _, alwaysShowTitle: let title):
                    return title
                case .address(title: _, textColor: _, needsRightView: _, alwaysShowTitle: let title):
                    return title
                case .phone(title: _, textColor: _, needsRightView: _, alwaysShowTitle: let title):
                    return title
                case .email(title: _, textColor: _, needsRightView: _, alwaysShowTitle: let title):
                    return title
                case .password(title: _, textColor: _, needsRightView: _, alwaysShowTitle: let title):
                    return title
                case .numeric(title: _, textColor: _, needsRightView: _, alwaysShowTitle: let title):
                    return title
                case .passwordReset(title: _, textColor: _, needsRightView: _, alwaysShowTitle: let title):
                    return title
                }
            }
        }
    }
}
