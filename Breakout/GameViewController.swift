//
//  DropItViewController.swift
//  DropIt
//
//  Created by Home on 28/05/15.
//  Copyright (c) 2015 nl.han.ica.mad. All rights reserved.
//

import UIKit
import Foundation
class DropItViewController: UIViewController {
    
    @IBOutlet weak var gameView: UIView!
    var paddleView : PaddleView?
    //view representing "ball" needs to be replaced with bezier path ball
    var bouncingView : UIView?
    
    var dropsPerRow = 9
    var paddleTouchStarted : Bool = false
    var step = 10
    var tapPosition : CGPoint?
    lazy var collider : UICollisionBehavior = {
        let colliderController = UICollisionBehavior()
        colliderController.translatesReferenceBoundsIntoBoundary = true
        return colliderController
    }()
    
    var animator : UIDynamicAnimator?
    var gravity = UIGravityBehavior()
    var dropsSize : CGSize {
        let size = gameView.bounds.size.width / CGFloat(dropsPerRow)
        return CGSize(width: size, height: CGFloat(dropsPerRow*2))
    }

    let startPos = CGPoint(x: 0, y: 50)
    let startPosPaddle = CGPoint(x:0, y:0)
    
    @IBAction func drop(sender: UITapGestureRecognizer) {
//        var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("movePaddle"), userInfo: nil, repeats: true)
    }
    func drop(){
        var frame = CGRect(origin: startPos, size: dropsSize)
        frame.origin.x = CGFloat.random(dropsPerRow) * dropsSize.width
        let dropView = UIView(frame: frame)
        dropView.backgroundColor = UIColor.random
        dropView.layer.borderWidth = 1
        dropView.layer.borderColor = UIColor.redColor().CGColor
        gameView.addSubview(dropView)
    }
    override func viewDidLoad() {
        for var index = 0; index < dropsPerRow; index++ {
            drop()
        }
        createPaddle()
        createBouncingView()
        animator = UIDynamicAnimator(referenceView: gameView)
        animator?.addBehavior(gravity)
        animator?.addBehavior(collider)
        gravity.addItem(bouncingView!)
        collider.addItem(paddleView!)
        collider.addItem(bouncingView!)
    }
        func longTap(sender: UILongPressGestureRecognizer) {
            switch sender.state {
            case .Began: println("tap began")
            case .Ended: println("tap ended")
            case .Changed:
                var tapPosition = sender.locationInView(self.view)
                var center = gameView.bounds.size.width/2
                if(tapPosition.x < center){
                    paddleView?.frame.origin.x -= CGFloat(step)
                } else if(tapPosition.x > center) {
                    paddleView?.frame.origin.x += CGFloat(step)
                  }
            default: break
            }
        }
    func createPaddle(){
        var paddle = CGRect(origin: startPosPaddle, size: dropsSize)
        paddle.size.width = 300
        paddle.origin.y = gameView.bounds.size.height - dropsSize.height
        paddleView = PaddleView(frame: paddle)
        gameView.addSubview(paddleView!)
        
        var tap = UILongPressGestureRecognizer(target:self, action:"longTap:")
        tap.minimumPressDuration = 0
        tap.numberOfTouchesRequired = 1
        gameView.addGestureRecognizer(tap)
    }
    func createBouncingView(){
        var bounceFrame = CGRect(origin: startPosPaddle, size: dropsSize)
//        bounceFrame.origin.x = gameView.bounds.size.width/2
//        bounceFrame.origin.y = gameView.bounds.size.height/2
        bounceFrame.origin.x = 200
        bounceFrame.origin.y = 200
        bounceFrame.size.width = dropsSize.width/4
        bouncingView = UIView(frame: bounceFrame)
        bouncingView!.backgroundColor = UIColor.greenColor()
        gameView.addSubview(bouncingView!)
    }
}

private extension CGFloat {
    static func random(max: Int) -> CGFloat{
        return CGFloat(arc4random() % UInt32(max))
    }
}

private extension UIColor {
    class var random: UIColor {
        switch arc4random()%5 {
        case 0: return UIColor.greenColor()
        case 1: return UIColor.redColor()
        case 2: return UIColor.blueColor()
        case 3: return UIColor.blackColor()
        case 4: return UIColor.purpleColor()
        default: return UIColor.yellowColor()
        }
    }
}

