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
    
    var left = false
    var right = false
    
    var hspeed:CGFloat = 0.0
    var walkSpeed:CGFloat = 2
    
    var stateMachine: GKStateMachine?
    
    func setUpStateMachine() {
        let idleState = IdleState(with: self)
        stateMachine = GKStateMachine(states: [idleState])
        stateMachine?.enter(IdleState.self)
    }
}
