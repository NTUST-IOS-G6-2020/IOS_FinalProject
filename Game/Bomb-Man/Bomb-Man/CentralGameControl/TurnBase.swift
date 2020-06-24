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
let MAX_TIME = 5

class PauseSpriteNode : SKSpriteNode {
    static var pause: Bool = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        PauseSpriteNode.pause = true
        print("pause")
    }
}

class TurnBaseNode : SKSpriteNode {
    
    var timerLabel = SKLabelNode(fontNamed: "Courier-Bold")
//    var turnLabel = SKLabelNode(fontNamed: "Courier-Bold")
    var turn : String = TURN.P1
    var changeTurn : Bool = false
    // End Game and Winner
    static var winner: String = TURN.P1
    var endGame: Bool = false
    // Pause
    var pause: Bool = false
    var pauseBtn = PauseSpriteNode(imageNamed: "Close")
    
    
    var p1_health1 = SKSpriteNode(imageNamed: "heart_1")
    var p1_health2 = SKSpriteNode(imageNamed: "heart_1")
    var p1_health3 = SKSpriteNode(imageNamed: "heart_1")
    var p1_label = SKLabelNode(fontNamed: "Courier-Bold")
    var p1_healthBar = [SKSpriteNode]()
    
    var p2_health1 = SKSpriteNode(imageNamed: "heart_1")
    var p2_health2 = SKSpriteNode(imageNamed: "heart_1")
    var p2_health3 = SKSpriteNode(imageNamed: "heart_1")
    var p2_label = SKLabelNode(fontNamed: "Courier-Bold")
    var p2_healthBar = [SKSpriteNode]()
    
    var p1_health = MAX_LIFE
    var p2_health = MAX_LIFE
    
//    let turnLimit : Int = 5
    var timer: Int = MAX_TIME
    
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
    
    // Start update Timer
    func update () {
        // Update Timer
        self.timer -= 1
        
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
            self.timer = MAX_TIME
        }
        self.timerLabel.text = String("\(self.timer)")
    }
    
    func updatePlayerHealth(p1_life: Int, p2_life: Int) {
        
        for i in 0..<(MAX_LIFE - p1_life) {
            p1_healthBar[i].isHidden = true
        }
        for i in 0..<(MAX_LIFE - p2_life) {
            p2_healthBar[i].isHidden = true
        }
        
        if p1_life <= 0 {
            endGame = true
            TurnBaseNode.winner = TURN.P2
        }
        else if p2_life <= 0 {
            endGame = true
            TurnBaseNode.winner = TURN.P1
        }
    }
    
    // Change Turn
    func refresh() {
        self.timer = MAX_TIME
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
        p1_healthBar.append(p1_health1)
        p1_healthBar.append(p1_health2)
        p1_healthBar.append(p1_health3)
        
        addHealth(button: p2_health1, position: CGPoint(x: (size.width / 3 ) - 65, y: size.height / 3.3),
            name: "health1", scale: 2)
        addHealth(button: p2_health2, position: CGPoint(x: (size.width / 3 ) , y: size.height / 3.3),
                  name: "health2", scale: 2)
        addHealth(button: p2_health3, position: CGPoint(x: (size.width / 3 ) + 65, y: size.height / 3.3),
                  name: "health3", scale: 2)
        p2_healthBar.append(p2_health1)
        p2_healthBar.append(p2_health2)
        p2_healthBar.append(p2_health3)
        
        pauseBtn.position = CGPoint(x: (size.width / 4 ) - 230, y: size.height / 3)
        pauseBtn.name = "pause"
        pauseBtn.setScale(3)
        pauseBtn.zPosition = 11
        pauseBtn.alpha = 1
        pauseBtn.isUserInteractionEnabled = true
        self.addChild(pauseBtn)
        
        // Add player Label
        addLabel(label: p1_label, position: CGPoint(x: -(size.width / 3 ), y: size.height / 3), name: TURN.P1, fontSize: 50)
        p1_label.fontColor = UIColor.orange
        addLabel(label: p2_label, position: CGPoint(x: (size.width / 3 ), y: size.height / 3), name: TURN.P2, fontSize: 50)
        
        // Add Timer
        timerLabel.text = String("\(MAX_TIME)")
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
