//
//  FMBlurable.swift
//  FMBlurable
//
//  Created by SIMON_NON_ADMIN on 18/09/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//
// Thanks to romainmenke (https://twitter.com/romainmenke) for hint on a larger sample...
import UIKit


protocol Blurable {
    var layer: CALayer { get }
    var subviews: [UIView] { get }
    var frame: CGRect { get }
    var superview: UIView? { get }
    
    func addSubview(_: UIView)
    func removeFromSuperview()
    
    func blur(blurRadius: CGFloat)
    func unBlur()
    
    var isBlurred: Bool { get }
}

extension Blurable where Self: UIView {
    func blur(blurRadius: CGFloat)
    {
        if self.superview == nil
        {
            return
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: frame.width, height: frame.height), false, 1)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
        
        UIGraphicsEndImageContext();
        
        guard let blur = CIFilter(name: "CIGaussianBlur") else {return}
        
        blur.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        blur.setValue(blurRadius, forKey: kCIInputRadiusKey)
        
        let ciContext  = CIContext(options: nil)
        
        guard let result = blur.value(forKey: kCIOutputImageKey) as? CIImage else {return}
        
        let boundingRect = CGRect(x:0,
                                  y: 0,
                                  width: frame.width,
                                  height: frame.height)
        
        guard let cgImage = ciContext.createCGImage(result, from: boundingRect) else { return }
        
        let filteredImage = UIImage(cgImage: cgImage)
        
        let blurOverlay = BlurOverlay()
        blurOverlay.frame = boundingRect
        
        blurOverlay.image = filteredImage
        blurOverlay.contentMode = .scaleToFill
        
        if let superview = superview as? UIStackView,
            let index = (superview as UIStackView).arrangedSubviews.firstIndex(of: self)
        {
            removeFromSuperview()
            superview.insertArrangedSubview(blurOverlay, at: index)
        } else {
            blurOverlay.frame.origin = frame.origin
            
            self.addSubview(blurOverlay)
//            UIView.transition(from: self,
//                              to: blurOverlay,
//                              duration: 0.2,
//                              options: .curveEaseIn,
//                              completion: nil)
        }
        
        objc_setAssociatedObject(self,
                                 &BlurableKey.blurable,
                                 blurOverlay,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
    func unBlur() {
    guard let blurOverlay = objc_getAssociatedObject(self, &BlurableKey.blurable) as? BlurOverlay else {return}
    
    if let superview = blurOverlay.superview as? UIStackView,
        let index = (blurOverlay.superview as! UIStackView).arrangedSubviews.firstIndex(of: blurOverlay) {
        blurOverlay.removeFromSuperview()
        superview.insertArrangedSubview(self, at: index)
    } else {
        self.subviews.forEach { (view) in
            if view == blurOverlay {
                view.removeFromSuperview()
            }
        }
    }
    
    objc_setAssociatedObject(self,
                                &BlurableKey.blurable,
                                nil,
                                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
}
    
    var isBlurred: Bool
    {
        return objc_getAssociatedObject(self, &BlurableKey.blurable) is BlurOverlay
    }
}

extension UIView: Blurable
{
}

class BlurOverlay: UIImageView
{
}

struct BlurableKey
{
    static var blurable = "blurable"
}
