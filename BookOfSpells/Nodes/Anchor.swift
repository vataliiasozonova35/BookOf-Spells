//
//  Anchor.swift
//  BookOfSpells
//
//  Created by Valados on 26.07.2022.
//

import SpriteKit

class Anchor: SKSpriteNode {
    
    let anchorMoveAction = "anchorMoveAction"
    private let fireBallEffect = SKEmitterNode(fileNamed: "FireBall")!
    let trailNode = SKNode()
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        zPosition = 1000
        name = "anchor"
        self.physicsBody = .init(rectangleOf: size)
        self.physicsBody?.categoryBitMask = BitmaskCategories.anchor
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = BitmaskCategories.beam
    
        addFireBall()
    }
    
    public func addFireBall() {
        trailNode.zPosition = -50
        self.addChild(trailNode)
        fireBallEffect.targetNode = trailNode
        fireBallEffect.position.x += 5
        fireBallEffect.particleLifetime = 0.5
        fireBallEffect.particleSpeed = 1
        self.addChild(fireBallEffect)
    }
    
    func moveToBeam(pos: CGPoint){
        run(.move(to: pos, duration: 0.25),withKey: anchorMoveAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
