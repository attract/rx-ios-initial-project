//
//  BasicCollectionViewCell.swift
//
//  Created by Dmytro Aprelenko on 09.08.2019.
//  Copyright © 2019 Dmytro Aprelenko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class BasicCollectionViewCell: UICollectionViewCell {
    private(set) var bag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
}

extension BasicCollectionViewCell {
    /// This is a workaround method for self sizing collection view cells which stopped working for iOS 12
    func setupSelfSizing(contentView: UIView) {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = contentView.leftAnchor.constraint(equalTo: leftAnchor)
        let rightConstraint = contentView.rightAnchor.constraint(equalTo: rightAnchor)
        let topConstraint = contentView.topAnchor.constraint(equalTo: topAnchor)
        let bottomConstraint = contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
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
