//
//  TutorialSegue.swift
//  TutorialView
//
//  Created by Ali Germiyanoglu on 13/12/2016.
//  Copyright © 2016 AEG. All rights reserved.
//

import UIKit

open class TutorialSegue: UIStoryboardSegue {
    
    override open func perform() {
        let fromVC = source 
        let toVC = destination
        
        toVC.modalPresentationStyle = .overCurrentContext
        toVC.modalTransitionStyle = .crossDissolve
        fromVC.present(toVC, animated: false, completion: nil)
    }
}
