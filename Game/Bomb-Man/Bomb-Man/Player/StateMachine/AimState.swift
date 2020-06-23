//
//  AttackState.swift
//  Bomb-Man
//
//  Created by shungfu on 2020/6/21.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import SpriteKit
import GameplayKit

class AimState : GKState {
    var cNode : CharacterNode?
    
    let animationTime = 0.6
    var activeTime = 0.0
    
    private var lastUpdateTime : TimeInterval = 0
    
    init(with node: CharacterNode) {
        cNode = node
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        if self.lastUpdateTime == 0 {
            self.lastUpdateTime = seconds
        }
        
        // If attack button click, animate and create Bomb
        if cNode?.bombReady == false {
            if activeTime >= animationTime {
                cNode?.setNewBomb()
                activeTime = 0.0
            }
            else if activeTime < animationTime {
                activeTime = activeTime + lastUpdateTime
            }
        }
        
        // If bomb throws
        if cNode?.aim == false && cNode?.bombReady == false {
            self.stateMachine?.enter(AttackState.self)
        }
        
        lastUpdateTime = seconds
    }
    
}
