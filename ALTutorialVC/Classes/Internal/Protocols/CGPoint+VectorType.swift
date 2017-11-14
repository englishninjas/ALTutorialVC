//
//  CGPoint+VectorType.swift
//  ALTutorialVC
//
//  Created by Ali Germiyanoglu on 04/11/2017.
//  Copyright © 2017 aeg. All rights reserved.
//

import Foundation

internal protocol VectorType {
    associatedtype Element
    
    var xElement: Element { get }
    var yElement: Element { get }
    
    static func buildFrom(x: Element, y: Element) -> Self
    
    init<T: VectorType>(fromVector: T) where T.Element == Element
}

internal func -<T: VectorType>(lhs: T, rhs: T) -> T where T.Element == CGFloat {
    return T.buildFrom(x: lhs.xElement - rhs.xElement, y: lhs.yElement - rhs.yElement)
}

internal func /<T: VectorType>(lhs: T, rhs: T.Element) -> T where T.Element == CGFloat {
    return T.buildFrom(x: lhs.xElement / rhs, y: lhs.yElement / rhs)
}

internal func *<T: VectorType>(lhs: T, rhs: T.Element) -> T where T.Element == CGFloat {
    return T.buildFrom(x: lhs.xElement * rhs, y: lhs.yElement * rhs)
}


extension CGPoint: VectorType {
    static internal func buildFrom(x: CGFloat, y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
    
    var xElement: CGFloat { return x }
    var yElement: CGFloat { return y }
    
    init<T: VectorType>(fromVector: T) where T.Element == CGFloat {
        self.init(x: fromVector.xElement, y: fromVector.yElement)
    }
}
