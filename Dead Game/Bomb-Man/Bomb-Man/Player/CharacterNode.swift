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
    var down = false
    
    var landed = false
    var grounded = false
    var jump = false
    
    var maxJump: CGFloat = 250.0
    
    var airAccel:CGFloat = 0.1
    var airDecel:CGFloat = 0.1
    var groundAccel:CGFloat = 0.2
    var groundDecel:CGFloat = 0.5
    
    var facing: CGFloat = 1.0
    
    var hspeed:CGFloat = 0.0
    var walkSpeed:CGFloat = 4
    
    var stateMachine: GKStateMachine?
    
    func setUpStateMachine() {
        let idleState = IdleState(with: self)
        stateMachine = GKStateMachine(states: [idleState])
        stateMachine?.enter(IdleState.self)
    }
}
