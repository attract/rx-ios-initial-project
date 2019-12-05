//
//  UITextViewExtension.swift
//  Beehives
//
//  Created by Dmytro Aprelenko on 21.08.2018.
//  Copyright © 2018 Stanislav Makushov. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

import UIKit

/// Extend UITextView and implemented UITextViewDelegate to listen for changes
extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.numberOfLines = 0
                placeholderLabel.isHidden = self.text.count > 0
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            
            let size = CGSize(width: labelWidth, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let attributes = [NSAttributedString.Key.font: self.font]
            
            let rectangleHeight = String(placeholderLabel.text ?? "").boundingRect(with: size, options: options, attributes: attributes as [NSAttributedString.Key : Any], context: nil).height

            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: rectangleHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholderText
        
        placeholderLabel.numberOfLines = 5
        placeholderLabel.lineBreakMode  = .byCharWrapping
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.init(cgColor: #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 0.8035905394))
        placeholderLabel.tag = 100
        placeholderLabel.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        
        self.rx.text.asObservable().subscribe(onNext: { [weak self] text in
            guard let placeholderLabel = self?.viewWithTag(100) as? UILabel else { return }
            
            placeholderLabel.isHidden = (text?.count ?? 0) > 0
        }).disposed(by: DisposeBag())
    }
    
}

extension UILabel{
    
    public var requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
}
