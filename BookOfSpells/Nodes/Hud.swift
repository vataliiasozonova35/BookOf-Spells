//
//  File.swift
//  BookOfSpells
//
//  Created by Valados on 29.07.2022.
//

import SpriteKit

class Hud: SKNode {
    
    private var streakNames = [
        "",
        "Nice",
        "Wow",
        "Cool",
        "Super",
        "Awesome",
        "Unbelievable",
        "Godlike"
    ]
    
    let gameFont = "SourceSansPro-Bold"
    
    var score: Double = 0.0
    var coins: Int = 0
    var streak: Int = 0
    var startPositionX: CGFloat
    var scoreLabel: SKLabelNode
    
    init(size: CGSize, startingPositionX: CGFloat) {
        
        scoreLabel = .init(fontNamed: gameFont)
        startPositionX = startingPositionX
        super.init()
        
        scoreLabel.zPosition = 3000
        scoreLabel.text = String(format: "%.1f", score)
        scoreLabel.fontColor = .white
        scoreLabel.fontSize = 50
        scoreLabel.position = .init(x: size.width / 2, y: size.height * 0.8)
        
        addChild(scoreLabel)
    }
    
    func addBonusPoints(updateStreak: Bool) {
        if updateStreak {
            streak += 1
            coins += streak + 2
            var streakTitle: String = ""
            if streak < streakNames.count {
                streakTitle = streakNames[streak]
            }  else {
                streakTitle = streakNames.last!
            }
            increaseScore(value: Double(streak) + 1.0)
            showScoreLabel(text: "+\(streak + 1)", color: .green, title: streakTitle)
        } else {
            streak = 0
            coins += 2
            increaseScore(value: 1.0)
            showScoreLabel(text: "+1", color: .green)
        }
    }
    
    func showScoreLabel(text: String, color: UIColor, title: String? = "") {
        let streakLabel = SKLabelNode(fontNamed: gameFont)
        streakLabel.fontSize = 35
        streakLabel.zPosition = 1500
        streakLabel.text = title
        streakLabel.fontColor = color
        addChild(streakLabel)
        
        streakLabel.position = CGPoint(x: scoreLabel.frame.midX, y: scoreLabel.frame.minY - streakLabel.frame.height * 2.5 )
        
        streakLabel.run(.sequence([
            .scale(to: 2, duration: 0.4),
            .fadeOut(withDuration: 0.3),
            .run({
                streakLabel.removeFromParent()
            })
        ]))
        
        let bonusScoreLabel = SKLabelNode(fontNamed: gameFont)
        bonusScoreLabel.fontSize = 30
        bonusScoreLabel.zPosition = 1500
        bonusScoreLabel.text = text
        bonusScoreLabel.fontColor = .white
        addChild(bonusScoreLabel)
        
        bonusScoreLabel.position = CGPoint(x: scoreLabel.frame.midX, y: scoreLabel.frame.minY - bonusScoreLabel.frame.height * 4.5 )
        
        bonusScoreLabel.run(.sequence([
            .scale(to: 2, duration: 0.4),
            .fadeOut(withDuration: 0.3),
            .run({
                bonusScoreLabel.removeFromParent()
            })
        ]))
    }
    
    func increaseScore(value: Double) {
        score += value
        scoreLabel.text = String(format: "%.1f", score)
    }
    
    func updateScore(ballPosition: CGFloat) {
        if ballPosition > startPositionX + 50 {
            startPositionX += 50
            increaseScore(value: 0.1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
