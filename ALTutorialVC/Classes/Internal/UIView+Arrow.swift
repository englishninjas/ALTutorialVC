//
//  UIView+Arrow.swift
//  ALTutorialVC
//
//  Created by Ali Germiyanoglu on 10/11/2017.
//

import Foundation

internal extension UIView {
    internal func windowRect() -> CGRect {
        guard let rect = self.superview?.convert(self.frame, to: nil) else {
            // Value requirements not met, do something
            return self.frame
        }
        
        return rect
    }
    
    internal func arrowPoint(positionDetails: (Position, Order)) -> CGPoint {
        var xPos = 0.0
        var yPos = 0.0
        
        let windowRect = self.windowRect()
        var factor = CGFloat(Float(positionDetails.1.rawValue)/10.0)
        factor = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? CGFloat(1.0 - factor) : CGFloat(factor)
        
        switch positionDetails.0 {
        case .Top:
            xPos = Double(windowRect.origin.x + (windowRect.size.width * factor))
            yPos = Double(windowRect.origin.y)
        case .Bottom:
            xPos = Double(windowRect.origin.x + (windowRect.size.width * factor))
            yPos = Double(windowRect.origin.y + windowRect.size.height)
        case .Left:
            xPos = Double(windowRect.origin.x)
            yPos = Double(windowRect.origin.y + (windowRect.size.height * factor))
        case .Right:
            xPos = Double(windowRect.origin.x + windowRect.size.width)
            yPos = Double(windowRect.origin.y + (windowRect.size.height * factor))
        }
        
        return CGPoint(x: xPos, y: yPos)
    }
}
