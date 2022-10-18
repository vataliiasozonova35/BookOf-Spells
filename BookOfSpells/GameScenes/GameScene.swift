//
//  GameScene.swift
//  RagingBull
//
//  Created by Valados on 11.07.2022.
//

import SpriteKit
import GameplayKit

protocol GameProtocol: AnyObject {
    func gameOver(score: Double, coins:Int)
    func restartGame()
}

class GameScene: SKScene {
    
    var background: SKSpriteNode!
    var ball: Ball!
    var anchor: Anchor!
    var topBeams: [Beam] = []
    var bottomBeams: [Beam] = []
    var portals: [Portal] = []
    var hud: Hud!
    
    var bonusSpawnInterval: Int {
        return Int.random(in: 10...15)
    }
    
    weak var gameProtocol: GameProtocol?
    
    var emitter: SKEmitterNode!
    
    var limitJoint: SKPhysicsJointLimit!
    var radialField: SKFieldNode!
    
    var gameCamera: Camera = Camera()
    var initialPositionX: CGFloat = 0.0
    var isContactedBeam: Bool = true
    private let shop = Shop.shared
    
    lazy var gameState: GKStateMachine = .init(states: [
        WaitingForTap.init(scene: self),
        Playing.init(scene: self),
        GameOver.init(scene: self)
    ])
    
    var isTouchBegan: Bool = false
    var ballPosition: CGPoint = .zero
    
    override func sceneDidLoad() {
        
        gameState.enter(WaitingForTap.self)
        spawnBall()
        configureCamera()
        addHud()
        spawnBeams(quantity: 50, firstColor: .blue, secondColor: .cyan)
        
     
        
        self.physicsWorld.gravity = .init(dx: 0, dy: -9.8)
        self.physicsWorld.contactDelegate = self
    }
    
