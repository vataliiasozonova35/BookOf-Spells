//
//  WaitingForTap.swift
//  HitTheBasket
//
//  Created by Valados on 15.04.2022.
//

import GameplayKit

class WaitingForTap: GKState {
    
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        
        
        let infoLabel = SKLabelNode(fontNamed: GameFont)
        infoLabel.horizontalAlignmentMode = .center
        infoLabel.name = "tutorial"
        infoLabel.text = "Tap & hold to swing\nrelease to fly"
        infoLabel.numberOfLines = 5
        infoLabel.fontColor = .white
        infoLabel.fontSize = 30
        infoLabel.zPosition = 3100
        infoLabel.position = .init(x: scene.size.width * 0.5, y: scene.size.height * 0.3)
        scene.addChild(infoLabel)
        
        infoLabel.run(
            .repeatForever(
                .sequence([
                    .fadeAlpha(to: 0.5, duration: 1.5),
                    .fadeAlpha(to: 1, duration: 1.5)
                ])
            )
        )
    }
    
    override func willExit(to nextState: GKState) {
        for child in scene.children {
            if child.name == "tutorial" {
                child.run(.fadeAlpha(to: 0.0, duration: 0.5)) {
                    child.removeFromParent()
                }
            }
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is Playing.Type
    }
}
