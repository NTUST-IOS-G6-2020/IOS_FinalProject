//
//  Animation.swift
//  Bomb-Man
//
//  Created by shungfu on 2020/6/19.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import SpriteKit
import GameplayKit

class Animation : GKComponent {
    
    var cNode : CharacterNode?
    //Get the Character
    lazy var node: SKSpriteNode! = self.entity!.component(ofType: GKSKNodeComponent.self)?.node as? SKSpriteNode
    
    // Animation
    var idleAnimation: SKAction?
    var runAnimation: SKAction?
    var jumpUpAnimation: SKAction?
    var jumpDownAnimation: SKAction?
    var jumpLandAnimation: SKAction?
//    var attackAnimation: SKAction?
    
    override init() {
        super.init()
        idleAnimation = SKAction(named: "Idle")
        runAnimation = SKAction(named: "Run")
        jumpUpAnimation = SKAction(named: "JumpUp")
        jumpDownAnimation = SKAction(named: "JumpDown")
        jumpLandAnimation = SKAction(named: "JumpLand")
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        idleAnimation = SKAction(named: "Idle")
        runAnimation = SKAction(named: "Run")
        jumpUpAnimation = SKAction(named: "JumpUp")
        jumpDownAnimation = SKAction(named: "JumpDown")
        jumpLandAnimation = SKAction(named: "JumpLand")
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
                    if (cNode?.action(forKey: "Run") == nil){
                        cNode?.removeAllActions()
                        cNode?.run(runAnimation!, withKey: "Run")
                    }
                }
                else {
                    if (cNode?.action(forKey: "Idle") == nil) {
                        cNode?.removeAllActions()
                        cNode?.run(idleAnimation!, withKey: "Idle")
                    }
                }
            }
            // In the air
            else {
                if (cNode?.physicsBody?.velocity.dy)! > 30.0 {
                    
                    if (cNode?.action(forKey: "JumpUp") == nil) {
                        cNode?.removeAllActions()
                        cNode?.run(jumpUpAnimation!, withKey: "JumpUp")
                    }
                }
                else if (cNode?.physicsBody?.velocity.dy)! < -450 {
                    
                    if (cNode?.action(forKey: "JumpLand") == nil) {
                        cNode?.removeAllActions()
                        cNode?.run(jumpLandAnimation!, withKey: "JumpLand")
                    }
                }
                else if (cNode?.physicsBody?.velocity.dy)! < -300.0 {
                    
                    if (cNode?.action(forKey: "JumpDown") == nil) {
                        cNode?.removeAllActions()
                        cNode?.run(jumpDownAnimation!, withKey: "JumpDown")
                    }
                }
            }
        }
        
    }
    
    
}
