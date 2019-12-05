//
//  UIFontExtension.swift
//  Kopeyka
//
//  Created by Stanislav Makushov on 19.04.2018.
//  Copyright © 2018 Stanislav Makushov. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    class func SFProLight(size: CGFloat) -> UIFont {
        let font = UIFont(name: "SFProDisplay-Light", size: size) ?? UIFont.systemFont(ofSize: size)
        
        return font
    }
    
    class func SFPro(size: CGFloat) -> UIFont {
        let font = UIFont(name: "SFProDisplay-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
        
        return font
    }
    
    class func SFProMedium(size: CGFloat) -> UIFont {
        let font = UIFont(name: "SFProDisplay-Medium", size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
        
        return font
    }
    
    class func SFProSemiBold(size: CGFloat) -> UIFont {
        let font = UIFont(name: "SFProDisplay-Semibold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
        
        return font
    }
    
    class func SFProBold(size: CGFloat) -> UIFont {
        let font = UIFont(name: "SFProDisplay-Bold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
        
        return font
    }
    
    class func CircularAirBook(size: CGFloat) -> UIFont {
        let font = UIFont(name: "circular-air-regular", size: size) ?? UIFont.systemFont(ofSize: size)
        
        return font
    }
    
    class func CircularAirBold(size: CGFloat) -> UIFont {
        let font = UIFont(name: "circular-air-bold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
        
        return font
    }
}
