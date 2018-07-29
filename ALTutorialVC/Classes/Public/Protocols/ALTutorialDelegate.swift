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

public protocol TutorialNavigationHandler {
    func segue() -> String
    func performTipsSegue(named: String)
}

public extension TutorialNavigationHandler where Self: UIViewController {
    public func performTipsSegue(named: String) {
        self.performSegue(withIdentifier: named,
                          sender: self)
    }
}

public protocol TutorialConsumer {
    func tutorialSource() -> TutorialViewSource
    func tutorialNavigationHandler() -> TutorialNavigationHandler
    func showTutorial()
}

extension UIViewController {
    public func visibleView() -> Bool {
        return isViewLoaded && view.window != nil
    }
    
    public func toggleUserInteraction(_ enabled: Bool) {
        view.isUserInteractionEnabled = enabled
        tabBarController?.view.isUserInteractionEnabled = enabled
    }
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

public extension TutorialDelegate where Self: UIViewController {
    
    public func tutorialDidTimeout() {
        toggleUserInteraction(true)
    }
    
    public func tutorialWillStart() {
        toggleUserInteraction(false)
    }
    
    public func tutorialDidStart() {
        toggleUserInteraction(true)
    }
    
    public func tutorialDidEnd() {
        toggleUserInteraction(true)
    }
}

public extension TutorialConsumer where Self: UIViewController {
    public func showTutorial() {
        if visibleView() {
            toggleUserInteraction(false)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                let segueName = self.tutorialNavigationHandler().segue()
                self.tutorialNavigationHandler().performTipsSegue(named: segueName)
                
                self.toggleUserInteraction(true)
            }
        }
    }
}

