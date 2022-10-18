//
//  Ball.swift
//  BookOfSpells
//
//  Created by Valados on 19.07.2022.
//

import SpriteKit

class Ball: SKSpriteNode {
    
    var swingActionKey: String = "swingAction"
    var rope: SKSpriteNode!
    
    let trailNode = SKNode()
    private let trailEffect = SKEmitterNode(fileNamed: "BallTrail_\(Shop.shared.ball)")!
    private let fireBallEffect = SKEmitterNode(fileNamed: "FireBall")!
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        zPosition = 100
        
        physicsBody = .init(circleOfRadius: size.width / 2)
        physicsBody?.categoryBitMask = BitmaskCategories.ball
        physicsBody?.contactTestBitMask = BitmaskCategories.beam | BitmaskCategories.innerArea | BitmaskCategories.outerArea
        physicsBody?.collisionBitMask = 0
        physicsBody?.allowsRotation = true
        
        trailEffect.targetNode = trailNode
        trailEffect.name = "trail"
        trailEffect.yAcceleration = 0
        trailEffect.particlePositionRange = .init(dx: size.width * 0.15, dy: size.height / 3.5)
        addFireBall()
    }
    
    public func addFireBall() {
        trailNode.zPosition = -50
        self.addChild(trailNode)
//        fireBallEffect.targetNode = trailNode
//        self.addChild(fireBallEffect)
        trailEffect.targetNode = trailNode
        self.addChild(trailEffect)
    }
    
    func increaseFireBallSpeed(_ increase:Bool) {
        if increase {
            fireBallEffect.particleSpeed += 2
        } else {
            fireBallEffect.particleSpeed = 20
        }
    }
    
    func addRope(centerOfCircle: CGPoint) {
        let radius = sqrt(pow(centerOfCircle.x - position.x, 2) + pow(centerOfCircle.y - position.y, 2))
        rope = .init(texture: .init(imageNamed: "rope"),
                     color: .clear,
                     size: .init(width: self.size.width * 0.2,
                                 height: radius))
        rope.zPosition = 50
        addChild(rope)
        if !SoundManager.sharedInstance.isMuted  {
            run(.playSoundFileNamed("rope", waitForCompletion: true))
        }
    }
    
    func updateAngle(centerOfCircle: CGPoint?, isAnchored: Bool) {
        
        if isAnchored {
            guard let centerOfCircle = centerOfCircle else {
                return
            }
            let dx = centerOfCircle.x - self.position.x
            let dy = centerOfCircle.y - self.position.y
            let theta_radians = atan2(dy, dx)
            let  angle = theta_radians
            rope.position = .init(x: dx / 2,
                                  y: dy / 2)
            rope.zRotation = angle - .pi / 2
        }
        guard let speed = physicsBody?.velocity else { return }
        trailEffect.xAcceleration = -speed.dx
        trailEffect.yAcceleration = -speed.dy
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
