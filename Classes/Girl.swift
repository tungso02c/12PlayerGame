//
//  Girl.swift
//  12Players
//
//  Created by Lê Thị Minh Thảo on 31/01/2023.
//

import SpriteKit

class Girl: SKSpriteNode {
    var velocity = CGPoint.zero
//    var minimumX: CGFloat = 0.0
    var jumpSpeed: CGFloat = 20.0
    var isOnGround = true
    func setupPhysicsBodyGirl1() {
        if let girlTexture = texture {
            physicsBody = SKPhysicsBody(texture: girlTexture, size: size)
            physicsBody?.isDynamic = true
            physicsBody?.density = 6.0
            physicsBody?.allowsRotation = false
            physicsBody?.angularDamping = 19.0
            physicsBody?.categoryBitMask = WbhPhysicsCategory.girl1
            physicsBody?.collisionBitMask = WbhPhysicsCategory.brick
            physicsBody?.contactTestBitMask = WbhPhysicsCategory.brick | WbhPhysicsCategory.gem1
        }
    }
    func setupPhysicsBodyGirl2() {
        if let girlTexture = texture {
            physicsBody = SKPhysicsBody(texture: girlTexture, size: size)
            physicsBody?.isDynamic = true
            physicsBody?.density = 6.0
            physicsBody?.allowsRotation = false
            physicsBody?.angularDamping = 19.0
            physicsBody?.categoryBitMask = WbhPhysicsCategory.girl2
            physicsBody?.collisionBitMask = WbhPhysicsCategory.brick
            physicsBody?.contactTestBitMask = WbhPhysicsCategory.brick | WbhPhysicsCategory.gem2
        }
    }
    func createSparks() {
        let particleEmitter = SKEmitterNode(fileNamed: "wbh.sparks")!
        
        particleEmitter.position = CGPoint(x: 50.0, y: 0.0)
        particleEmitter.zRotation = .pi * 0.5
        addChild(particleEmitter)
        let waitAction = SKAction.wait(forDuration: 0.5)
        let removeAction = SKAction.removeFromParent()
        let waitThenRemove = SKAction.sequence([waitAction, removeAction])
        particleEmitter.run(waitThenRemove)
    }
}


