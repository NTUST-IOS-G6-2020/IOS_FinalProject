//
//  AttackState.swift
//  Bomb-Man
//
//  Created by shungfu on 2020/6/21.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import SpriteKit
import GameplayKit

class AttackState : GKState {
    var cNode : CharacterNode?
    
    var activeTime = 1.0
    private var lastUpdateTime : TimeInterval = 0
    
    init(with node: CharacterNode) {
        cNode = node
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        if self.lastUpdateTime == 0 {
            self.lastUpdateTime = seconds
        }
        
        // If attack button click animate and create Bomb
        if activeTime >= 0 {
            if activeTime == 1.0 {
                cNode?.setNewBomb()
                cNode?.throwBomb(strength: CGVector(dx: 1600, dy: 1100))
            }
            activeTime = activeTime - lastUpdateTime
        }
        else {
            self.stateMachine?.enter(IdleState.self)
            activeTime = 1.0
        }
        
        lastUpdateTime = seconds
    }
    
}
