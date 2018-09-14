//
//  Array+UIView.swift
//  ALTutorialVC
//
//  Created by Ali Germiyanoglu on 10/11/2017.
//

import Foundation


internal extension Array where Element : UIView {
    internal mutating func removeAllSubviews() -> Array {
        self.forEach { $0.removeFromSuperview()}
        self.removeAll()
        return self
    }
    
    internal func hideAllSubviews() -> Array {
        self.forEach { $0.isHidden = true}
        return self
    }
    
    internal func bringAllSubviewsFront() -> Array {
        self.forEach { $0.superview?.bringSubview(toFront: $0) }
        return self
    }
}
