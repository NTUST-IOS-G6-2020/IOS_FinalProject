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
        // Add GamePlay Control
        self.addGamePad()
        
        // Set up State Machine
        if let player = childNode(withName: "Player") {
            (player as! CharacterNode).setUpStateMachine()
        }
        
    }
    
    func addGamePad() {
        let entity = GKEntity()
        print(entity)
        entity.addComponent(GamePad())
        entity.component(ofType: GamePad.self)?.setupControls(camera: camera!, scene: self)
        entities.append(entity)
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
