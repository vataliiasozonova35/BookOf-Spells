//
//  GameViewController.swift
//  RagingBull
//
//  Created by Valados on 11.07.2022.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       startGame()
        
    }
    
    func startGame() {
        let sceneNode: GameScene = GameScene(size: view.frame.size)
        
        sceneNode.scaleMode = .aspectFill
        sceneNode.gameProtocol = self
        
        if let view = self.view as! SKView? {
            view.presentScene(sceneNode)
//            
//            view.showsFPS = true
//            view.showsNodeCount = true
//            view.showsPhysics = true
        }
    }
}
extension GameViewController: GameProtocol {
    func gameOver(score: Double, coins: Int) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let gameOverVC = storyboard.instantiateViewController(withIdentifier: "GameOverViewController") as! GameOverViewController
        gameOverVC.score = score
        gameOverVC.coins = coins
        gameOverVC.gameProtocol = self
        navigationController?.pushViewController(gameOverVC, animated: true)
    }
    
    func restartGame() {
        startGame()
    }
    
    
}
