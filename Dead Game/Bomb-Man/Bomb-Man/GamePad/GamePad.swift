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
    
    // XCode component need
    override class var supportsSecureCoding: Bool { true }
    
    var touchControlNode: TouchControlInputNode?
    var cNode : CharacterNode?
    
    // Control the Character movement
    func follow(command: String?) {
        print("FOLLOW")
        if cNode != nil {
            print("NOT NIL")
        }
    }
    
    func setupControls(camera: SKCameraNode, scene: SKScene){
        touchControlNode = TouchControlInputNode(frame: scene.frame)
        touchControlNode?.position = CGPoint.zero
        touchControlNode?.inputDelegate = self
        
        camera.addChild(touchControlNode!)
        
        if cNode == nil {
            print("cNode nil")
            
        }
        
    }
    
}
