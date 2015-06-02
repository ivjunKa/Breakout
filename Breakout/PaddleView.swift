//
//  PaddleView.swift
//  DropIt
//
//  Created by Home on 01/06/15.
//  Copyright (c) 2015 nl.han.ica.mad. All rights reserved.
//

import UIKit

class PaddleView: UIView {
    var threshold:CGFloat = 0.0
    var shouldDragX = true
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blackColor()
        var tapGesture = UIPanGestureRecognizer(target: self, action: "handlePress:")
        self.addGestureRecognizer(tapGesture)
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func handlePress(gestureRecognizer: UIGestureRecognizer){
        
        var p:CGPoint = gestureRecognizer.locationInView(self)
        var center:CGPoint = CGPointZero
        
        switch gestureRecognizer.state {
        case .Began: println("paddle clicked")
        case .Changed:
            println("dragging")
            var center = self.center
            var distance = sqrt(pow((center.x - p.x), 2.0) + pow((center.y - p.y), 2.0))
            if distance > threshold {
                if shouldDragX {
                    self.center.x = p.x - (p.x % 40.0)
                }
            }
        case .Ended: println("ended")
        default: break
        }
        
    }
}
