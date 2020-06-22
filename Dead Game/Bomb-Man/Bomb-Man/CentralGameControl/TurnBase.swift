//
//  TurnBase.swift
//  Bomb-Man
//
//  Created by shungfu on 2020/6/23.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import SpriteKit
import GameplayKit

enum TURN {
    static let P1 : String = "P1"
    static let P2 : String = "P2"
}

class TurnBaseNode : SKSpriteNode {
    
    var timerLabel = SKLabelNode(fontNamed: "Courier-Bold")
    var turnLabel = SKLabelNode(fontNamed: "Courier-Bold")
    var turn : String = TURN.P1
    var changeTurn : Bool = false
    
    var health1 = SKSpriteNode(imageNamed: "heart_1")
    var health2 = SKSpriteNode(imageNamed: "heart_1")
    var health3 = SKSpriteNode(imageNamed: "heart_1")
    
    let turnLimit : Int = 15
    var timer: Int = 15
    
    // Creating the rectangle of the size of the screen
    init(frame: CGRect) {
        super.init(texture: nil, color: UIColor.clear, size: frame.size)
        setupTurnBase()
//        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didChangeTurn() {
        self.changeTurn = !self.changeTurn
    }
    
    func update () {
        self.timer -= 1
        self.timerLabel.text = String("\(self.timer)")
        
        if self.timer <= 0 {
            // Change Turn
            if self.turn == TURN.P1 {
                self.turn = TURN.P2
            }
            else {
                self.turn = TURN.P1
            }
            self.changeTurn = true
            self.turnLabel.text = self.turn
            // zero timer
            self.timer = self.turnLimit
        }
    }
    
    func refresh() {
        self.timer = 15
        self.timerLabel.text = String("\(self.timer)")
        // Change Turn
        if self.turn == TURN.P1 {
            self.turn = TURN.P2
        }
        else {
            self.turn = TURN.P1
        }
        self.changeTurn = true
        self.turnLabel.text = self.turn
    }
    
    func setupTurnBase () {
        // Add Health
        addHealth(button: health1, position: CGPoint(x: -(size.width / 3 ) - 65, y: size.height / 3),
            name: "health1", scale: 2)
        addHealth(button: health2, position: CGPoint(x: -(size.width / 3 ) , y: size.height / 3),
                  name: "health2", scale: 2)
        addHealth(button: health3, position: CGPoint(x: -(size.width / 3 ) + 65, y: size.height / 3),
                  name: "health3", scale: 2)
        // Animation
        health1.run(SKAction(named: "heart")!, withKey: "heart")
        health2.run(SKAction(named: "heart")!, withKey: "heart")
        health3.run(SKAction(named: "heart")!, withKey: "heart")
        
        // Add Turn
        turnLabel.text = turn
        turnLabel.fontSize = 80
        turnLabel.fontColor = UIColor.black
        turnLabel.zPosition = 10
        turnLabel.position = CGPoint(x: (size.width / 3 ), y: size.height / 3.3)
        addChild(turnLabel)
        
        // Add Timer
        timerLabel.text = String("\(turnLimit)")
        timerLabel.fontSize = 80
        timerLabel.fontColor = UIColor.red
        timerLabel.zPosition = 10
        timerLabel.position = CGPoint(x: -(size.width / 10) + 150, y: size.height / 3.3)
        addChild(timerLabel)
    }
    
    func addHealth (button: SKSpriteNode, position: CGPoint, name: String, scale: CGFloat) {
        button.position = position
        button.setScale(scale)
        button.name = name
        button.zPosition = 10
        button.alpha = 1
        self.addChild(button)
    }
    
    
}
