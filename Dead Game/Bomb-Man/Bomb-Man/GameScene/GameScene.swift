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
        
        // Physics
        self.physicsWorld.contactDelegate = physicsDelegate
    }
    
    // Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
        
        // Camera Follow the player
        theCamera.position = thePlayer.position
        
        
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
