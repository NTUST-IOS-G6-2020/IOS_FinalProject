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
    var readyToAttack = false
    var attack = false
    var hitStun: CGFloat = 3
    // Throw
    var prevThrowPower = 100.0
    var prevThrowAngle = 0.0
    var currentPower = 100.0
    var currentAngle = 0.0
    
    // Bomb
    var pinBombToPlayer : SKPhysicsJointFixed?
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
        let damageState = DamageState(with: self)
        stateMachine = GKStateMachine(states: [idleState, attackState, damageState])
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
        bomb.physicsBody?.mass = 1.0
        bomb.physicsBody?.categoryBitMask = ColliderType.BOMB
        bomb.physicsBody?.collisionBitMask = ColliderType.WALL | ColliderType.GROUND | ColliderType.PLAYER
        bomb.physicsBody?.contactTestBitMask = ColliderType.WALL | ColliderType.GROUND | ColliderType.PLAYER
        self.addChild(bomb)

        if let _ = self.physicsBody {
            bombReady = true
        }
        
    }
    
    func throwBomb (strength: CGVector) {
        if bombReady {
            if let bomb = childNode(withName: "bomb") {
                let toss = SKAction.run() {
                    bomb.physicsBody?.applyImpulse(strength)
                    bomb.physicsBody?.affectedByGravity = true
                    bomb.physicsBody?.applyAngularImpulse(0.2125)
                    self.bombReady = false
                }
                bomb.run(SKAction.sequence([toss]))
                // Update power and Angle
                prevThrowPower = 0
                prevThrowAngle = currentAngle
            }
        }
    }
    
}
