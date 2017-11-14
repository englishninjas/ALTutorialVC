//
//  TutorialDataSource.swift
//  ALTutorialVC
//
//  Created by Ali Germiyanoglu on 04/11/2017.
//  Copyright © 2017 aeg. All rights reserved.
//

import Foundation

//Protocol for subclasses
public protocol TutorialDataSource {
    
    func loadLocalizedStrings()
    
    func tutorialName() -> String
    
    func tutorialTargetViews() -> [UIView]
    
    func sourceCount() -> Int
    
    func sourceView(atIndex: Int) -> UIView
    
    func targetView(atIndex: Int) -> UIView
    
    func customizedSourceView(atIndex: Int) -> UIView
    
    func addSourceView(atIndex: Int, completion: ((_: UIView) -> Void)?)
    
    func addTargetView(atIndex: Int, completion: ((_: UIView) -> Void)?)
    
    func hideViews(atIndex: Int, completion: (() -> Void)?)
    
    func sourceArrowDetail(index: Int) -> ArrowDetails
    
    func targetArrowDetail(index: Int) -> ArrowDetails
    
    func delaySecondsBetweenTransition(fromIndex: Int, toIndex: Int) -> Int
    
    func tutorialBackgroundView() -> UIView?
}
