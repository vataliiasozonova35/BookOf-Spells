//
//  GameOverViewController.swift
//  Leovegas
//
//  Created by Valados on 22.07.2022.
//

import UIKit

class GameOverViewController: BaseViewController {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var againButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var score: Double = 0
    var coins: Int = 0
    
    weak var gameProtocol: GameProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.numberOfLines = 2
        let result = String(format: "%.1f", score)
        let defaults = UserDefaults.standard
        Shop.shared.coins += coins
        if defaults.double(forKey: HighscoreKey) < score {
            scoreLabel.text = "NEW HIGHSCORE !!!\n Score:\(result)"
            defaults.set(result, forKey: HighscoreKey)
        } else {
            scoreLabel.text = "Highscore: \(defaults.double(forKey: HighscoreKey) )\n Score:\(result)"
        }
        
        againButton.addTarget(self, action: #selector(againButtonTapped(_:)), for: .touchUpInside)
        exitButton.addTarget(self, action: #selector(exitButtonTapped(_:)), for: .touchUpInside)
    }
    
    
    
    @objc func exitButtonTapped(_ sender: Any) {
        navigationController?.viewControllers.remove(at: 1)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func againButtonTapped(_ sender: Any) {
        gameProtocol?.restartGame()
        navigationController?.popViewController(animated: true)
    }
}
