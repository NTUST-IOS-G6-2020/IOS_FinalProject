//
//  PhysicDetection.swift
//  Bomb-Man
//
//  Created by shungfu on 2020/6/19.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import SpriteKit
import GameplayKit

enum ColliderType {
    static let PLAYER: UInt32 = 0x1 << 0    // 1
    static let GROUND: UInt32 = 0x1 << 1    // 2
    static let WALL : UInt32 = 0x1 << 2     // 4
    static let BOUNDARY: UInt32 = 0x1  << 3     // 8
}

class PhysicDetection: NSObject, SKPhysicsContactDelegate {
    
    // 一開始落地
    func didBegin(_ contact: SKPhysicsContact) {
        
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == ColliderType.PLAYER | ColliderType.GROUND {
            if let player = contact.bodyA.node as? CharacterNode {
                player.grounded = true
            }
            else if let player = contact.bodyB.node as? CharacterNode {
                player.grounded = true
            }
        }
        else if collision == ColliderType.PLAYER | ColliderType.WALL {
            if let player = contact.bodyA.node as? CharacterNode {
                if player.jump == true {
                    player.grounded = false
                    player.landed = false
                }
            }
            else if let player = contact.bodyB.node as? CharacterNode {
                if player.jump == true {
                    player.grounded = false
                    player.landed = false
                }
            }
        }
        else if collision == ColliderType.PLAYER | ColliderType.BOUNDARY {
            print("OUT of range")
            if let player = contact.bodyA.node as? CharacterNode {
                player.life = 0
            }
            else if let player = contact.bodyB.node as? CharacterNode {
                player.life = 0
            }
        }
        
        
    }
    
}
