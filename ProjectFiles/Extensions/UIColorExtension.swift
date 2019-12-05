//
//  UIColorExtension.swift
//  
//
//  Created by Stanislav Makushov on 25.04.17.
//  Copyright © 2017 Stanislav Makushov. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Foundation.Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIColor {
    func toImage() -> UIImage? {
        return toImageWithSize(size: CGSize(width: 1, height: 1))
    }
    func toImageWithSize(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        
        if let ctx = UIGraphicsGetCurrentContext() {
            let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            ctx.setFillColor(self.cgColor)
            ctx.addRect(rectangle)
            ctx.drawPath(using: .fill)
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return colorImage
        } else {
            return nil
        }
    }
}

extension UIColor {
    
    static var darkTabBar: UIColor {
        get { return UIColor.init(hexString: "09090b") }
    }
    
    static var grayAppBackground: UIColor {
        get { return UIColor.init(hexString: "20242C")}
    }
    
    static var placeholderColor: UIColor {
        get { return UIColor.init(hexString: "666D7A")}
    }
    
    static var appRose: UIColor {
        get { return UIColor.init(hexString: "FF3EA5")}
    }
    
    static var disabledButtonColor: UIColor {
        get { return UIColor.init(hexString: "3E424C")}
    }
    
    static var lightBorderColor: UIColor {
        get { return UIColor.init(hexString: "35373F")}
    }
    
    static var lightGrayFont: UIColor {
        get { return UIColor.init(hexString: "8991A0") }
    }
}
