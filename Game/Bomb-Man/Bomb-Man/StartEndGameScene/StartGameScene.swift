//
//  StartGameScene.swift
//  Bomb-Man
//
//  Created by shungfu on 2020/6/23.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import SpriteKit
import GameplayKit

class StartGameScene: SKScene {
    
    var startBtn: SKSpriteNode!
    var Music : SKAudioNode?
    
    override func didMove(to view: SKView) {
        createScene()
        addMusic(mp3: "BGM0")
    }
    
    func addMusic (mp3: String) {
        guard let url = Bundle.main.url(forResource: mp3, withExtension: "mp3") else{
            print(mp3, " Not Found")
            return
        }
        Music = SKAudioNode(url: url)
        addChild(Music!)
    }
    
    func createScene() {
        let bgd = SKSpriteNode(imageNamed: "StartGame")
        bgd.size.width = self.size.width
        bgd.size.height = self.size.height
        bgd.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        bgd.zPosition = -1
        
        let pirateLabel = SKLabelNode(fontNamed: "Bradley Hand Bold")
        pirateLabel.name = "piratelabel"
        pirateLabel.position = CGPoint(x: self.frame.midX - 0.15, y: self.frame.midY + 0.2)
        pirateLabel.text = "Pirate"
        pirateLabel.fontSize = 20
        pirateLabel.zPosition = 2
        // DarkSlateGray    47 79 79
        pirateLabel.fontColor = UIColor.init(red: 47/255, green: 79/255, blue: 79/255, alpha: 1)
        pirateLabel.setScale(0.008)
        pirateLabel.xScale = 0.005
        
        let andLabel = SKLabelNode(fontNamed: "Bradley Hand Bold")
        andLabel.name = "andlabel"
        andLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 0.2)
        andLabel.text = "&"
        andLabel.fontSize = 20
        andLabel.zPosition = 2
        andLabel.fontColor = UIColor.init(red: 47/255, green: 79/255, blue: 79/255, alpha: 1)
        andLabel.setScale(0.003)
        andLabel.xScale = 0.002
        
        let bombLabel = SKLabelNode(fontNamed: "Bradley Hand Bold")
        bombLabel.name = "andlabel"
        bombLabel.position = CGPoint(x: self.frame.midX + 0.15, y: self.frame.midY + 0.2)
        bombLabel.text = "Bomb"
        bombLabel.fontSize = 20
        bombLabel.zPosition = 2
        bombLabel.fontColor = UIColor.init(red: 139/255, green: 0/255, blue: 0/255, alpha: 1)
        bombLabel.setScale(0.008)
        bombLabel.xScale = 0.005
        
        
        let player1 = SKSpriteNode(imageNamed: "p1_idel_2")
        player1.run(SKAction(named: "P1_Opening")!, withKey: "P1_Opening")
        player1.position = CGPoint(x: self.frame.midX - 0.45, y: self.frame.minY + 0.427)
        player1.size = CGSize(width: 0.3, height: 0.6)
        player1.zPosition = 1
        
        let player2 = SKSpriteNode(imageNamed: "p2_idle_2")
        player2.run(SKAction(named: "P2_Opening")!, withKey: "P2_Opening")
        player2.position = CGPoint(x: self.frame.midX + 0.4, y: self.frame.minY + 0.5)
        player2.size = CGSize(width: 0.35, height: 0.8)
        player2.xScale = -1
        player2.zPosition = 1
        
        startBtn = SKSpriteNode(imageNamed: "Chest Close 01")
        startBtn.run(SKAction(named: "Chest")!, withKey: "Chest")
        startBtn.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 0.227)
        startBtn.size = CGSize(width: 0.2, height: 0.2)
        startBtn.zPosition = 1

        
        self.addChild(player1)
        self.addChild(player2)
        self.addChild(bgd)
        self.addChild(pirateLabel)
        self.addChild(andLabel)
        self.addChild(bombLabel)
        self.addChild(startBtn)
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
                    view.presentScene(sceneNode, transition: .fade(withDuration: 1.5))
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
        for t in touches {
            let node = self.nodes(at: t.location(in: self))
            if let button =  startBtn{
                if node.contains(button) {
                    reloadGameScene()
                }
            }
        }
    }
    
}
