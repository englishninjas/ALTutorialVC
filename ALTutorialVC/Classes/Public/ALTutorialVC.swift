//
//  ALTutorialVC.swift
//  TutorialView
//
//  Created by Ali Germiyanoglu on 14/12/2016.
//  Copyright © 2016 AEG. All rights reserved.
//

import Foundation
import UIKit

/*
 Subclass me to introduce a VC
 */
open class ALTutorialVC : UIViewController, TutorialProtocol, TutorialDataSource {
    public var started: Bool = false
    
    public var index: Int = 0
    
    public var sources = [UIImageView]()
    
    public var targets = [UIView]() {
        didSet {
            let _ = targets.hideAllSubviews()
        }
    }
    
    public var arrows = [ArrowView]()
    
    open var dismissByGesture: Bool {
        get {
            return true
        }
    }
    
    @objc public weak var tutorialDelegate: TutorialDelegate?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        expire()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        expire()
    }
    
    /*
     TutorialProtocol Methods
     */
    
    open func setupSources(_ sources: [UIView]) {
        sources.forEach {
            let screenShot = UIImageView(image: $0.selfie())
            screenShot.isHidden = true
            screenShot.frame = self.view.convert($0.windowRect(), from: nil)
            self.sources.append(screenShot)
        }
    }
    
    open func setupTargets(_ targets: [UIView]) {
        self.targets = targets
    }
    
    open func setup() {
        if let childsArray = tutorialDelegate?.tutorialViews(self) {
            setupSources(childsArray)
            setupTargets(tutorialTargetViews())
        }
    }
    
    open func buttonConstraints(_ skipButton: UIButton) -> [NSLayoutConstraint]? {
        let views = ["skip": skipButton]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[skip(80)]-10-|", options: NSLayoutConstraint.FormatOptions.alignAllTrailing, metrics: nil, views: views)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[skip(36)]", options: NSLayoutConstraint.FormatOptions.alignAllTop, metrics: nil, views: views)
        
        
        return horizontalConstraints + verticalConstraints
    }
    
    open func skipButton() -> UIButton? {
        let skipButton = UIButton.init(type: .system)
        
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.setTitleColor(UIColor.white,
                                 for: .normal)
        skipButton.setTitle(NSLocalizedString("tutorialsvc_skip", comment: "tutorialsvc_skip") + " >>",
                            for: .normal)
        skipButton.addTarget(self,
                             action: #selector(self.skipButtonDidPress),
                             for: .touchUpInside)
        
        return skipButton
    }
    
    @objc public func start() {
        if !started {
            started = true
            drawAnimated()
            
            if let delegate = tutorialDelegate {
                delegate.tutorialDidStart(self)
            }
        }
    }
    
    @objc
    public func playNextStep() {
        if !started {
            fatalError("|playNextStep| call me after tutorial has started!")
        }
        
        if !drawAnimated(index: index+1) {
            dismiss()
        }
    }
    
    @objc public func expire() {
        Timer.scheduledTimer(timeInterval: 1.0,
                             target: self,
                             selector: #selector(self.startTimeout),
                             userInfo: nil,
                             repeats: false)
    }
    
    @objc public func arrowView(atIndex: Int) -> UIView? {
        if atIndex < arrows.count {
            return arrows[atIndex]
        } else {
            return nil
        }
    }
    
    @objc open func hidesPreviousTips() -> Bool {
        return true
    }
    
    private func setupCancelGestureRecognizers() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handle(gestureRecognizer:)))
        self.view.addGestureRecognizer(tapRecognizer)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handle(gestureRecognizer:)))
        self.view.addGestureRecognizer(panRecognizer)
    }
    
    /*
     View Life Cycle Methods
     */
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        
        if let bgView = tutorialBackgroundView() {
            self.view.addSubview(bgView)
        }
        
        
        if let skipButton = skipButton() {
            self.view.addSubview(skipButton)
            
            if let constraints = buttonConstraints(skipButton) {
                self.view.addConstraints(constraints)
            }
        }
        
        setupCancelGestureRecognizers()
        
        loadLocalizedStrings()
        
        expire()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let delegate = tutorialDelegate {
            delegate.tutorialWillStart(self)
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        start()
    }
    
    /*
     Internal Methods
     */
    
    @objc private func startTimeout() {
        if !started {
            if let delegate = tutorialDelegate {
                delegate.tutorialDidTimeout(self)
            }
        }
    }
    
    public func dismiss() {
        if let delegate = tutorialDelegate {
            delegate.tutorialWillDismiss(self)
        }
        
        self.dismiss(animated: true,
                     completion: nil)
    }
    
    @objc
    private func handle(gestureRecognizer: UIGestureRecognizer) {
        didGestureRecognize(gestureRecognizer)
    }
    
    open func didGestureRecognize(_ gesture: UIGestureRecognizer) {
        if gesture.state == .ended {
            if dismissByGesture && index >= sourceCount() {
                dismiss()
            }
        }
    }
    
    private func drawAnimated() {
        if let delegate = tutorialDelegate {
            var passedTime = 0
            waitLoop: while !delegate.shouldTutorialStart(self) {
                self.view.isHidden = true
                usleep(10)
                passedTime += 10
                
                //waited enough(2 seconds o_O) break it; buggy behaviour :(
                if passedTime >= 2000 {
                    tutorialDidFinish()
                    return
                }
            }
        }
        setup()
        
        self.view.isHidden = false
        
        flagPresented()
        
        let _ = drawAnimated(index: 0)
    }
    
    private func drawAnimated(index: Int) -> Bool{
        self.index = index
        
        if index < sourceCount() {
            if hidesPreviousTips() && index > 0 {
                hideViews(atIndex: index-1,
                               completion:nil)
            }
            
            addSourceView(atIndex: index,
                               completion: { (sourceView) in
                                let arrowView = ArrowView(frame: self.view.bounds)
                                
                                let sourceArrowDetails = self.sourceArrowDetail(index: index)
                                arrowView.drawingSide = sourceArrowDetails.position
                                arrowView.arrow.curved = sourceArrowDetails.curved
                                self.view.addSubview(arrowView)
                                
                                let targetView = self.targetView(atIndex: index)
                                let targetArrowDetail = self.targetArrowDetail(index: index)
                                
                                let sourcePoint = sourceView.arrowPoint(positionDetails: (sourceArrowDetails.position, sourceArrowDetails.order))
                                let targetPoint = targetView.arrowPoint(positionDetails: (targetArrowDetail.position, targetArrowDetail.order))
                                
                                self.arrows.append(arrowView)
                                
                                arrowView.drawAnimated(fromPoint: sourcePoint,
                                                       toPoint: targetPoint,
                                                       completion: {
                                                        if self.index == index {
                                                            self.addTargetView(atIndex: index,
                                                                               completion: { (targetView) in
                                                                                let _ = self.arrows.bringAllSubviewsFront()
                                                                                let newIndex = index + 1
                                                                                let deadlineTime = DispatchTime.now() + .seconds(self.delaySecondsBetweenTransition(fromIndex: index, toIndex: newIndex))
                                                                                
                                                                                DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                                                                                    if newIndex > self.index {
                                                                                        let _ = self.drawAnimated(index: newIndex)
                                                                                    }
                                                                                }
                                                            })
                                                        }
                                })
            })
            
            return true
        } else {
            tutorialDidFinish()
            
            return false
        }
    }
    
    private func tutorialDidFinish() {
        if let delegate = tutorialDelegate {
            delegate.tutorialDidEnd(self)
        }
    }
    
    @objc private func skipButtonDidPress(_ sender: UIButton) {
        playNextStep()
    }
    
    private func flagPresented() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: tutorialName())
    }
    
    /*
     TutorialDataSource Methods
     */
    
    open func loadLocalizedStrings() {
        print("\(String(describing: self)) |loadLocalizedStrings| Don't you have anything to localize!")
    }
    
    public static func showedPreviously() -> Bool {
        return UserDefaults.standard.bool(forKey: tutorialName())
    }
    
    public static func tutorialName() -> String {
        return description()
    }
    
    open func tutorialName() -> String {
        let name = type(of: self).tutorialName()
        print("\(name) |tutorialName| Its better if you override me!")
        
        return name
    }
    
    open func sourceArrowDetail(index: Int) -> ArrowDetails {
        print("|sourceArrowDetail| Its better if you override me!")
        return ArrowDetails(pos: .Top, order: .First)
    }
    
    open func targetArrowDetail(index: Int) -> ArrowDetails {
        print("|targetArrowDetail| Its better if you override me!")
        return ArrowDetails(pos: .Bottom, order: .Fifth)
    }
    
    open func tutorialTargetViews() -> [UIView] {
        fatalError("|tutorialTargetViews| Its better if you override me!")
    }
    
    open func sourceCount() -> Int {
        return sources.count
    }
    
    open func sourceView(atIndex: Int) -> UIView {
        return sources[atIndex]
    }
    
    open func targetView(atIndex: Int) -> UIView {
        return targets[atIndex]
    }
    
    open func customizedSourceView(atIndex: Int) -> UIView {
        return sourceView(atIndex: atIndex)
    }
    
    open func addSourceView(atIndex: Int, completion: ((_: UIView) -> Void)?) {
        let subview = customizedSourceView(atIndex: atIndex)
        subview.isHidden = false
        self.view.addSubview(subview)
        
        if let completion = completion {
            completion(subview)
        }
    }
    
    open func addTargetView(atIndex: Int, completion: ((_: UIView) -> Void)?) {
        let subview = targetView(atIndex: atIndex)
        subview.isHidden = false
        self.view.addSubview(subview)
        
        
        if let completion = completion {
            completion(subview)
        }
    }
    
    open func hideViews(atIndex: Int, completion: (() -> Void)?) {
        let source = sourceView(atIndex: atIndex)
        let target = targetView(atIndex: atIndex)
        
        source.isHidden = true
        target.isHidden = true
        
        if let arrow = arrowView(atIndex:atIndex) {
            arrow.isHidden = true
        }
    }
    
    open func tutorialBackgroundView() -> UIView? {
        let bgView = UIView(frame: self.view.bounds)
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        return bgView
    }
    
    open func delaySecondsBetweenTransition(fromIndex: Int, toIndex: Int) -> Int {
        return toIndex >= sourceCount() ? 1 : 3
    }
}
