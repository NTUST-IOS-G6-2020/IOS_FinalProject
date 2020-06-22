//
//  CharacterNode.swift
//  Bomb-Man
//
//  Created by shungfu on 2020/6/17.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import SpriteKit
import GameplayKit

class CharacterNode: SKSpriteNode {
    
    // Life
    var life : Int = 3
    
    // Attack
    var aim = false
    var hitStun: CGFloat = 3
    // Throw
    var currentPower = 100.0
    var currentAngle = 0.0
    
    // Bomb
    var bombReady = false
    
    // Take Damage
    var takeDamage = false
    
    // Move
    var left = false
    var right = false
    
    // Jumps
    var landed = false
    var grounded = false
    var jump = false
    
    var maxJump: CGFloat = 250.0
    
    // The Accel and Decel
    var airAccel:CGFloat = 0.1
    var airDecel:CGFloat = 0.1
    var groundAccel:CGFloat = 0.2
    var groundDecel:CGFloat = 0.5
    
    // Facing
    var facing: CGFloat = 1.0
    
    // Speed
    var hspeed:CGFloat = 0.0
    var walkSpeed:CGFloat = 4
    
    // State Machine
    var stateMachine: GKStateMachine?
    
    func setUpStateMachine() {
        let idleState = IdleState(with: self)
        let attackState = AttackState(with: self)
        let aimState = AimState(with: self)
        let damageState = DamageState(with: self)
        stateMachine = GKStateMachine(states: [idleState, aimState, attackState, damageState])
        stateMachine?.enter(IdleState.self)
    }
    
    // 為什麼手尻？ 因為他的xocde scene editor有他得bug
    func createPhysics() {
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: CGSize(width: 150, height: 151))
        physicsBody?.affectedByGravity = true
        physicsBody?.allowsRotation = false
        physicsBody?.restitution = 0.0
        physicsBody?.friction = 0.0087
        physicsBody?.categoryBitMask = ColliderType.PLAYER
        physicsBody?.collisionBitMask = (ColliderType.GROUND | ColliderType.WALL | ColliderType.BOUNDARY)
        physicsBody?.contactTestBitMask = ColliderType.GROUND
    }
    
    // MARK:- Bomb Section
    func setNewBomb () {
        // New a custom SKSpriteNode
        let bomb = Bomb(imageNamed: "bomb_on_1")
        bomb.name = "bomb"
        bomb.alpha = bomb.image_alpha
        bomb.setScale(1.7)
        bomb.zPosition = 2
        // Bomb Position 
        bomb.position = CGPoint(x: bomb.xOffset, y: bomb.yOffset)
        // SKAction
        bomb.run(bomb.actionOn, withKey: "bombOn")
        
        // Make bomb Physics
        bomb.physicsBody = SKPhysicsBody(circleOfRadius: 26, center: CGPoint(x: bomb.position.x - 60, y: bomb.position.y - 30))
        bomb.physicsBody?.affectedByGravity = false
        bomb.physicsBody?.mass = 1.3
        bomb.physicsBody?.categoryBitMask = ColliderType.BOMB
        bomb.physicsBody?.collisionBitMask = ColliderType.WALL | ColliderType.GROUND | ColliderType.PLAYER
        bomb.physicsBody?.contactTestBitMask = ColliderType.WALL | ColliderType.GROUND | ColliderType.PLAYER
        self.addChild(bomb)

        if let _ = bomb.physicsBody {
            bombReady = true
        }
        
        // Add aim line
        let aimLine = SKSpriteNode(imageNamed: "aimline")
        aimLine.name = "aimLine"
        aimLine.alpha = 1
        aimLine.setScale(0.187)
        aimLine.zPosition = 2
        aimLine.position = CGPoint(x: 70, y: 10)
        aimLine.anchorPoint = CGPoint(x: 0.087, y: 0.5)
        self.addChild(aimLine)
    }
    
    func throwBomb (strength: CGVector) {
        if bombReady {
            if let bomb = childNode(withName: "bomb") {
                let toss = SKAction.run() {
                    bomb.physicsBody?.applyImpulse(strength)
                    bomb.physicsBody?.affectedByGravity = true
//                    bomb.physicsBody?.applyAngularImpulse(strength.dx/10000)
                    // Shoot only once
                    self.bombReady = false
                    self.aim = false
                }
                bomb.run(SKAction.sequence([toss]))
                
                // Remove aimline
                removeAimLine()
            }
        }
    }
    
    func removeAimLine () {
        if let aimline = self.childNode(withName: "aimLine") {
            let pause = SKAction.wait(forDuration: 0.287)
            let zeroOut = SKAction.scale(to: CGSize(width: 0, height: 0), duration: 0.187)
            let remove = SKAction.run {
                aimline.removeFromParent()
            }
            aimline.run(SKAction.sequence([pause, zeroOut, remove]))
        }
    }
    
}
