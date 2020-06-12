//
//  GamePad.swift
//  Bomb-Man
//
//  Created by shungfu on 2020/6/12.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit
import SpriteKit

class GamePad: SKSpriteNode, ControlInputDelegate {
    func follow(command: String?) {
        // AA
    }
    
    
    var touchControlNode: TouchControlInputNode?
    
    func setupControls(camera: SKCameraNode, scene: SKScene){
        touchControlNode = TouchControlInputNode(frame: scene.frame)
        touchControlNode?.position = CGPoint.zero
        touchControlNode?.inputDelegate = self
        
        camera.addChild(touchControlNode!)
    }
    
}
