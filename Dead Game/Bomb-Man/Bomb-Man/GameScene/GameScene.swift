import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    // player and camera
    var thePlayer: SKSpriteNode = SKSpriteNode()
    var theCamera: SKCameraNode = SKCameraNode()
    var physicsDelegate = PhysicDetection()
    
    // throw power bar
    var powerMeterNode: SKSpriteNode? = nil
    var powerMeterFilledNode: SKSpriteNode? = nil
    // Check if bomb exist too long
    var bombTime: TimeInterval = 0.0
    
    // 背景捲軸
    var parallaxComponentSystem : GKComponentSystem<ParallaxComponent>?
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }
    
    func addNode(name: String, layer: Int) {
        if self.childNode(withName: name) != nil {
            let node = self.childNode(withName: name) as! SKSpriteNode
            
            let entity = GKEntity()
            let nodeComponent: GKSKNodeComponent = GKSKNodeComponent(node: node)
            entity.addComponent(nodeComponent)
            let paraComponent = ParallaxComponent()
            paraComponent.layer = layer
            entity.addComponent(paraComponent)
            entities.append(entity)
        }
    }
    
    // 幫背景 node 加入 component
    func setupParallaxBG () {
        addNode(name: "sCloud1", layer: 1)
        addNode(name: "sCloud2", layer: 1)
        addNode(name: "sCloud3", layer: 1)
        addNode(name: "sCloud4", layer: 1)
        addNode(name: "sCloud5", layer: 1)
    }
    
    // Setup all the sht
    override func didMove(to view: SKView) {
        // 背景 node 加入 entity
        setupParallaxBG()
        
        // Set background parallax
        parallaxComponentSystem = GKComponentSystem.init(componentClass: ParallaxComponent.self)
        
        for entity in self.entities {
            parallaxComponentSystem?.addComponent(foundIn: entity)
        }
        
        for component in (parallaxComponentSystem?.components)! {
            component.prepareWith(camera: camera)
        }
        
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
            
            // Setup Player State Machine
            (thePlayer as? CharacterNode)?.setUpStateMachine()
            // Setup Player Physics
            (thePlayer as? CharacterNode)?.createPhysics()
        }
        
        // Camera
        if self.childNode(withName: "Camera") != nil {
            theCamera = self.childNode(withName: "Camera") as! SKCameraNode
        }
        self.camera = theCamera
        
        // Set tilemap physics
        if let tilemap = childNode(withName: "ForegroundMap1") as? SKTileMapNode {
            giveTilemapPhysicsBody(map: tilemap)
        }
        if let tilemap = childNode(withName: "ForegroundMap2") as? SKTileMapNode {
            giveTilemapPhysicsBody(map: tilemap)
        }
        
        
        // Physics
        self.physicsWorld.contactDelegate = physicsDelegate
        
        // Add throwPower Bar
        addThrowPowerBar()
        
        // Add UIPanGesture
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragShoot))
        view.addGestureRecognizer(panRecognizer)
    }
    
    // Camera Follow
    func cameraOnNode(node: SKNode) {
        theCamera.run(SKAction.move(to: CGPoint(x: node.position.x, y: node.position.y + 100), duration: 0.5))
    }
    
    override func didFinishUpdate() {
        cameraOnNode(node: thePlayer);
    }
    
    // Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
        
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
        
        // Update parallax background
        parallaxComponentSystem?.update(deltaTime: currentTime)
        
        // Delete bomb if exist too long
        if let bomb = thePlayer.childNode(withName: "bomb") {
            let player = thePlayer as? CharacterNode
            if !(player?.aim)! {
                bombTime += lastUpdateTime
                // 10 second??
                if bombTime >= 60000000 {
                    print(bombTime)
                    bomb.removeFromParent()
                    bombTime = 0
                }
            }
        }
        else {
            bombTime = 0
        }
        
        self.lastUpdateTime = currentTime
    }
    
    // MARK:- Throw Power Bar
    func addThrowPowerBar () {
        powerMeterNode = SKSpriteNode(imageNamed: "barout")
        powerMeterNode?.name = "arrow-power-meter"
        powerMeterNode?.anchorPoint = CGPoint(x: 0.043, y: 0.5)
        powerMeterNode?.size = CGSize(width: 512, height: 43)
//        powerMeterNode?.position = CGPoint(x: 5, y: 7)
        powerMeterNode?.position = CGPoint(x: -self.frame.width/6, y: -self.frame.height/3)
        powerMeterNode?.zPosition = 7
        self.camera?.addChild(powerMeterNode!)
        
        powerMeterFilledNode = SKSpriteNode(imageNamed: "barin")
        powerMeterFilledNode?.name = "arrow-power-meter-filled"
        powerMeterFilledNode?.anchorPoint = CGPoint(x: 0.043, y: 0.5)
        powerMeterFilledNode?.position = CGPoint(x: 8, y: 0)
        powerMeterFilledNode?.size = CGSize(width: 498, height: 28)
        
        powerMeterFilledNode?.zPosition = 8
        powerMeterNode?.addChild(powerMeterFilledNode!)
        
        powerMeterFilledNode?.run(SKAction.scaleX(to: 0, duration: 0.387))
    }
    
    func updatePowerBar (translation: CGPoint) {
        if childNode(withName: "Player") != nil {
            let thePlayer = childNode(withName: "Player") as! CharacterNode
            
            let changePower = -translation.x
            let changeAngle = -translation.y
            
            let powerScale = 0.5 * thePlayer.facing
            let angleScale = -150.0
            
            var power = Float(changePower) * Float(powerScale)
            var angle = Float(changeAngle) / Float(angleScale)
            
            power = min(power, 100)
            power = max(power, 0)
            angle = min(angle, .pi/2)
            angle = max(angle, 0)
            
            powerMeterFilledNode?.xScale = CGFloat(power/100.0)
            if let aimline = thePlayer.childNode(withName: "aimLine") {
                aimline.zRotation = CGFloat(angle)
                aimline.xScale = CGFloat(power/200.0)
            }
            
            thePlayer.currentPower = Double(power)
            thePlayer.currentAngle = Double(angle)
        }
    }
    
    // MARK:- Bomb drag and shoot
    @objc func dragShoot (recognizer: UIPanGestureRecognizer) {
        let player = (thePlayer as! CharacterNode)
        
        if player.stateMachine?.currentState is AimState {
            if recognizer.state == UIGestureRecognizer.State.began {
                // do any initialization
            }
            
            if recognizer.state == UIGestureRecognizer.State.changed {
//                let viewLocation = recognizer.translation(in: self.view)
//                print("x: \(viewLocation.x)  y: \(viewLocation.y)")
                // position drag has moved
                let translation = recognizer.translation(in: self.view)
                updatePowerBar(translation: translation)
            }
            
            if recognizer.state == UIGestureRecognizer.State.ended {
                // finish up
                let maxPowerImpluse = 2500.0
                let currentImpluse = maxPowerImpluse * player.currentPower/100.0
                
                let strength = CGVector(dx: Double(player.facing) * currentImpluse * cos(player.currentAngle), dy: currentImpluse * sin(player.currentAngle))
                
                // Throw Bomb
                player.throwBomb(strength: strength)
                
                // Return powerBar to zero
                let pause = SKAction.wait(forDuration: 0.5)
                let zeroOut = SKAction.scaleX(to: 0, duration: 0.387)
                powerMeterFilledNode?.run(SKAction.sequence([pause, zeroOut]))
                let rotate = SKAction.rotate(toAngle: 0, duration: 0.387)
                powerMeterNode?.run(rotate)
            }
        }
    }
    
    // MARK:- Tile Map Physics
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
                            
                            // Floor
                            if isEdgeTile == 1 {
//                                print("Floor")
                                tileNode.physicsBody?.restitution = 0.0
                                tileNode.physicsBody?.contactTestBitMask = ColliderType.PLAYER
                                tileNode.physicsBody?.categoryBitMask = ColliderType.GROUND
                            }
                            // Wall
                            else if isEdgeTile == 2{
//                                print("Wall")
                                tileNode.physicsBody?.restitution = 0.0
                                tileNode.physicsBody?.categoryBitMask = ColliderType.WALL
                                tileNode.physicsBody?.contactTestBitMask = ColliderType.PLAYER
                            }
                            else {
//                                print("Not set")
                                tileNode.physicsBody?.categoryBitMask = ColliderType.GROUND
                            }
                            
                            tileMap.addChild(tileNode)
                        }
                    }
                }
            }
        }
    
}
