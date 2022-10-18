//
//  Playing.swift
//  HitTheBasket
//
//  Created by Valados on 15.04.2022.
//
import GameplayKit

class Playing: GKState {
    
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        if previousState is WaitingForTap {
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameOver.Type
    }
}
