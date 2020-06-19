import SpriteKit

class TouchControlInputNode: SKSpriteNode {
    
    // 1:this two varaible are used to show the transperancy of the button
    var alphaUnpressed: CGFloat = 0.5
    var alphaPressed: CGFloat = 0.9
    
    // 2:declear an array to hold all the buttons you need
    var pressedButtons = [SKSpriteNode]()
    
    let buttonDirUp = SKSpriteNode(imageNamed: "button_up")
    let buttonDirLeft = SKSpriteNode(imageNamed: "button_left")
    let buttonDirDown = SKSpriteNode(imageNamed: "button_down")
    let buttonDirRight = SKSpriteNode(imageNamed: "button_right")
    
    let buttonX = SKSpriteNode(imageNamed: "button_cross")
    let buttonO = SKSpriteNode(imageNamed: "button_circle")
    let buttonT = SKSpriteNode(imageNamed: "button_triangle")
    let buttonS = SKSpriteNode(imageNamed: "button_square")
    
    //7: calling the ControlInputDelegate to receive the buttons
    var inputDelegate: ControlInputDelegate?
    
    //3: creating the rectangle of the size of the screen
    init(frame: CGRect) {
        super.init(texture: nil, color: UIColor.clear, size: frame.size)
        //6: calling the setUp controls
        setUpControls(size: frame.size)
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //5: Method used to add all buttons
    func setUpControls(size: CGSize) {
        addButton(button: buttonDirUp,
                  position: CGPoint(x: -(size.width / 3 ),y: -size.height / 4 + 90),
                  name: "up",
                  scale: 0.2)
        addButton(button: buttonDirLeft,
                  position: CGPoint(x: -(size.width / 3 ) - 90, y: -size.height / 4),
                  name: "left",
                  scale: 0.2)
        addButton(button: buttonDirDown,
                  position: CGPoint(x: -(size.width / 3 ), y: -size.height / 4 - 90),
                  name: "down",
                  scale: 0.2)
        addButton(button: buttonDirRight,
                  position: CGPoint(x: -(size.width / 3 ) + 90, y: -size.height / 4),
                  name: "right",
                  scale: 0.2)
        addButton(button: buttonT,
                  position: CGPoint(x: (size.width / 3 ), y: -size.height / 4 + 90),
                  name: "T",
                  scale: 0.17)
        addButton(button: buttonS,
                  position: CGPoint(x: (size.width / 3 ) - 90, y: -size.height / 4),
                  name: "S",
                  scale: 0.17)
        addButton(button: buttonX,
                  position: CGPoint(x: (size.width / 3 ), y: -size.height / 4 - 90),
                  name: "X",
                  scale: 0.17)
        addButton(button: buttonO,
                  position: CGPoint(x: (size.width / 3 ) + 90, y: -size.height / 4),
                  name: "O",
                  scale: 0.17)
    }
    
    //4: Method used to initialize the buttons
    func addButton(button: SKSpriteNode, position: CGPoint, name: String, scale: CGFloat) {
        button.position = position
        button.setScale(scale)
        button.name = name
        button.zPosition = 10
        button.alpha = alphaUnpressed
        self.addChild(button)
    }
    
    
    //8: Handinling the touch events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: parent!)
            // for all buttons
            for button in [buttonDirUp, buttonDirDown, buttonDirRight, buttonDirLeft, buttonT, buttonS, buttonX, buttonO] {
                // check if a button is already registered in the list and check if a button is not on the list.. like it was just pressed, add it to the list
                if button.contains(location) && pressedButtons.firstIndex(of: button) == nil {
                    pressedButtons.append(button)
                    // Check if the input delegte that is just created is nil
                    if ((inputDelegate) != nil) {
                        inputDelegate?.follow(command: button.name!)
                    }
                }
                // Check if this is new press and change the transperance accordenly
                if (pressedButtons.firstIndex(of: button) == nil) {
                    button.alpha = alphaUnpressed
                } else {
                    button.alpha = alphaPressed
                }
            }
        }
    }
    
    //9:
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: parent!)
            let previousLocation = t.previousLocation(in: parent!)
            
            for button in [buttonDirUp, buttonDirDown, buttonDirRight, buttonDirLeft, buttonT, buttonS, buttonX, buttonO] {
                // if i get off the button where my finger was before
                if button.contains(previousLocation) && !button.contains(location) {
                    // i remove it from the list
                    let index = pressedButtons.firstIndex(of: button)
                    
                    if index != nil {
                        pressedButtons.remove(at: index!)
                        
                        if ((inputDelegate) != nil) {
                            inputDelegate?.follow(command: "cancel \(String(describing: button.name!))")
                        }
                    }
                }// if the button does not contain the previous location, and contains the current location and if it's already in the list
                else if !button.contains(previousLocation) && button.contains(location) && pressedButtons.firstIndex(of: button) == nil {
                    // i add it to the list
                    pressedButtons.append(button)
                    
                    if ((inputDelegate) != nil) {
                        inputDelegate?.follow(command: button.name!)
                    }
                }
                if (pressedButtons.firstIndex(of: button) == nil){
                    button.alpha = alphaUnpressed
                } else {
                    button.alpha = alphaPressed
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchUp(touches: touches, withEvent: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchUp(touches: touches, withEvent: event)
    }
    
    // 10:
    func touchUp(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        for touch in touches! {
            let location = touch.location(in: parent!)
            let previousLocation = touch.previousLocation(in: parent!)
            
            for button in [buttonDirUp, buttonDirDown, buttonDirRight, buttonDirLeft, buttonT, buttonS, buttonX, buttonO] {
                if button.contains(location) || button.contains(previousLocation) {
                    let index = pressedButtons.firstIndex(of: button)
                    if index != nil {
                        pressedButtons.remove(at: index!)
                        if ((inputDelegate) != nil) {
                            inputDelegate?.follow(command: "stop \(String(describing: button.name!))")
                        }
                    }
                }
                if pressedButtons.firstIndex(of: button) == nil {
                    button.alpha = alphaUnpressed
                }
                else {
                    button.alpha = alphaPressed
                }
            }
        }
    }
}

// Recevies the buttons and redirect them as needed when they are pressed
protocol ControlInputDelegate:class {
    func follow(command: String?)
}
