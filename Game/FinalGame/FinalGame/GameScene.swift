//
//  GameScene.swift
//  FinalGame
//
//  Created by 柯元豪 on 2020/5/26.
//  Copyright © 2020 Yuanhao. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
//    var worldNode: SKNode!
//    var backgroundLayer: TileMapLayer!
//    var tileMap: JSTileMap?
//
//    required init?(coder: NSCoder) {
//        fatalError("NSCoding not supported")
//    }
//
//    override init(size: CGSize){
//        super.init(size: size)
//    }
//
//    func createScenery() -> TileMapLayer? {
//        tileMap = JSTileMap(named: "background.tmx")
//        return  TmxTileMapLayer(tmxLayer: tileMap!.layerNamed("backGround"))
//    }
//
//    override func didMove(to view: SKView){
//        createWorld()
//    }
//
//    func createWorld() {
//        backgroundLayer = createScenery()
//        worldNode = SKNode()
//
//        if tileMap != nil{
//            worldNode.addChild(tileMap!)
//        }
//        worldNode.addChild(backgroundLayer)
//        addChild(worldNode)
//    }
    
        
    var tileMap = JSTileMap(named: "map.tmx")
    var MyLocation = CGPointMake(0, 0)
    var x = CGFloat(0)
    
    override func didMove(to view: SKView) {
           
           self.anchorPoint = CGPoint(x: 0, y: 0)
           self.position = CGPoint(x: 0, y: 0)
    
            tileMap!.position = CGPoint(x: 0, y: 0)
    
            self.addChild(tileMap!)
    
           self.backgroundColor = SKColor(colorLiteralRed: 0.4, green: 0.7, blue: 0.95, alpha: 1.0)
       }
}
