//
//  AttackState.swift
//  Bomb-Man
//
//  Created by shungfu on 2020/6/22.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import SpriteKit
import GameplayKit

class AttackState : GKState {
    
    var cNode : CharacterNode?
    
    let animationTime = 1.0
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
        
        // 讓動畫飛一會
        if activeTime >= animationTime {
            activeTime = 0.0
            if cNode?.childNode(withName: "bomb") == nil {
                cNode?.action = ACTION.Shoot
                self.stateMachine?.enter(IdleState.self)
            }
        }
        else if activeTime < animationTime {
            activeTime = activeTime + lastUpdateTime
        }
        
        lastUpdateTime = seconds
    }
    
}
