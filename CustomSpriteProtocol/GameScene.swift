//
//  GameScene.swift
//  CustomSpriteProtocol
//
//  Created by Stephen Brennan on 7/14/16.
//  Copyright (c) 2016 Stephen Brennan. All rights reserved.
//

import SpriteKit

protocol Trap {
    func damage() -> Int;
    func hide()
}

let colors = [ UIColor.redColor(), UIColor.blueColor() ]

class GreenNode : SKSpriteNode, Trap {
    func hide() {
        self.hidden = true
    }
    init() {
        let color = UIColor.greenColor()
        super.init(texture: nil, color: color, size: CGSize(width: 100, height: 100))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func damage() -> Int {
        return 10
    }
}
class BlueNode : SKSpriteNode, Trap {
    func hide() {
        self.color = UIColor.redColor()
    }
    init() {
        let color = UIColor.blueColor()
        super.init(texture: nil, color: color, size: CGSize(width: 100, height: 100))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func damage() -> Int {
        return -10
    }
}
class SceneNode : SKReferenceNode, Trap {
    func hide() {
        self.hidden = true
    }
    init() {
        let path = NSBundle.mainBundle().pathForResource("MyScene", ofType: "sks")
        super.init (URL: NSURL (fileURLWithPath: path!))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func damage() -> Int {
        return -100
    }
}
class GameScene: SKScene {
    
    func generateTrap() -> SKNode {
        let i = random() % 3
        switch(i) {
        case 0:
            return BlueNode()
        case 1:
            return GreenNode()
        default:
            return SceneNode()
        }
    }
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for t in touches {
            let location = t.locationInNode(self)
            var ff : SKNode? = self.nodeAtPoint(location)
            var trap : Trap?
            
            while trap == nil {
                if ff == nil {
                    break
                }
                trap = ff as? Trap
                ff = ff!.parent
            }
            if let found = trap {
                found.hide()
            } else {
                let n = generateTrap()
                n.position = location
                addChild(n)
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
