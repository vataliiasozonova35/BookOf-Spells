//
//  GameContactDelegate.swift
//  BookOfSpells
//
//  Created by Valados on 26.07.2022.
//

import SpriteKit

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == BitmaskCategories.ball ||  contact.bodyB.categoryBitMask == BitmaskCategories.ball {
            handleBallContact(contact)
        }
        if contact.bodyA.categoryBitMask == BitmaskCategories.anchor ||  contact.bodyB.categoryBitMask == BitmaskCategories.anchor {
            handleAnchorContact(contact)
        }
    }
    
    func handleBallContact(_ contact: SKPhysicsContact) {
        var ballBody: SKPhysicsBody
        var otherBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask == BitmaskCategories.ball {
            ballBody = contact.bodyA
            otherBody = contact.bodyB
        } else {
            ballBody = contact.bodyB
            otherBody = contact.bodyA
        }
        
        switch otherBody.categoryBitMask {
        case BitmaskCategories.beam:
            print("lost")
            if !SoundManager.sharedInstance.isMuted  {
                run(.playSoundFileNamed("lose", waitForCompletion: true))
            }
           
            gameState.enter(GameOver.self)
        case BitmaskCategories.innerArea:
            hud.addBonusPoints(updateStreak: true)
            ball.increaseFireBallSpeed(true)
            guard let portal = otherBody.node?.parent as? Portal else { return }
            portal.removeBonus()
            let emitter = SKEmitterNode(fileNamed: "Portal")!
            emitter.position = portal.position
            emitter.particleTexture = portal.innerArea.texture
            addChild(emitter)
            if !SoundManager.sharedInstance.isMuted  {
                run(.playSoundFileNamed("scored", waitForCompletion: true))
            }
        case BitmaskCategories.outerArea:
            hud.addBonusPoints(updateStreak: false)
            ball.increaseFireBallSpeed(false)
            guard let portal = otherBody.node?.parent as? Portal else { return }
            portal.removeBonus()
            if !SoundManager.sharedInstance.isMuted  {
                run(.playSoundFileNamed("bonus", waitForCompletion: true))
            }
        default:
            break
        }
    }
    
    func handleAnchorContact(_ contact: SKPhysicsContact) {
        var baseBody: SKPhysicsBody
        var otherBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask == BitmaskCategories.anchor {
            baseBody = contact.bodyA
            otherBody = contact.bodyB
        } else {
            baseBody = contact.bodyB
            otherBody = contact.bodyA
        }
        
        switch otherBody.categoryBitMask {
        case BitmaskCategories.beam:
            print("anchored")
            anchor.physicsBody?.isDynamic = false
            anchor.removeAction(forKey: anchor.anchorMoveAction)
            anchor.position.y = otherBody.node!.frame.minY
            anchor.position.x = otherBody.node!.frame.midX
            isContactedBeam = true
        default:
            break
        }
    }
}
