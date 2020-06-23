//
//  Animation.swift
//  Bomb-Man
//
//  Created by shungfu on 2020/6/19.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import SpriteKit
import GameplayKit

class P2_Animation : GKComponent {
    
    var cNode : CharacterNode?
    
    //Get the Character
    lazy var node: SKSpriteNode! = self.entity!.component(ofType: GKSKNodeComponent.self)?.node as? SKSpriteNode
    
    // Animation
    let animationName = ["P2_Idle", "P2_Run", "P2_JumpUp", "P2_JumpDown", "P2_JumpLand", "P2_Attack", "P2_AttackReady", "P2_Damage", "P2_Dead"]
    var actions = [String : SKAction]()
    
    override init() {
        super.init()
        
        for name in animationName {
            actions[name] = SKAction(named: name)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        for name in animationName {
            actions[name] = SKAction(named: name)
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        // Get Character node
        if cNode == nil {
            cNode = node as? CharacterNode
        }
        
        // Change State
        if cNode?.stateMachine?.currentState is IdleState {
            // On the floor
            if (cNode?.grounded)! {
                if (cNode?.left)! || (cNode?.right)! {
                    playAnimation(with: "P2_Run")
                }
                else {
                    playAnimation(with: "P2_Idle")
                }
            }
            // In the air
            else {
                if (cNode?.physicsBody?.velocity.dy)! > 30.0 {
                    playAnimation(with: "P2_JumpUp")
                }
                else if (cNode?.physicsBody?.velocity.dy)! < -450 {
                    playAnimation(with: "P2_JumpLand")
                }
                else if (cNode?.physicsBody?.velocity.dy)! < -300.0 {
                    playAnimation(with: "P2_JumpDown")
                }
            }
        }
        else if cNode?.stateMachine?.currentState is AimState {
            if (cNode?.aim)! && (cNode?.bombReady)! == false {
                playAnimation(with: "P2_AttackReady")
            }
        }
        else if cNode?.stateMachine?.currentState is AttackState {
            playAnimation(with: "P2_Attack")
        }
        else if cNode?.stateMachine?.currentState is DamageState {
            playAnimation(with: "P2_Damage")
        }
        else if cNode?.stateMachine?.currentState is DeadState {
            playAnimation(with: "P2_Dead")
        }
    }
    
    func playAnimation (with name:String) {
        if (cNode?.action(forKey: name) == nil) {
            cNode?.removeAllActions()
            if actions[name] != nil {
                cNode?.run(actions[name]!, withKey: name)
            }
        }
    }
    
    
}
