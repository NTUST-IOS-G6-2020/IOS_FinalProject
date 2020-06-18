//
//  GamePad.swift
//  Bomb-Man
//
//  Created by shungfu on 2020/6/12.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import GameplayKit
import SpriteKit

class GamePad: GKComponent, ControlInputDelegate {
    
    var touchControlNode: TouchControlInputNode?
    var cNode : CharacterNode?
    
    // XCode component need
    override class var supportsSecureCoding: Bool { true }
    //Get the Character
    lazy var node: SKSpriteNode! = self.entity!.component(ofType: GKSKNodeComponent.self)?.node as? SKSpriteNode
    
    // Control the Character movement
    func follow(command: String?) {
        print("FOLLOW")
        if cNode != nil {
            switch command {
            case "left":
                cNode?.left = true
            case "cancle left", "stop left":
                cNode?.left = false
            case "right":
                cNode?.right = true
            case "cancle right", "stop right":
                cNode?.right = false
            default:
                print("command: \(String(describing: command!))")
            }
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        cNode?.stateMachine?.update(deltaTime: seconds)
    }
    
    func setupControls(camera: SKCameraNode, scene: SKScene){
        touchControlNode = TouchControlInputNode(frame: scene.frame)
        touchControlNode?.position = CGPoint.zero
        touchControlNode?.inputDelegate = self
        
        camera.addChild(touchControlNode!)
        
        if cNode == nil {
            cNode = node as? CharacterNode
            print(cNode as Any)
        }
    }
    
}
