//
//  UIButtonExtension.swift
//  VeezApp
//
//  Created by Artem Boyko on 5/5/19.
//  Copyright © 2019 Artem Boyko. All rights reserved.
//

import UIKit

extension UIButton {
    
    /**
     * Sets a solid background color for the button.
     */
    
    func setBackgroundColor(_ color: UIColor, forState controlState: UIControl.State) {
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()?.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        setBackgroundImage(colorImage, for: controlState)
    }
    
}
