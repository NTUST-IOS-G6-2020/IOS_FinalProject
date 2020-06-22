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

let MAX_LIFE = 3

class TurnBaseNode : SKSpriteNode {
    
    var timerLabel = SKLabelNode(fontNamed: "Courier-Bold")
//    var turnLabel = SKLabelNode(fontNamed: "Courier-Bold")
    var turn : String = TURN.P1
    var changeTurn : Bool = false
    
    var p1_health1 = SKSpriteNode(imageNamed: "heart_1")
    var p1_health2 = SKSpriteNode(imageNamed: "heart_1")
    var p1_health3 = SKSpriteNode(imageNamed: "heart_1")
    var p1_label = SKLabelNode(fontNamed: "Courier-Bold")
    
    var p2_health1 = SKSpriteNode(imageNamed: "heart_1")
    var p2_health2 = SKSpriteNode(imageNamed: "heart_1")
    var p2_health3 = SKSpriteNode(imageNamed: "heart_1")
    var p2_label = SKLabelNode(fontNamed: "Courier-Bold")
    
    var p1_health = MAX_LIFE
    var p2_health = MAX_LIFE
    
    let turnLimit : Int = 15
    var timer: Int = 15
    
    // Creating the rectangle of the size of the screen
    init(frame: CGRect) {
        super.init(texture: nil, color: UIColor.clear, size: frame.size)
        setupTurnBase()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didChangeTurn() {
        self.changeTurn = !self.changeTurn
    }
    
    func update () {
        // Update Timer
        self.timer -= 1
        self.timerLabel.text = String("\(self.timer)")
        
        if self.timer <= 0 {
            // Change Turn
            if self.turn == TURN.P1 {
                self.turn = TURN.P2
                p2_label.fontColor = UIColor.orange
                p1_label.fontColor = UIColor.black
            }
            else {
                self.turn = TURN.P1
                p2_label.fontColor = UIColor.black
                p1_label.fontColor = UIColor.orange
            }
            self.changeTurn = true
            // zero timer
            self.timer = self.turnLimit
        }
    }
    
    func updatePlayerHealth(life: Int) {
//        self.health1.isHidden = true
        for _ in 0...(3-life) {
            
        }
    }
    
    func refresh() {
        self.timer = 15
        self.timerLabel.text = String("\(self.timer)")
        // Change Turn
        if self.turn == TURN.P1 {
            self.turn = TURN.P2
            p2_label.fontColor = UIColor.orange
            p1_label.fontColor = UIColor.black
        }
        else {
            self.turn = TURN.P1
            p2_label.fontColor = UIColor.black
            p1_label.fontColor = UIColor.orange
        }
        self.changeTurn = true
    }
    
    func setupTurnBase () {
        // Add Health
        addHealth(button: p1_health1, position: CGPoint(x: -(size.width / 3 ) - 65, y: size.height / 3.3),
            name: "health1", scale: 2)
        addHealth(button: p1_health2, position: CGPoint(x: -(size.width / 3 ) , y: size.height / 3.3),
                  name: "health2", scale: 2)
        addHealth(button: p1_health3, position: CGPoint(x: -(size.width / 3 ) + 65, y: size.height / 3.3),
                  name: "health3", scale: 2)
        
        addHealth(button: p2_health1, position: CGPoint(x: (size.width / 3 ) - 65, y: size.height / 3.3),
            name: "health1", scale: 2)
        addHealth(button: p2_health2, position: CGPoint(x: (size.width / 3 ) , y: size.height / 3.3),
                  name: "health2", scale: 2)
        addHealth(button: p2_health3, position: CGPoint(x: (size.width / 3 ) + 65, y: size.height / 3.3),
                  name: "health3", scale: 2)
        
        // Add player Label
        addLabel(label: p1_label, position: CGPoint(x: -(size.width / 3 ), y: size.height / 3), name: TURN.P1, fontSize: 50)
        p1_label.fontColor = UIColor.orange
        addLabel(label: p2_label, position: CGPoint(x: (size.width / 3 ), y: size.height / 3), name: TURN.P2, fontSize: 50)
        
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
        button.zPosition = 11
        button.alpha = 1
        button.run(SKAction(named: "heart")!, withKey: "heart")
        self.addChild(button)
    }
    
    func addLabel (label: SKLabelNode, position: CGPoint, name: String, fontSize: CGFloat) {
        label.text = name
        label.fontSize = fontSize
        label.fontColor = UIColor.black
        label.zPosition = 10
        label.position = position
        addChild(label)
    }
    
}
