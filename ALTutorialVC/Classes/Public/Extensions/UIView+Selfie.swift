//
//  UIView+Selfie.swift
//  ALTutorialVC
//
//  Created by Ali Germiyanoglu on 04/11/2017.
//  Copyright © 2017 aeg. All rights reserved.
//

import Foundation

@objc public extension UIView {
    public func selfie() -> UIImage {
        let rect = self.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size,false,0.0);
        if let ctx = UIGraphicsGetCurrentContext() {
            UIColor.clear.set()
            ctx.fill(self.bounds)
            
            self.layer.render(in: ctx)
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            return newImage!
        }
        
        return UIImage()
    }
}