    override func didMove(to view: SKView) {
        
        spawnAnchor()
        let possibleBeamPosX = ballPosition.x + frame.width * 0.7
        guard anchor != nil, anchor.action(forKey: anchor.anchorMoveAction) == nil else {
            return
        }
        for topBeam in topBeams {
            if topBeam.contains(.init(x: possibleBeamPosX, y: topBeam.frame.midY)) {
                anchor.moveToBeam(pos:.init(x: topBeam.frame.midX,
                                            y: topBeam.frame.minY + topBeam.frame.height * 0.05))
                break
            }
        }
        run(.wait(forDuration:  0.25)){
            if self.ball.rope == nil {
                self.ball.addRope(centerOfCircle: self.anchor.position)
            }
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState.currentState {
        case is WaitingForTap:
            gameState.enter(Playing.self)
            ball.physicsBody?.isDynamic = true
            isTouchBegan = true
            ballPosition = ball.position
        case is Playing:
            isTouchBegan = true
            spawnAnchor()
            ballPosition = ball.position
        default:
            break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState.currentState {
        case is Playing:
            isTouchBegan = false
            isContactedBeam = false
            ball.removeAllActions()
            ball.physicsBody?.isDynamic = true
            let endpointVelocity = ball.physicsBody!.velocity
            ball.physicsBody?.velocity = .init(dx: endpointVelocity.dx * 0.5, dy: endpointVelocity.dy * 0.5)
            if limitJoint != nil {
                self.physicsWorld.remove(limitJoint)
                limitJoint = nil
            }
            
            if radialField != nil {
                radialField.removeFromParent()
                radialField = nil
            }
            if ball.rope != nil {
                ball.rope.removeFromParent()
                ball.rope =  nil
            }
            anchor.removeFromParent()
            anchor = nil
        default:
            break
        }
        
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        let ballPosX = ball.position.x
        for beam in topBeams {
            if beam.position.x < ballPosX - frame.width * 1.5 {
                topBeams.first?.removeFromParent()
                topBeams.removeFirst()
                bottomBeams.first?.removeFromParent()
                bottomBeams.removeFirst()
            }
        }
        
        if topBeams.count <= 40 {
            spawnBeams(quantity: 50, firstColor: .green, secondColor: .systemGreen)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        switch gameState.currentState {
        case is WaitingForTap:
            if ball.rope != nil {
                ball.updateAngle(centerOfCircle: anchor.position, isAnchored: isContactedBeam)
            }
        case is Playing:
            gameCamera.update()
            hud.updateScore(ballPosition: ball.position.x)
            gameCamera.setDestination(destination: .init(x: ball.position.x + frame.width * 0.3, y: ball.position.y))
            if isTouchBegan, anchor != nil {
                if isContactedBeam {
                    if limitJoint == nil {
                        limitJoint = .joint(withBodyA: ball.physicsBody!, bodyB: anchor.physicsBody!, anchorA: ball.position, anchorB: anchor.position)
                        physicsWorld.add(limitJoint)
                    }
                    if radialField == nil {
                        let radius = sqrt(pow(anchor.position.x - ball.position.x, 2) + pow(anchor.position.y - ball.position.y, 2) )
                        spawnRadialField(at: .init(x: anchor.position.x + radius,
                                                   y: anchor.position.y))
                    }
                    if ball.rope == nil {
                        ball.addRope(centerOfCircle: anchor.position)
                    }
                    ball.updateAngle(centerOfCircle: anchor.position, isAnchored: isContactedBeam)
                } else {
                    ball.updateAngle(centerOfCircle: anchor.position, isAnchored: isContactedBeam)
                    let possibleBeamPosX = ballPosition.x + frame.width * 0.7
                    guard anchor != nil, anchor.action(forKey: anchor.anchorMoveAction) == nil else {
                        return
                    }
                    for topBeam in topBeams {
                        if topBeam.contains(.init(x: possibleBeamPosX, y: topBeam.frame.midY)) {
                            anchor.moveToBeam(pos:.init(x: topBeam.frame.midX,
                                                        y: topBeam.frame.minY + topBeam.frame.height * 0.05))
                            break
                        }
                    }
                }
            } else {
                ball.updateAngle(centerOfCircle:nil, isAnchored: isContactedBeam)
            }
        default:
            break
        }
    }
    
    //MARK: - Adding game objects
    
    func spawnBeams(quantity: Int, firstColor: UIColor, secondColor: UIColor) {
        let bonusInterval = bonusSpawnInterval
        var bonusIndex: Int = 0
        for i in 0...quantity {
            let color: UIColor = i % 2 == 0 ? firstColor : secondColor
            spawnBeams(in: initialPositionX, color: color )
            initialPositionX += size.width * 0.25
            if bonusIndex == bonusInterval {
                bonusIndex = 0
                spawnPortal(topBeam: topBeams.last!, bottomBeam: bottomBeams.last!)
            } else {
                bonusIndex += 1
            }
        }
    }
    
    func addHud() {
        hud = .init(size: frame.size, startingPositionX: ball.position.x)
        hud.zPosition = 1000
        hud.position = .init(x: -size.width / 2, y: -size.height / 2)
        print(hud.position)
        gameCamera.addChild(hud)
    }
    
    func configureCamera() {
        camera = gameCamera
        gameCamera.updatePosition(point: CGPoint(x: frame.midX, y: frame.midY))
        addChild(gameCamera)
        addBackground()
    }
    
    func addBackground() {
        background = .init(texture: .init(imageNamed: "background"), color: .clear, size: frame.size)
        gameCamera.addChild(background)
    }
    
    func spawnAnchor() {
        anchor = .init(texture: nil,
                       color: .clear,
                       size: .init(width: size.width * 0.025, height: size.width * 0.025))
        anchor.position = ball.position
        addChild(anchor)
    }
    
    func spawnBall() {
        ball = .init(texture: .init(imageNamed: shop.ballSkins[shop.ball].name),
                     color: .red,
                     size: .init(width: size.width * 0.12, height: size.width * 0.15))
        ball.position = .init(x: frame.width * 0.2, y: frame.midY)
        ball.physicsBody?.isDynamic = false
        addChild(ball)
    }
    
    func spawnBeams(in positionX: CGFloat, color: UIColor) {
        let beamsArr = ["beam1","beam2","beam3"]
        let topBeam: Beam = .init(texture:.init(imageNamed: beamsArr.randomElement()!),
                                  color: color,
                                  size: .init(width: size.width * 0.55,
                                              height: CGFloat.random(in: frame.size.height * 0.5 ... frame.size.height * 0.7)))
        
        topBeam.position = .init(x: positionX, y:  frame.size.height * 1.3 - topBeam.size.height / 2)
        addChild(topBeam)
        topBeams.append(topBeam)
        
        let bottomBeam: Beam = .init(texture: .init(imageNamed:  beamsArr.randomElement()!),
                                     color: color,
                                     size: .init(width: size.width * 0.65,
                                                 height: CGFloat.random(in: frame.size.height * 0.45 ... frame.size.height * 0.6)))
        bottomBeam.zRotation = .pi
        bottomBeam.position = .init(x: positionX, y:  frame.size.height * -0.4 + bottomBeam.size.height / 2)
        addChild(bottomBeam)
        bottomBeams.append(bottomBeam)
    }
    
    func spawnPortal(topBeam: Beam, bottomBeam: Beam) {
        let portal: Portal = .init(size: .init(width: frame.width * 0.1,
                                               height:  frame.height * 0.2))
        portal.position = .init(x: topBeam.frame.midX, y: topBeam.frame.minY -  (topBeam.frame.minY - bottomBeam.frame.maxY) / 2)
        
        addChild(portal)
    }
    
    func spawnRadialField(at point: CGPoint) {
        radialField = .radialGravityField()
        radialField.position = point
        radialField.strength = 10
        radialField.falloff = 0.1
        addChild(radialField)
    }
}
