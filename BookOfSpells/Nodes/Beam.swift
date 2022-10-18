//
//  Platform.swift
//  BookOfSpells
//
//  Created by Valados on 26.07.2022.
//

import SpriteKit

enum BeamPattern {
    case narrow, wide, normal
}

class Beam: SKSpriteNode {
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        zPosition = 100
        name = "beam"
        
        self.physicsBody = .init(rectangleOf: .init(width: size.width,
                                                    height: size.height * 0.05),
                                 center: .init(x: 0,
                                               y: -size.height * 0.45))
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = BitmaskCategories.beam
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = BitmaskCategories.ball | BitmaskCategories.anchor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
