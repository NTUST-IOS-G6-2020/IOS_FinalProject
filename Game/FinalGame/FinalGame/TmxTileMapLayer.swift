//
//  TmxTileMapLayer.swift
//  FinalGame
//
//  Created by 柯元豪 on 2020/5/26.
//  Copyright © 2020 Yuanhao. All rights reserved.
//

import SpriteKit

class TmxTileMapLayer: TileMapLayer{
    var layer: TMXLayer
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(tmxLayer: TMXLayer) {
        layer = tmxLayer
        super.init(tileSize: tmxLayer.mapTileSize, gridSize: tmxLayer.layerInfo.layerGridSize, layerSize: CGSize(width: tmxLayer.layerWidth, height: tmxLayer.layerHeight))
    }
}
