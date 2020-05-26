//
//  TileMapLayer.swift
//  FinalGame
//
//  Created by 柯元豪 on 2020/5/26.
//  Copyright © 2020 Yuanhao. All rights reserved.
//

import SpriteKit

class TileMapLayer: SKNode {
    let tileSize: CGSize
    let gridSize: CGSize
    let layerSize: CGSize
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(tileSize: CGSize, gridSize: CGSize, layerSize: CGSize? = nil){
        self.tileSize = tileSize
        self.gridSize = gridSize
        
        if layerSize != nil{
            self.layerSize = layerSize!
        }
        else{
            self.layerSize = CGSize(width: tileSize.width * gridSize.width, height: tileSize.height * gridSize.height)
        }
        super.init()
    }
}
