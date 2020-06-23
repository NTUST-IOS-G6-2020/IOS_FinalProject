//
//  EndGameScene.swift
//  Bomb-Man
//
//  Created by shungfu on 2020/6/23.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


class EndGameScene :SKScene {
    
    override func didMove(to view: SKView) {
        createScene()
    }
    
    func createScene() {
        let bgd = SKSpriteNode(imageNamed: "EndGame")
        bgd.size.width = self.size.width
        bgd.size.height = self.size.height
        bgd.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        bgd.zPosition = -1
        
        let youLossLabel = SKLabelNode(fontNamed: "Chalkduster")
        youLossLabel.name = "label"
        youLossLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 0.2)
        youLossLabel.text = String("\(TurnBaseNode.winner) Win!!")
        youLossLabel.fontSize = 20
        youLossLabel.zPosition = 2
        youLossLabel.fontColor = UIColor.black
        youLossLabel.setScale(0.005)
        
        let player = SKSpriteNode(imageNamed: "bomb_off_1")
        if TurnBaseNode.winner == "P1" {
            player.texture = SKTexture(imageNamed: "p1_idel_1")
            player.run(SKAction(named: "Idle")!, withKey: "Idle")
        }
        else {
            player.texture = SKTexture(imageNamed: "p2_idle_1")
            player.run(SKAction(named: "P2_Idle")!, withKey: "P2_Idle")
        }
        player.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 0.5)
        player.size = CGSize(width: 0.2, height: 0.3)
        player.zPosition = 1
        
        
        self.addChild(player)
        self.addChild(bgd)
        self.addChild(youLossLabel)
    }
    
    func reloadGameScene () {
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view {
                    view.presentScene(sceneNode, transition: .doorway(withDuration: 2))
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
//                    view.showsPhysics = true
                    view.isMultipleTouchEnabled = true
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        reloadGameScene()
    }
}
