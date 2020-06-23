import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    // Turn Base
    var TurnBase : TurnBaseNode?
    // Timer
    var timer:Float = 0.0
    
    // player and camera
    var thePlayer: SKSpriteNode = SKSpriteNode()
    var theCamera: SKCameraNode = SKCameraNode()
    var physicsDelegate = PhysicDetection()
    
    // p1 and p2
    var Player1: SKSpriteNode = SKSpriteNode()
    var Player2: SKSpriteNode = SKSpriteNode()
    var touchControlNode: TouchControlInputNode?
    
    // throw power bar
    var powerMeterNode: SKSpriteNode? = nil
    var powerMeterFilledNode: SKSpriteNode? = nil
    // Check if bomb exist too long
    var bombTime: TimeInterval = 0.0
    // Camer Follow Flag
    var cameraFollowBomb : Bool = false
    var cameraNeedTurn: Bool = false
    
    // 背景捲軸
    var parallaxComponentSystem : GKComponentSystem<ParallaxComponent>?
    // Music
    var Music : SKAudioNode?
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        view?.isMultipleTouchEnabled = true
        addMusic(mp3: "BGM1")
    }
    
    func addMusic (mp3: String) {
        guard let url = Bundle.main.url(forResource: mp3, withExtension: "mp3") else{
            print(mp3, " Not Found")
            return
        }
        Music = SKAudioNode(url: url)
        addChild(Music!)
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
        addNode(name: "Cloud1", layer: 2)
        addNode(name: "Cloud2", layer: 2)
        addNode(name: "Cloud3", layer: 2)
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
        
        // Setup Controllers
        setupComtrollers()
        
        // Player1
        if self.childNode(withName: "P1") != nil {
            Player1 = (self.childNode(withName: "P1") as! SKSpriteNode)
            
            let entity = GKEntity()
            // Set up Player
            let nodeComponent : GKSKNodeComponent = GKSKNodeComponent(node: Player1)
            entity.addComponent(nodeComponent)
            // Add GamePlay Control
            entity.addComponent(GamePad())
            entity.component(ofType: GamePad.self)?.setupControls(camera: camera!, scene: self)
            // Add Animation Component
            entity.addComponent(Animation())
            
            // Set touchInputDelegate default Player1
            touchControlNode?.inputDelegate = entity.component(ofType: GamePad.self)
            
            // Append entity
            entities.append(entity)
            
            // Setup Player State Machine
            (Player1 as? CharacterNode)?.setUpStateMachine()
            // Setup Player Physics
            (Player1 as? CharacterNode)?.createPhysics(categoryBitMask: ColliderType.PLAYER)
            
            thePlayer = Player1
        }
        
        // Player2
        if self.childNode(withName: "P2") != nil {
            Player2 = (self.childNode(withName: "P2") as! SKSpriteNode)
            
            let entity = GKEntity()
            // Set up Player
            let nodeComponent : GKSKNodeComponent = GKSKNodeComponent(node: Player2)
            entity.addComponent(nodeComponent)
            // Add GamePlay Control
            entity.addComponent(GamePad())
            entity.component(ofType: GamePad.self)?.setupControls(camera: camera!, scene: self)
            // Add Animation Component
            entity.addComponent(P2_Animation())
            
            // Append entity
            entities.append(entity)
            
            // Setup Player State Machine
            (Player2 as? CharacterNode)?.setUpStateMachine()
            // Setup Player Physics
            (Player2 as? CharacterNode)?.createPhysics(categoryBitMask: ColliderType.PLAYER2)
            // Makes it face left
            (Player2 as? CharacterNode)?.facing = -1
            (Player2 as? CharacterNode)?.xScale = -1
        }
        
        // Turn Base
        TurnBase = TurnBaseNode(frame: self.frame)
        camera?.addChild(TurnBase!)
        
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
    
    // Setup Controllers
    func setupComtrollers () {
        touchControlNode = TouchControlInputNode(frame: self.frame)
        touchControlNode?.position = CGPoint.zero
        camera!.addChild(touchControlNode!)
    }
    
    // Camera Follow
    func cameraOnNode(node: SKNode) {
        if cameraFollowBomb {
            let facing = (thePlayer as! CharacterNode).facing
            let bombPosition = CGPoint(x: node.position.x * facing + thePlayer.position.x, y: node.position.y + thePlayer.position.y)
            theCamera.run(SKAction.move(to: CGPoint(x: bombPosition.x, y: bombPosition.y + 100), duration: 0.08))
        }
        else {
            theCamera.run(SKAction.move(to: CGPoint(x: node.position.x, y: node.position.y + 100), duration: 0.5))
        }
    }
    
    // Change camera further or closer
    func cameraDistance (scale: CGFloat) {
        theCamera.run(SKAction.scale(to: scale, duration: 0.2))
    }
    
    override func didFinishUpdate() {
        // Update Camera follow bomb
        if let bomb = thePlayer.childNode(withName: "bomb") {
            cameraFollowBomb = true
            cameraOnNode(node: bomb)
        }
        // Camera follow Player
        else {
            if cameraFollowBomb {
                theCamera.run(SKAction.wait(forDuration: 0.787)) {
                    self.cameraFollowBomb = false
                }
            }
            else {
                if cameraNeedTurn {
                    theCamera.run(SKAction.wait(forDuration: 0.787)) {
                        self.cameraNeedTurn = false
                    }
                }
                else {
                    cameraOnNode(node: thePlayer)
                    cameraDistance(scale: 1.2)
                }
            }
        }
    }
    
    // Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // If Player Move then start timer
        if (thePlayer as! CharacterNode).action == ACTION.Move {
            // TurnBase update
            timer += Float((currentTime - self.lastUpdateTime))
            if timer >= 1.0 {
                TurnBase?.update()
                timer = 0
            }
        }
        else if (thePlayer as! CharacterNode).action == ACTION.Shoot {
            TurnBase?.refresh()
        }
        
        // Check if Change Turn
        if TurnBase!.changeTurn {
            TurnBase?.didChangeTurn()
            // Simulate touchConrtoller touchup to stop idiot keep touching node
            touchControlNode?.touchUp(touches: .init(), withEvent: nil)
            // Turn controller
            for entity in self.entities {
                if entity.component(ofType: GKSKNodeComponent.self)?.node == childNode(withName: TurnBase!.turn) {
                    touchControlNode?.inputDelegate = entity.component(ofType: GamePad.self)!
                }
            }
            // Refresh Player Action
            (thePlayer as! CharacterNode).action = ACTION.None
            // Change Player
            if self.childNode(withName: TurnBase!.turn) != nil {
                thePlayer = childNode(withName: TurnBase!.turn) as! SKSpriteNode
            }
            // Camera Follow flag update
            cameraNeedTurn = true
        }
        
        // Update the player's life
        if (Player1 as! CharacterNode).takeDamage || (Player2 as! CharacterNode).takeDamage {
            let p1_life = (Player1 as! CharacterNode).life
            let p2_life = (Player2 as! CharacterNode).life
            TurnBase?.updatePlayerHealth(p1_life: p1_life, p2_life: p2_life)
        }
        // Check if End Game
        if TurnBase?.endGame == true {
//            print("Winner is: ", TurnBaseNode.winner)
            self.run(SKAction.wait(forDuration: 3)) {
                self.view?.presentScene(EndGameScene(), transition: .fade(withDuration: 1))
            }
        }
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        // Update parallax background
        parallaxComponentSystem?.update(deltaTime: currentTime)
        
        // Delete bomb if exist too long
        updateBomb()
        
        self.lastUpdateTime = currentTime
    }
    
    func updateBomb () {
        // Delete bomb if exist too long
        guard let _ = childNode(withName: TurnBase!.turn) else {
            return
        }
        let player = childNode(withName: TurnBase!.turn) as! CharacterNode
        if let bomb = player.childNode(withName: "bomb") {
            if !(player.aim) {
                bombTime += lastUpdateTime
                if bombTime >= 40000000 {
                    print(bombTime)
                    bomb.removeFromParent()
                    bombTime = 0
                }
            }
            else {
                bombTime = 0
            }
        }
        else {
            bombTime = 0
            if (player.aim) && (player.bombReady) {
                player.aim = false
                player.bombReady = false
                player.removeAimLine()
            }
        }
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
        guard let _ = childNode(withName: TurnBase!.turn) else {
            return
        }
        let player = childNode(withName: TurnBase!.turn) as! CharacterNode
        
        let changePower = -translation.x
        let changeAngle = -translation.y
        
        let powerScale = 0.5 * player.facing
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
            // Make camera further
            cameraDistance(scale: 1.9)
        }
        player.currentPower = Double(power)
        player.currentAngle = Double(angle)
        
    }
    
    // MARK:- Bomb drag and shoot
    @objc func dragShoot (recognizer: UIPanGestureRecognizer) {
//        let player = (thePlayer as! CharacterNode)
        
        guard let _ = childNode(withName: TurnBase!.turn) else {
            return
        }
        let player = childNode(withName: TurnBase!.turn) as! CharacterNode
        
        if player.stateMachine?.currentState is AimState {
            if recognizer.state == UIGestureRecognizer.State.began {
                // do any initialization
            }
            
            if recognizer.state == UIGestureRecognizer.State.changed {
                // position drag has moved
                let translation = recognizer.translation(in: self.view)
//                print("x: \(translation.x)  y: \(translation.y)")
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
