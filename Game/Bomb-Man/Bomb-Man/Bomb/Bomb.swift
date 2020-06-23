//
//  Bomb.swift
//  Bomb-Man
//
//  Created by shungfu on 2020/6/21.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import SpriteKit

class Bomb: SKSpriteNode {
    
    var image_alpha: CGFloat = 1
    var xOffset: CGFloat = 40
    var yOffset: CGFloat = -5
    
    var direction: CGFloat = 1
    
    // SKAction
    var actionOn : SKAction = SKAction(named: "bombOn")!
    var actionExplotion: SKAction = SKAction(named: "bombExplotion")!
    
    // Bomb Explode
    func explode (isWall : Bool) {
        // Adding the explotion
        let explotion = SKSpriteNode(imageNamed: "bomb_explotion_1")
        explotion.name = "bomb_explotion"
        explotion.zPosition = 10
        explotion.position = self.position
        
        // rotate if hit the wall
        if isWall {
            let rotate = SKAction.rotate(toAngle: .pi/2 , duration: 0.01)
            explotion.run(rotate)
        }
        
        self.parent?.addChild(explotion)
        
        // remove the bomb
        self.removeFromParent()
        
        // Add Bomb sound effect
        let soudEffect = SKAction.run {
            let bombSound: SKAudioNode?
            if let url = Bundle.main.url(forResource: "bomb", withExtension: ".mp3") {
                bombSound = SKAudioNode(url: url)
                bombSound?.run(SKAction.changeVolume(to: 300, duration: 0))
                explotion.addChild(bombSound!)
            }
        }
        let expand = SKAction.scale(to: 3.0, duration: 0.01)
        let animation = self.actionExplotion
        let remove = SKAction.run {
            explotion.removeFromParent()
        }

        let boom = SKAction.sequence([soudEffect, expand, animation, remove])
        explotion.run(boom)
    }
}
