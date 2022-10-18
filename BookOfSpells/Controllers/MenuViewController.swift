//
//  MenuViewController.swift
//  Leovegas
//
//  Created by Valados on 20.07.2022.
//

import UIKit

class MenuViewController: BaseViewController {

    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var shopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        soundButton.addTarget(self, action: #selector(toggleMute(_:)), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)
        shopButton.addTarget(self, action: #selector(shopButtonTapped(_:)), for: .touchUpInside)
        
        if SoundManager.sharedInstance.isMuted {
            soundButton.setBackgroundImage(.init(named: "volume_off"), for: .normal)
        } else {
            soundButton.setBackgroundImage(.init(named: "volume_on"), for: .normal)
            SoundManager.sharedInstance.startPlaying()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scoreLabel.text = "Best:\(UserDefaults.standard.double(forKey: HighscoreKey))"
    }
    
    @objc func playButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let gameVC = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        navigationController?.pushViewController(gameVC, animated: true)
    }
    
    @objc func toggleMute(_ sender: Any) {
        if SoundManager.sharedInstance.toggleMute() {
            soundButton.setBackgroundImage(.init(named: "volume_off"), for: .normal)
        } else {
            soundButton.setBackgroundImage(.init(named: "volume_on"), for: .normal)
        }
    }
    
    @objc func shopButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let gameVC = storyboard.instantiateViewController(withIdentifier: "ShopViewController") as! ShopViewController
        navigationController?.pushViewController(gameVC, animated: true)
    }
}
