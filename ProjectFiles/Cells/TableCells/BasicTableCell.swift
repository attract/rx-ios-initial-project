//
//  BasicTableCell.swift
//  
//
//  Created by Stanislav Makushov on 24.12.18.
//  Copyright © 2018 Stanislav Makushov. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

enum DividerInset: CGFloat {
    case safeArea = 20.0
    case left58 = 58.0
    case left88 = 88.0
}

class BasicTableCell: UITableViewCell {
    var bottomSeparatorView: UIView? = nil
    var topSeparatorView: UIView? = nil
    
    private(set) var bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
        removeDevider()
        removeTopDevider()
    }
    
    func addDevider(insetLeft: DividerInset, insetRight: DividerInset = .safeArea) {
        self.removeDevider()
        
        let view = UIView()
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.separator
        } else {
            view.backgroundColor = UIColor.groupTableViewBackground
        }
        
        let x: CGFloat = insetLeft.rawValue
        
        self.addSubview(view)
        self.bottomSeparatorView = view
        
        // Setup constraint for separator view
        
        NSLayoutConstraint(item: view,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .trailing,
                           multiplier: 1,
                           constant: -insetRight.rawValue).isActive = true
        
        NSLayoutConstraint(item: view,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .leading,
                           multiplier: 1,
                           constant: x).isActive = true
        
        NSLayoutConstraint(item: view,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .bottom,
                           multiplier: 1,
                           constant: -2).isActive = true
        
        NSLayoutConstraint(item: view,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .height,
                           multiplier: 1,
                           constant: 0.5).isActive = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addTopDevider(insetLeft: DividerInset, insetRight: DividerInset = .safeArea) {
        self.removeTopDevider()
        
        let view = UIView()
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.separator
        } else {
            view.backgroundColor = UIColor.groupTableViewBackground
        }
        
        let x: CGFloat = insetLeft.rawValue
        
        self.addSubview(view)
        self.topSeparatorView = view
        
        // Setup constraint for separator view
        
        NSLayoutConstraint(item: view,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .trailing,
                           multiplier: 1,
                           constant: -insetRight.rawValue).isActive = true
        
        NSLayoutConstraint(item: view,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .leading,
                           multiplier: 1,
                           constant: x).isActive = true
        
        NSLayoutConstraint(item: view,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .top,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: view,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .height,
                           multiplier: 1,
                           constant: 0.5).isActive = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func removeDevider() {
        if self.bottomSeparatorView != nil {
            self.bottomSeparatorView?.removeFromSuperview()
            self.bottomSeparatorView = nil
        }
    }
    
    func removeTopDevider() {
        if self.topSeparatorView != nil {
            self.topSeparatorView?.removeFromSuperview()
            self.topSeparatorView = nil
        }
    }
    
    func createShadow(view: UIView, shadowColor: UIColor = UIColor(red: 0.321, green: 0.321, blue: 0.321, alpha: 0.25), opacity: Float = 1, shadowRadius: CGFloat, shadowOffset: CGSize) {
        DispatchQueue.main.async {
            view.layer.shadowColor = shadowColor.cgColor
            view.layer.shadowOpacity = opacity
            view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: shadowRadius).cgPath
            view.layer.masksToBounds = false
            view.layer.shadowOffset = shadowOffset
        }
    }
}
