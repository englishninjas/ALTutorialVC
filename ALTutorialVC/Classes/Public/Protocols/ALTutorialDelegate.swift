//
//  ALTutorialDelegate.swift
//  ALTutorialVC
//
//  Created by Ali Germiyanoglu on 04/11/2017.
//  Copyright © 2017 aeg. All rights reserved.
//

import Foundation

/*
 Protocol for VCs which will be introduced
 */
@objc public protocol TutorialViewSource {
    /*
     |UIView| components to be introduced
     */
    func tutorialViews() -> [UIView]
}


/*
 Protocol for VCs which will be introduced
 */
@objc public protocol TutorialDelegate: TutorialViewSource {
    /*
     Tutorial could not start, we will try next time
     */
    func tutorialDidTimeout()
    
    func tutorialWillStart()
    
    func tutorialDidStart()
    
    func tutorialWillDismiss()
    
    func tutorialDidEnd()
    
    /*
     While fetching data or for some other reason,
     you may want to delay Tutorial, return NO
    */
    func shouldTutorialStart() -> Bool
}
