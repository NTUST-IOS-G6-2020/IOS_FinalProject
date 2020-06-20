import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    var thePlayer: SKSpriteNode = SKSpriteNode()
    var theCamera: SKCameraNode = SKCameraNode()
    var physicsDelegate = PhysicDetection()
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }
    
    // Setup all the shit
    override func didMove(to view: SKView) {
        
        // Player
        if self.childNode(withName: "Player") != nil {
            thePlayer = (self.childNode(withName: "Player") as! SKSpriteNode)
            
            let entity = GKEntity()
            // Set up Player
            let nodeComponent : GKSKNodeComponent = GKSKNodeComponent(node: thePlayer)
            entity.addComponent(nodeComponent)
            // Add GamePlay Control
            entity.addComponent(GamePad())
            entity.component(ofType: GamePad.self)?.setupControls(camera: camera!, scene: self)
            // Add Animation Component
            entity.addComponent(Animation())
            
            // Append entity
            entities.append(entity)
            
            // setup State Machine
            (thePlayer as? CharacterNode)?.setUpStateMachine()
        }
        
        // Camera
        if self.childNode(withName: "Camera") != nil {
            theCamera = self.childNode(withName: "Camera") as! SKCameraNode
        }
        self.camera = theCamera
        
        // Set tilemap physics
        if let tilemap = childNode(withName: "ForegroundMap") as? SKTileMapNode {
            giveTilemapPhysicsBody(map: tilemap)
        }
        
        // Physics
        self.physicsWorld.contactDelegate = physicsDelegate
    }
    
    func giveTilemapPhysicsBody (map: SKTileMapNode) {
        let tileMap = map
        let tileSize = tileMap.tileSize
        let halfWidth = CGFloat(tileMap.numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(tileMap.numberOfRows) / 2.0 * tileSize.height
        
        for col in 0..<tileMap.numberOfColumns {
            for row in 0..<tileMap.numberOfRows {
                if let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row) {
                    let isEdgeTile = tileDefinition.userData?["AddBody"] as? Int
                    if isEdgeTile != 0 {
                        let tileArray = tileDefinition.textures
                        let tileTexture = tileArray[0]
                        let x = CGFloat(col) * tileSize.width - halfWidth + (tileSize.width/2)
                        let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height/2)
                        _ = CGRect(x: 0, y: 0, width: tileSize.width, height: tileSize.height)
                        let tileNode = SKNode()
                        
                        tileNode.position = CGPoint(x: x, y: y)
//                        tileNode.physicsBody = SKPhysicsBody(texture: tileTexture, size: CGSize(width: tileTexture.size().width, height: tileTexture.size().height))
                        tileNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: tileTexture.size().width, height: tileTexture.size().height))
                        tileNode.physicsBody?.linearDamping = 0
                        tileNode.physicsBody?.affectedByGravity = false
                        tileNode.physicsBody?.allowsRotation = false
                        tileNode.physicsBody?.restitution = 0
                        tileNode.physicsBody?.isDynamic = false
                        tileNode.physicsBody?.friction = 20.0
                        tileNode.physicsBody?.mass = 30.0
                        tileNode.physicsBody?.contactTestBitMask = 0
                        tileNode.physicsBody?.fieldBitMask = 0
                        tileNode.physicsBody?.collisionBitMask = 0
                        
                        
                        if isEdgeTile == 1{
                            print("IS1")
                            tileNode.physicsBody?.restitution = 0.0
                            tileNode.physicsBody?.contactTestBitMask = ColliderType.PLAYER
                        }
                        
                        tileNode.physicsBody?.categoryBitMask = ColliderType.GROUND
                        tileMap.addChild(tileNode)
                    }
                }
            }
        }
    }
    
    
    // Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
        
        // Camera Follow the player x position
        theCamera.position.x = thePlayer.position.x
        
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
    
}
