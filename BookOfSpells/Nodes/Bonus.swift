//
//  BonusNode.swift
//  BookOfSpells
//
//  Created by Valados on 28.07.2022.
//

import SpriteKit

class Portal: SKNode {
    
    var innerArea: SKSpriteNode
//    var leftOuterArea: SKSpriteNode
//    var rightOuterArea: SKSpriteNode
    
    init(size: CGSize) {
        
        let textureName = Shop.shared.portalSkins[Shop.shared.portal].name
        
        innerArea = .init(texture: .init(imageNamed: "\(textureName)"),
                          color: .red,
                          size: .init(width: size.width * 1.5,
                                                   height: size.height / 2))
//        leftOuterArea = .init(texture: .init(imageNamed: "\(textureName)"),
//                              color: .yellow,
//                              size: .init(width: size.width * 0.65,
//                                          height: size.height))
//        rightOuterArea = .init(texture: .init(imageNamed: "\(textureName)"),
//                               color: .yellow,
//                               size: .init(width: size.width * 0.65,
//                                           height: size.height))
        
        
        super.init()
        
        innerArea.zPosition = 150
        innerArea.physicsBody = .init(rectangleOf: innerArea.size)
        innerArea.physicsBody?.isDynamic = false
        innerArea.physicsBody?.categoryBitMask = BitmaskCategories.innerArea
        innerArea.physicsBody?.contactTestBitMask = BitmaskCategories.ball
        
//        leftOuterArea.zPosition = 90
//        leftOuterArea.xScale = -1
//        leftOuterArea.position.x -= leftOuterArea.frame.width * 0.55
//
//        rightOuterArea.zPosition = 210
//        rightOuterArea.physicsBody = .init(rectangleOf: rightOuterArea.size)
//        rightOuterArea.physicsBody?.isDynamic = false
//        rightOuterArea.physicsBody?.categoryBitMask = BitmaskCategories.outerArea
//        rightOuterArea.physicsBody?.contactTestBitMask = BitmaskCategories.ball
//        rightOuterArea.position.x += rightOuterArea.frame.width * 0.55
        
        addChild(innerArea)
//        addChild(leftOuterArea)
//        addChild(rightOuterArea)
    }
    
    func removeBonus() {
        for child in children {
            child.physicsBody = nil
            child.run(
                .sequence([
                    .fadeOut(withDuration: 0.5),
                    .run {
                        child.removeFromParent()
                    }
                ])
            )
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
