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
    
    // Take Damage
    var takeDamage = false
    
    // Move
    var left = false
    var right = false
//    var down = false
    
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
        // Not needed
        physicsBody?.contactTestBitMask = ColliderType.GROUND
    }
    
}
