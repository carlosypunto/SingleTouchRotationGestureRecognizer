//
//  SingleTouchRotationGestureRecognizer.swift
//  SingleTouchRotationGestureRecognizer
//
//  Created by Chris Gulley on 9/18/15.
//  Copyright © 2015 Chris Gulley. All rights reserved.
//


import UIKit
import UIKit.UIGestureRecognizerSubclass

/**
* Return vector from lhs point to rhs point.
*/
func - (lhs: CGPoint, rhs: CGPoint) -> CGVector {
    return CGVector(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
}

extension CGVector {
    /**
    * Returns angle and direction between vector and receiver. Angle is measured
    * in radians. The sign of the angle indicates direction, assuming that the
    * receiver was rotated along the acute angle between the vectors.
    * A value between 0 and M_PI indicates the receiver is clockwise from the vector.
    * A value between 0 and -M_PI indicates the receiver is rotated counterclockwise
    * from the vector.
    */
    func angleFromVector(vector: CGVector) -> Double {
        var angle = Double(atan2(dy, dx) - atan2(vector.dy, vector.dx))
        
        // The difference between the two values above won't necessarily be the
        // acute angle, so it could be between -2 * M_PI and 2 * M_PI. Adjust it here
        // so that we are returning the acute angle (shorter of the two possible rotations).
        if angle > Double.pi {
            angle -= (Double.pi * 2)
        }
        else if angle < -Double.pi {
            angle += (Double.pi * 2)
        }
        return angle
    }
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height / 2)
    }
}

/**
 * SingleTouchRotationGestureRecognizer recognizes rotation around the center of a view
 * involving a single touch. For example, you might use it to implement a knob control
 * that can be rotated with a finger.
 */
public class SingleTouchRotationGestureRecognizer: UIGestureRecognizer {
    // Rotation in radians
    public var rotation = CGFloat(0)
    
    // Velocity in radians / sec
    public var velocity: CGFloat {
        return angularVelocity
    }
    
    private var lastVector = CGVector.zero
    private var angularVelocity = CGFloat(0)
    private var lastTimestamp = TimeInterval(0)
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    override public func reset() {
        super.reset()
        lastVector = CGVector.zero
        rotation = 0
        lastTimestamp = 0
    }
    
    private func screenVectorFromTouch(_ touch: UITouch) -> CGVector{
        let screenSpace = view!.window!.screen.coordinateSpace
        let location = view!.convert(touch.location(in: view!), to: screenSpace)
        let center =  view!.convert(view!.bounds.center, to: screenSpace)
        
        return location - center
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first, touches.count == 1 && view != nil else {
            state = .failed
            return
        }
        
        lastVector = screenVectorFromTouch(touch)
        lastTimestamp = touch.timestamp
        state = .began
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first, view != nil else {
            state = .failed
            return
        }
        
        let currentVector = screenVectorFromTouch(touch)
        let angularDelta = CGFloat(currentVector.angleFromVector(vector: lastVector))
        rotation += angularDelta
        lastVector = currentVector
        
        angularVelocity = angularDelta / CGFloat(touch.timestamp - lastTimestamp)
        lastTimestamp = touch.timestamp
        
        state = .changed
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        state = .ended
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        state = .ended
    }
}
