//
//  ALTutorialLabel.swift
//  EnglishNinjas
//
//  Created by Ali Germiyanoglu on 15/12/2016.
//  Copyright © 2016 Ali Germiyanoglu. All rights reserved.
//

import Foundation
import UIKit

public class ALTutorialLabel : UILabel {
    override public func awakeFromNib() {
        super.awakeFromNib()
   
        self.numberOfLines = 0
        self.textColor = UIColor.white
        
        if self.textAlignment == .natural {
            self.textAlignment = .center
        }
    }
}
