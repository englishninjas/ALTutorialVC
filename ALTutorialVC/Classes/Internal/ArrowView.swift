//
//  ArrowView.swift
//  TutorialView
//
//  Created by Ali Germiyanoglu on 13/12/2016.
//  Copyright © 2016 AEG. All rights reserved.
//

import Foundation
import UIKit

@inline(never) fileprivate func arrowHeadLength(length: Float) -> Float{
    return max(length/9.0, 5.0)
}

public struct Arrow {
    public var head = CGPoint()
    public var tail = CGPoint()
    
    public var color = UIColor.white
    public var lineWidth = 1.0
    public var curved = true
    public var animated = true
    public var direction: ArrowDirection = .ArrowDirectionTH
    public var arrowLayer : CAShapeLayer = CAShapeLayer()
    
    fileprivate var description: String {
        return "head: \(head) \n" +
            "tail: \(tail) \n" +
            "color: \(color) \n" +
            "line: \(lineWidth) \n" +
            "curved: \(curved) \n" +
            "animated: \(animated) \n" +
        "direction: \(direction)\n"
    }
    
    private func trianglePoint(startingPoint: CGPoint, targetPoint: CGPoint, fromSide: Position) -> CGPoint {
        var xPos: CGFloat = 0.0
        var yPos: CGFloat = 0.0
        
        let drawingDirectionX: Position = startingPoint.x > targetPoint.x ? .Left : .Right

        switch fromSide {
        case .Top:
            yPos = min(startingPoint.y, targetPoint.y)
            xPos = (yPos == startingPoint.y) ? targetPoint.x : startingPoint.x
            break
        case .Bottom:
            yPos = max(startingPoint.y, targetPoint.y)
            xPos = (yPos == startingPoint.y) ? targetPoint.x : startingPoint.x
            break
        case .Right:
            xPos = drawingDirectionX == .Right ? max(startingPoint.x, targetPoint.x) : min(startingPoint.x, targetPoint.x)
            yPos = (xPos == startingPoint.x) ? targetPoint.y : startingPoint.y
            break
        case .Left:
            xPos = drawingDirectionX == .Left ? min(startingPoint.x, targetPoint.x) : max(startingPoint.x, targetPoint.x)
            yPos = (xPos == startingPoint.x) ? targetPoint.y : startingPoint.y
            break
        }
        
        return CGPoint(x: xPos, y: yPos)
    }
    
    fileprivate mutating func generatePath(fromSide: Position) -> CGPath? {
        if head != tail {
            let arrowPath = CGMutablePath()
            
            //Checking if we are straight line
            let shouldCurve = (head.x == tail.x || head.y == tail.y) ? false : curved
            
            //Are drawing from tail or head ?
            let startingPoint = (direction == .ArrowDirectionHT) ? head : tail
            
            //Get target point for calculations
            let targetPoint = startingPoint == head ? tail : head
            
            arrowPath.move(to: startingPoint)
            
            let triangleCornerPoint = trianglePoint(startingPoint: startingPoint,
                                                    targetPoint: targetPoint,
                                                    fromSide: fromSide)
            if shouldCurve == true {
                arrowPath.addQuadCurve(to: targetPoint, control: triangleCornerPoint)
            } else {
                arrowPath.addLine(to: targetPoint)
            }
            
            //Calculate Arrow Head
            let pointA = shouldCurve ? triangleCornerPoint : tail
            let pointB = head
            
            // Vector from A to B:
            let pointAB = pointB - pointA
            
            // Length of AB == distance from A to B:
            // Vector from C to B:
            let lengthD = hypotf(Float(triangleCornerPoint.x), Float(triangleCornerPoint.y))
            let arrowLength: Float = arrowHeadLength(length: lengthD)
            let sizeFactor = CGFloat(arrowLength / lengthD)
            let pointCB = pointAB * sizeFactor
            
            // Compute P and Q:
            let pointP = CGPoint(x: pointB.x - pointCB.x - pointCB.y,
                                 y: pointB.y - pointCB.y + pointCB.x)
            let pointQ = CGPoint(x: pointB.x - pointCB.x + pointCB.y,
                                 y: pointB.y - pointCB.y - pointCB.x)
//
            arrowPath.move(to: head)
            
            
            let headPath = CGMutablePath()
            headPath.move(to: head)
            headPath.addLine(to: pointP)
//
            headPath.move(to: head)
            headPath.addLine(to: pointQ)
            arrowPath.addPath(headPath)
            arrowPath.closeSubpath()
            
            let pathLayer = CAShapeLayer()
            pathLayer.path = arrowPath
            pathLayer.strokeColor = color.cgColor
            pathLayer.fillColor = UIColor.clear.cgColor
            pathLayer.lineWidth = CGFloat(lineWidth)
            pathLayer.lineJoin = kCALineJoinBevel
            pathLayer.lineDashPattern = [10,8]
            
            let headLayer = CAShapeLayer()
            headLayer.path = headPath
            headLayer.strokeColor = color.cgColor
            headLayer.fillColor = UIColor.clear.cgColor
            headLayer.lineWidth = CGFloat(lineWidth)
            headLayer.lineJoin = kCALineJoinBevel
            
            pathLayer.addSublayer(headLayer)
            arrowLayer = pathLayer
            
            return arrowPath
        }
        
        return nil
    }

    private func calculatePoint(point: CGPoint, angle: Float, distance: Float) -> CGPoint{
        return CGPoint(x: CGFloat(Float(point.x) + cosf(angle) * distance),
                       y: CGFloat(Float(point.y) + sinf(angle) * distance))
    }
}

public class ArrowView : UIView {
    public lazy var arrow = Arrow()
    
    public var drawingSide: Position = .Top
    public var dashPattern: [NSNumber] = [10,8]
    public var animationDuration = 0.3
    
    fileprivate var animationCompletion: (()->())?
    
    fileprivate var boundingBox:CGRect {
        if let box = arrow.generatePath(fromSide: drawingSide) {
            return box.boundingBoxOfPath
        }
        
        return CGRect()
    }
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        self.setup()
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
        self.setup()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = false
    }
    
    private func drawAnimated(arrow: Arrow, completion: (()->())?) {
        self.animationCompletion = completion
        self.arrow = arrow
        
        setNeedsDisplay()
    }
    
    override public func draw(_ rect: CGRect) {
        if arrow.generatePath(fromSide: drawingSide) != nil {
            layer.addSublayer(arrow.arrowLayer)
            
            let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
            pathAnimation.delegate = self
            pathAnimation.duration = animationDuration
            pathAnimation.fromValue = 0.0
            pathAnimation.toValue = 1.0
            
            arrow.arrowLayer.add(pathAnimation, forKey: "strokeEnd")
        }
    }
    
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.boundingBox.size
    }
    
    public func drawAnimated(fromPoint: CGPoint, toPoint: CGPoint, completion: (()->())?) {
        self.arrow.tail = fromPoint
        self.arrow.head = toPoint
        drawAnimated(arrow: self.arrow,
                     completion: completion)
    }
    
    public func setArrow(color: UIColor) {
        self.arrow.color = color
    }
    
}

extension ArrowView : CAAnimationDelegate {
    public func animationDidStart(_ anim: CAAnimation) {
        
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let completion = self.animationCompletion {
            completion()
        }
    }
}
