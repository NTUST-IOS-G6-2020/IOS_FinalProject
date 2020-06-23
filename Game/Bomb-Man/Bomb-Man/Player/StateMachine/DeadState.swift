//
//  DeadState.swift
//  Bomb-Man
//
//  Created by shungfu on 2020/6/23.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import SpriteKit
import GameplayKit

class DeadState : GKState {
    var cNode : CharacterNode
    var hitStun: CGFloat
    
    init(with node : CharacterNode) {
        self.cNode = node
        self.hitStun = cNode.hitStun
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        cNode.hspeed = approach(start: cNode.hspeed, end: 0, shift: 0.1)
        hitStun = hitStun - 1
        
        if hitStun <= 0 {
            // Refresh hit Stun
            hitStun = cNode.hitStun
            // stop
            cNode.hspeed = 0
            cNode.physicsBody?.velocity.dx = 0.0
            cNode.takeDamage = false
        }
        
        cNode.facing = cNode.hitFacing
//        cNode.xScale = approach(start: cNode.xScale, end: cNode.facing, shift: 1.0)
//        cNode.yScale = approach(start: cNode.yScale, end: 1, shift: 0.07)
        cNode.xScale = 1.5 * cNode.facing
        cNode.yScale = 1.2
        
        cNode.position.x = cNode.position.x + cNode.hspeed
    }
    
    func approach(start: CGFloat, end: CGFloat, shift: CGFloat) ->CGFloat {
        if start < end {
            return min(start + shift, end)
        }
        else {
            return max (start - shift, end)
        }
    }
    
}
