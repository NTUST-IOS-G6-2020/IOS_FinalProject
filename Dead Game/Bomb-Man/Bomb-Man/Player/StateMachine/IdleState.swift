//
//  IdleState.swift
//  Bomb-Man
//
//  Created by shungfu on 2020/6/17.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import GameplayKit

class IdleState: GKState {
    
    var cNode: CharacterNode
    
    init(with node: CharacterNode) {
        cNode = node
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        // Character Movement
        var accSpeed: CGFloat = 0.0
        var decSpeed: CGFloat = 0.0
        
        // Ground
        if (cNode.grounded) {
            accSpeed = cNode.groundAccel
            decSpeed = cNode.groundDecel
        }
        // Air
        else {
            accSpeed = cNode.airAccel
            decSpeed = cNode.airDecel
        }
        
        // Walking
        if cNode.right {
            cNode.facing = 1.0
            cNode.xScale = 1.0
            cNode.hspeed = approach(start: cNode.hspeed, end: cNode.walkSpeed, shift: accSpeed)
        }
        else if cNode.left {
            cNode.facing = -1.0
            cNode.xScale = -1.0
            cNode.hspeed = approach(start: cNode.hspeed, end: -cNode.walkSpeed, shift: accSpeed)
        }
        // Stop walking
        else {
            cNode.hspeed = approach(start: cNode.hspeed, end: 0.0, shift: decSpeed)
        }
        
        // On the floor
        if cNode.grounded {
            // On the ground, but not landed
            if !cNode.landed {
                squashAndStretch(xScale: 1.3, yScale: 0.7)
                cNode.physicsBody?.velocity = CGVector(dx: (cNode.physicsBody?.velocity.dx)!, dy: 0.0)
                cNode.landed = true
            }
            // On the ground, but start to jump
            if cNode.jump {
                cNode.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: cNode.maxJump))
                cNode.grounded = false
                squashAndStretch(xScale: 0.7, yScale: 1.3)
            }
        }
        // In the Air
        if !cNode.grounded {
            // Falling
            if (cNode.physicsBody?.velocity.dy)! < CGFloat(0.0) {
                cNode.jump = false
            }
            // Jumping but stop pressing
            if (cNode.physicsBody?.velocity.dy)! > CGFloat(0.0) && !cNode.jump {
                cNode.physicsBody?.velocity.dy *= 0.5
            }
            cNode.landed = false
        }
        
        // Aim
        if cNode.aim {
            // Enter Aim state if no bomb exist
            if self.cNode.childNode(withName: "bomb") == nil {
                self.stateMachine?.enter(AimState.self)
            }
        }
        
        // Hit
        if cNode.takeDamage {
            squashAndStretch(xScale: 1.3, yScale: 1.3)
            self.stateMachine?.enter(DamageState.self)
        }
        
        
        // Animation
        cNode.xScale = approach(start: cNode.xScale, end: cNode.facing, shift: 0.05)
        cNode.yScale = approach(start: cNode.yScale, end: 1, shift: 0.05)
        
        // Move
        cNode.position.x = cNode.position.x + cNode.hspeed
    }
    
    // Makes movement better
    func approach (start: CGFloat, end: CGFloat, shift: CGFloat) -> CGFloat {
        if start < end {
            return min(start + shift, end)
        }
        else {
            return max(start - shift, end)
        }
    }
    
    // 跳躍擠壓人物
    func squashAndStretch(xScale: CGFloat, yScale: CGFloat) {
        cNode.xScale = xScale * cNode.facing
        cNode.yScale = yScale
    }
}
