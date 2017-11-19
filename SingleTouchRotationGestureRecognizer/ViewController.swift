//
//  ViewController.swift
//  SingleTouchRotationGestureRecognizer
//
//  Created by Chris Gulley on 9/18/15.
//  Copyright © 2015 Chris Gulley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var square: UIView!
    var rotation = CGFloat(0)
    var lastRotation = CGFloat(0)
    
    var recognizer: SingleTouchRotationGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recognizer = SingleTouchRotationGestureRecognizer(target: self, action: #selector(rotated(sender:)))
        square.addGestureRecognizer(recognizer)
    }
    
    @objc func rotated(sender: SingleTouchRotationGestureRecognizer) {
        if sender.state == .began {
            lastRotation = 0
        }

        rotation += sender.rotation - lastRotation
        lastRotation = sender.rotation
        
        self.square.transform = CGAffineTransform(rotationAngle: rotation)
    }
}

