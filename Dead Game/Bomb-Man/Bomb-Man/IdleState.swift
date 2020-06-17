//
//  IdleState.swift
//  Bomb-Man
//
//  Created by shungfu on 2020/6/17.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import GameplayKit

class IdleState: GKState {
    
    var characterNode: CharacterNode
    
    init(with node: CharacterNode) {
        characterNode = node
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if characterNode.right {
            characterNode.hspeed = characterNode.walkSpeed
        }
        else if characterNode.left {
            characterNode.hspeed = -characterNode.walkSpeed
        }
        else {
            characterNode.hspeed = 0.0
        }
        characterNode.position.x = characterNode.position.x + characterNode.hspeed
    }
    
}
