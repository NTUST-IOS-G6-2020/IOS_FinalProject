import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
    }
    
    override func didMove(to view: SKView) {
        
        if let player = childNode(withName: "Player") as? SKSpriteNode {
            let entity = GKEntity()
            // Set up Player
            let nodeComponent : GKSKNodeComponent = GKSKNodeComponent(node: player)
            entity.addComponent(nodeComponent)
            // Add GamePlay Control
            entity.addComponent(GamePad())
            entity.component(ofType: GamePad.self)?.setupControls(camera: camera!, scene: self)
            entities.append(entity)
            // setup State Machine
            (player as? CharacterNode)?.setUpStateMachine()
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
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
