//
//  TutorialProtocol.swift
//  ALTutorialVC
//
//  Created by Ali Germiyanoglu on 04/11/2017.
//  Copyright © 2017 aeg. All rights reserved.
//

import Foundation

//Protocol for subclasses
@objc public protocol TutorialProtocol {
    var started: Bool { get }
    
    var index: Int { get }
    
    var sources: [UIImageView] { get }
    
    var targets: [UIView] { get }
    
    var arrows: [ArrowView] { get }
    
    //Getter method to hide/show arrows
    func arrowView(atIndex: Int) -> UIView?
    
    func hidesPreviousTips() -> Bool
    
    func skipButton() -> UIButton?
    
    func buttonConstraints(_ skipButton: UIButton) -> [NSLayoutConstraint]?
    
    func setup()
    
    func setupSources(_ sources: [UIView])
    
    func setupTargets(_ sources: [UIView])
    
    func start()
    
    func playNextStep()
    
    func expire()
}
