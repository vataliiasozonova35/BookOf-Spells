//
//  Camera.swift
//  BalanceGame
//
//  Created by Valados on 26.06.2022.
//

import SpriteKit

class Camera: SKCameraNode {
    
    private var destination : CGPoint!
    
    private let easing : CGFloat = 0.6

    public func updatePosition(point: CGPoint) {
        position = point
        destination = point
    }
    
    public func setDestination(destination : CGPoint) {
        self.destination = destination
    }
    
    public func update() {
        let distance = sqrt(pow((destination.x - position.x), 2) + pow((destination.y - position.y), 2))
        
        if(distance > 1) {
            let directionX = (destination.x - position.x)
            let directionY = (destination.y - position.y)
            
            position.x += directionX * easing
            position.y += directionY * easing
        } else {
            position = destination
        }
    }
}
