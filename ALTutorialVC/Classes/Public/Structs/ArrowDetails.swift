//
//  ArrowDetails.swift
//  ALTutorialVC
//
//  Created by Ali Germiyanoglu on 04/11/2017.
//  Copyright © 2017 aeg. All rights reserved.
//

import Foundation

public struct ArrowDetails {
    public var position: Position
    public var order: Order
    public var curved: Bool
    
    public init(pos: Position, order: Order, curved: Bool) {
        if (pos == .Right || pos == .Left) && UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            self.position = pos == .Right ? .Left : .Right
        } else {
            self.position = pos
        }
        
        self.order = order
        self.curved = curved
    }
    
    public init(pos: Position, order: Order) {
        self.init(pos: pos, order: order, curved: false)
    }
}
