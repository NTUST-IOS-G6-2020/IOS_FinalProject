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
    static let BOMB : UInt32 = 0x1 << 4     //16
    static let PLAYER2: UInt32 = 0x1 << 5       // 32
}

class PhysicDetection: NSObject, SKPhysicsContactDelegate {
    
    // 一開始落地
    func didBegin(_ contact: SKPhysicsContact) {
        
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        // Player1
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
        // Player2
        else if collision == ColliderType.PLAYER2 | ColliderType.GROUND {
            if let player = contact.bodyA.node as? CharacterNode {
                player.grounded = true
            }
            else if let player = contact.bodyB.node as? CharacterNode {
                player.grounded = true
            }
        }
        else if collision == ColliderType.PLAYER2 | ColliderType.WALL {
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
        else if collision == ColliderType.PLAYER2 | ColliderType.BOUNDARY {
            print("OUT of range")
            if let player = contact.bodyA.node as? CharacterNode {
                player.life = 0
            }
            else if let player = contact.bodyB.node as? CharacterNode {
                player.life = 0
            }
        }
        // Bomb
        else if collision == ColliderType.BOMB | ColliderType.WALL {
            print("Boom!!")
            if let bomb = contact.bodyA.node as? Bomb {
                bomb.explode(isWall: true)
            }
            else if let bomb = contact.bodyB.node as? Bomb {
                bomb.explode(isWall: true)
            }
        }
        else if collision == ColliderType.BOMB | ColliderType.GROUND {
            print("Boom!!")
            if let bomb = contact.bodyA.node as? Bomb {
                bomb.explode(isWall: false)
            }
            else if let bomb = contact.bodyB.node as? Bomb {
                bomb.explode(isWall: false)
            }
        }
        else if collision == ColliderType.BOMB | ColliderType.PLAYER {
            print("Boom!!")
            if let bomb = contact.bodyA.node as? Bomb {
                bomb.explode(isWall: false)
                // Take Damage
                if let player1 = contact.bodyB.node as? CharacterNode {
                    player1.takeDamage = true
                    player1.life -= 1
                    player1.hitFacing = bomb.direction
                    print(player1.life)
                }
            }
            else if let bomb = contact.bodyB.node as? Bomb {
                bomb.explode(isWall: false)
                // Take Damage
                if let player1 = contact.bodyA.node as? CharacterNode {
                    player1.takeDamage = true
                    player1.life -= 1
                    player1.hitFacing = bomb.direction
                    print(player1.life)
                }
            }
        }
        else if collision == ColliderType.BOMB | ColliderType.PLAYER2 {
            print("Boom!!")
            if let bomb = contact.bodyA.node as? Bomb {
                bomb.explode(isWall: false)
                // Take Damage
                if let player2 = contact.bodyB.node as? CharacterNode {
                    player2.takeDamage = true
                    player2.life -= 1
                    player2.hitFacing = bomb.direction
                    print(player2.life)
                }
            }
            else if let bomb = contact.bodyB.node as? Bomb {
                bomb.explode(isWall: false)
                // Take Damage
                if let player2 = contact.bodyA.node as? CharacterNode {
                    player2.takeDamage = true
                    player2.life -= 1
                    player2.hitFacing = bomb.direction
                    print(player2.life)
                }
            }
        }
        
    }
    
}
