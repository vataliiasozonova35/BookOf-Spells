//
//  GameOver.swift
//  HitTheBasket
//
//  Created by Valados on 21.04.2022.
//

import GameplayKit

class GameOver: GKState {
    
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        if previousState is Playing {
//            scene.run(.playSoundFileNamed("lose", waitForCompletion: true))
            let emitter = SKEmitterNode(fileNamed: "BallExplosion")!
            emitter.position = scene.ball.position
            scene.addChild(emitter)
            scene.ball.removeFromParent()
            scene.run(.wait(forDuration: 1.0)) { [weak self] in
                guard let self = self else { return }
                self.scene.gameProtocol?.gameOver(score: self.scene.hud.score, coins: self.scene.hud.coins)
            }
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is WaitingForTap.Type
    }
}
