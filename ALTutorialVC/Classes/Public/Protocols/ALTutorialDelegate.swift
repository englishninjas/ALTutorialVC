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
    func tutorialViews(_ tutorialVC: ALTutorialVC) -> [UIView]
}

public protocol TutorialNavigationHandler {
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
    func showTutorial(namedSegue: String)
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
    func tutorialDidTimeout(_ tutorialVC: ALTutorialVC)
    
    func tutorialWillStart(_ tutorialVC: ALTutorialVC)
    
    func tutorialDidStart(_ tutorialVC: ALTutorialVC)
    
    func tutorialWillDismiss(_ tutorialVC: ALTutorialVC)
    
    func tutorialDidEnd(_ tutorialVC: ALTutorialVC)
    
    /*
     While fetching data or for some other reason,
     you may want to delay Tutorial, return NO
    */
    func shouldTutorialStart(_ tutorialVC: ALTutorialVC) -> Bool
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
    public func showTutorial(namedSegue: String) {
        if visibleView() {
            toggleUserInteraction(false)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.tutorialNavigationHandler().performTipsSegue(named: namedSegue)
                
                self.toggleUserInteraction(true)
            }
        }
    }
}

