//
//  FirstViewController.swift
//  AnimationsGame
//
//  Created by Timothy Hull on 3/1/17.
//  Copyright © 2017 Sponti. All rights reserved.
//

import UIKit
import QuartzCore




class FirstViewController: UIViewController, UICollisionBehaviorDelegate {
    
    var animator: UIDynamicAnimator!
    var ball: UIView!
    var sliderBar: UIView!
    var sliderBarCenterPoint: CGPoint!
    var isBallRolling: Bool = false
    var countLabel: UILabel!
    var scoreLabel: UILabel!
    var count = 0
    var startButton: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initGamePieces()
        self.scoreLabel.isHidden = true
    }
    
    
    
    
    // Initialize game pieces, but hide them until start function is called
    func initGamePieces() {
        
        // Start Button
        let buttonFrame = CGRect(x: 100, y: 100, width: 200, height: 50)
        self.startButton = UIButton(frame: buttonFrame)
        self.startButton.backgroundColor = UIColor.white
        self.startButton.setTitle("Start Game!", for: .normal)
        self.startButton.setTitleColor(UIColor.blue, for: .normal)
        self.startButton.translatesAutoresizingMaskIntoConstraints = false
        self.startButton.layer.cornerRadius = 0
        self.startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        self.startButton.addTarget(self, action: #selector(start), for: .touchUpInside)
        
        // Ball
        self.ball = UIView(frame: CGRect(x: CGFloat(0.0), y: CGFloat(10.0), width: CGFloat(50.0), height: CGFloat(50.0)))
        self.ball.backgroundColor = UIColor.red
        self.ball.layer.cornerRadius = 25.0
        self.ball.layer.borderColor = UIColor.black.cgColor
        self.ball.layer.borderWidth = 0.0
        self.ball.isHidden = true
        
        // Paddle
        self.sliderBar = UIView(frame: CGRect(x: CGFloat(self.view.frame.size.width / 2 - 75), y: CGFloat((self.tabBarController?.tabBar.frame.origin.y)! - 30.0), width: CGFloat(150.0), height: CGFloat(30.0)))
        self.sliderBar.backgroundColor = UIColor.black
        self.sliderBar.layer.cornerRadius = 15.0
        self.sliderBar.translatesAutoresizingMaskIntoConstraints = false
        self.sliderBarCenterPoint = self.sliderBar.center
        self.sliderBar.isUserInteractionEnabled = true
        self.sliderBar.isHidden = true
        
        // Count Label
        let frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        self.countLabel = UILabel(frame: frame)
        self.countLabel.textAlignment = NSTextAlignment.center
        self.countLabel.text = "0"
        self.countLabel.textColor = UIColor.blue
        self.countLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        self.countLabel.translatesAutoresizingMaskIntoConstraints = false
        self.countLabel.isHidden = true
        
        // Score label
        let scoreLabelFrame = CGRect(x: 100, y: 100, width: 200, height: 50)
        self.scoreLabel = UILabel(frame: scoreLabelFrame)
        self.scoreLabel.textAlignment = NSTextAlignment.center
        self.scoreLabel.text = "Your score was \(self.count)"
        self.scoreLabel.textColor = UIColor.red
        self.scoreLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        self.scoreLabel.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(self.ball)
        self.view.addSubview(self.sliderBar)
        
        self.view.addSubview(self.countLabel)
        self.setupCountLabel()
        
        self.ball.isHidden = true
        self.sliderBar.isHidden = true
        self.countLabel.isHidden = true

        self.startButton.isHidden = false
        self.scoreLabel.isHidden = false
        self.view.addSubview(ball)
        self.view.addSubview(sliderBar)
        
        self.view.addSubview(self.startButton)
        self.setupStartButton()

        self.view.addSubview(self.scoreLabel)
        self.setupScoreLabel()
    }
    

    
    
    func gravity() {
        let gravityBehavior = UIGravityBehavior(items: [self.ball])
        self.animator.addBehavior(gravityBehavior)
        
        gravityBehavior.action = {() -> Void in
            print("\(self.ball.center.y)")
            if (self.ball.center.y >= 800) {
                self.ball.removeFromSuperview()
                self.sliderBar.removeFromSuperview()
                self.countLabel.removeFromSuperview()
                self.initGamePieces()
            }
        }
        
        // Ball properties
        let ballBehavior = UIDynamicItemBehavior(items: [self.ball])
        ballBehavior.elasticity = 1.0
        ballBehavior.resistance = 0.0
        ballBehavior.friction = 0.0
        ballBehavior.allowsRotation = false
        self.animator.addBehavior(ballBehavior)
        
        // Slider Bar properties
        let sliderBarBehavior = UIDynamicItemBehavior(items: [self.sliderBar])
        sliderBarBehavior.allowsRotation = false
        sliderBarBehavior.density = 100000.0
        self.animator.addBehavior(sliderBarBehavior)
    }
    
    

    

    

    
    // Start Game (initialize gravity and collision behavior)
    func start() {
        self.startButton.isHidden = true
        self.scoreLabel.isHidden = true
        self.ball.isHidden = false
        self.sliderBar.isHidden = false
        self.countLabel.isHidden = false
        self.animator = UIDynamicAnimator(referenceView: self.view)
        gravity()
    
        self.count = 0
        
        let verticalMinOne = CGPoint.init(x: 0, y: 0)
        let verticalMinTwo = CGPoint.init(x: 0, y: view.frame.height)
        let verticalMaxOne = CGPoint.init(x: view.frame.maxX, y: 0)
        let verticalMaxTwo = CGPoint.init(x: view.frame.maxX, y: view.frame.height)
        let horizontalMaxOne = CGPoint.init(x: 0, y: 0)
        let horizontalMaxTwo = CGPoint.init(x: view.frame.maxX, y: 0)
        
        let horizontalMinOne = CGPoint.init(x: 0, y: view.frame.maxY - 50)
        let horizontalMinTwo = CGPoint.init(x: view.frame.maxX, y: view.frame.maxY - 50)

        let collisionBehavior = UICollisionBehavior(items: [self.ball, self.sliderBar])
        collisionBehavior.addBoundary(withIdentifier: "verticalMin" as NSCopying, from: verticalMinOne, to: verticalMinTwo)
        collisionBehavior.addBoundary(withIdentifier: "verticalMax" as NSCopying, from: verticalMaxOne, to: verticalMaxTwo)
        collisionBehavior.addBoundary(withIdentifier: "horizontalMax" as NSCopying, from: horizontalMaxOne, to: horizontalMaxTwo)
        
        let sliderCollisionBehavior = UICollisionBehavior(items: [self.sliderBar])
        sliderCollisionBehavior.addBoundary(withIdentifier: "horizontalMin" as NSCopying, from: horizontalMinOne, to: horizontalMinTwo)
        sliderCollisionBehavior.addBoundary(withIdentifier: "verticalMin" as NSCopying, from: verticalMinOne, to: verticalMinTwo)
        sliderCollisionBehavior.addBoundary(withIdentifier: "verticalMax" as NSCopying, from: verticalMaxOne, to: verticalMaxTwo)

        collisionBehavior.collisionDelegate = self
        self.animator.addBehavior(collisionBehavior)
        self.animator.addBehavior(sliderCollisionBehavior)
    }

    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !self.isBallRolling {
            let pushBehavior = UIPushBehavior(items: [self.ball], mode: .instantaneous)
            pushBehavior.magnitude = 1.5
            self.animator.addBehavior(pushBehavior)
            self.isBallRolling = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        let touchLocation: CGPoint? = touch?.location(in: self.view)
        let yPoint: CGFloat = self.sliderBarCenterPoint.y
        let sliderBarCenter = CGPoint(x: CGFloat((touchLocation?.x)!), y: yPoint)
        self.sliderBar.center = sliderBarCenter
        self.animator.updateItem(usingCurrentState: self.sliderBar)
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        self.count += 1
        self.countLabel.text = String(self.count)
    }

    
    
    // Constraints
    func setupCountLabel() {
        self.countLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 150).isActive = true
        self.countLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -285).isActive = true
    }
    
    func setupStartButton() {
        self.startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func setupScoreLabel() {
        self.scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.scoreLabel.bottomAnchor.constraint(equalTo: self.startButton.topAnchor, constant: -50).isActive = true
    }
    
    func setupSliderBar() {
        let margins = view.layoutMarginsGuide
        self.sliderBar.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }

    
    
    
    
    
    

}

