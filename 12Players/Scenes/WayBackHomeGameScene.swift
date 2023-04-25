//
//  WayBackHomeGameScene.swift
//  12Players
//
//  Created by Lê Thị Minh Thảo on 31/01/2023.
//

import SpriteKit

struct WbhPhysicsCategory {
    static let girl1: UInt32 = 0x1 << 0
    static let girl2: UInt32 = 0x1 << 1
    static let brick: UInt32 = 0x1 << 2
    static let gem1: UInt32 = 0x1 << 3
    static let gem2: UInt32 = 0x1 << 4
}

class WayBackHomeGameScene: ParentScene, SKPhysicsContactDelegate {
    enum BrickLevel: CGFloat {
        case low = 0.0
        case high = 100.0
    }
    enum GameState {
        case running
        case pause
    }
    var bricks = [SKSpriteNode]()
    var gems = [SKSpriteNode]()
    var brickSize = CGSize.zero
    var brickLevel = BrickLevel.low
    var gameState = GameState.pause
    let startingScrollSpeed: CGFloat = 5.0
    var scrollSpeed: CGFloat = 5.0
    let gravitySpeed: CGFloat = 1.5
    var lastUpdateTime: TimeInterval?
    let girl1 = Girl(imageNamed: "wbh.girl")
    let girl2 = Girl(imageNamed: "wbh.girl")
    var girl1Death = false
    var girl2Death = false
    let score1stLabel = SKLabelNode(fontNamed: "Arial")
    let score2ndLabel = SKLabelNode(fontNamed: "Arial")
    var score1st = 0 {
        didSet {
            score1stLabel.text = "Player1: \(score1st)"
        }
    }
    var score2nd = 0 {
        didSet {
            score2ndLabel.text = "Player2: \(score2nd)"
        }
    }
    
    func createGirl1Score() {
        score1stLabel.fontSize = 24
        score1stLabel.position = CGPoint(x: 40, y: 40)
        score1stLabel.horizontalAlignmentMode = .left
        score1stLabel.text = "Player1: \(score1st)"
        score1stLabel.fontColor = UIColor.black
        score1stLabel.zRotation = .pi * 0.5
        score1stLabel.zPosition = 10
        addChild(score1stLabel)
    }
    func createGirl2Score() {
        score2ndLabel.fontSize = 24
        score2ndLabel.position = CGPoint(x: 40, y: frame.maxY - 40)
        score2ndLabel.horizontalAlignmentMode = .right
        score2ndLabel.text = "Player2: \(score2nd)"
        score2ndLabel.fontColor = UIColor.black
        score2ndLabel.zRotation = .pi * 0.5
        score2ndLabel.zPosition = 10
        addChild(score2ndLabel)
    }
    
    override func didMove(to view: SKView) {
//        AppUtility.lockOrientation(.landscapeRight)
        self.scene?.isPaused = false
        // checking if scene persists
        guard sceneShare.wayBackHomeGameScene == nil else { return }
        physicsWorld.gravity = CGVector(dx: 9.0, dy: 0.0)
        physicsWorld.contactDelegate = self
        anchorPoint = CGPoint.zero
        let background = SKSpriteNode(imageNamed: "wbh.background")
        let xMid = frame.midX
        let yMid = frame.midY
        
        background.position = CGPoint(x: xMid, y: yMid)
        background.size = frame.size
        addChild(background)
        
        createPauseButton()
        
        switch numberPlayer {
        case .OnePlayer:
            createGirl1Score()
            girl1.setupPhysicsBodyGirl1()
            girl1.position = CGPoint(x:xMid, y:yMid - 80)
            girl1.physicsBody?.isDynamic = false
            addChild(girl1)
        case .TwoPlayer:
            createGirl1Score()
            createGirl2Score()
            girl1.setupPhysicsBodyGirl1()
            girl1.position = CGPoint(x:xMid, y:yMid - 80)
            girl1.physicsBody?.isDynamic = false
            addChild(girl1)
            girl2.setupPhysicsBodyGirl2()
            girl2.position = CGPoint(x:xMid, y:yMid + 80)
            girl2.physicsBody?.isDynamic = false
            addChild(girl2)
        }

        // Get label node from scene and store it for use later
        
        let startLabel = SKLabelNode(fontNamed: "Arial")
        startLabel.name = "Start Label"
        startLabel.text = "Click to play!"
        startLabel.fontColor = UIColor.black
        startLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        startLabel.zPosition = 10
        startLabel.zRotation = .pi * 0.5
        addChild(startLabel)
        
    }
    func createPauseButton() {
        let pause = SKSpriteNode(imageNamed: "pause")
        pause.size = CGSize(width: frame.width * 0.05, height: frame.height * 0.05)
        pause.position = CGPoint(x: frame.minX + pause.size.width * 0.5, y: frame.midY)
        pause.zPosition = 10
        pause.name = "pause"
        addChild(pause)
    }
    func resetGirl1() {
        
        let girlX = frame.width - girl1.frame.width * 0.5 - 60.0
        let girlY = frame.midY * 0.5 - girl1.frame.height * 0.5
        girl1.position = CGPoint(x:girlX, y:girlY)
        girl1.physicsBody?.isDynamic = true
        girl1.zPosition = 10
        girl1.physicsBody?.velocity = .zero
//        girl1.physicsBody?.angularVelocity = 0.0
        girl1.setScale(screenScale)
    }
    
    func resetGirl2() {
        
        let girlX = frame.width - girl2.frame.width * 0.5 - 60.0
        let girlY = frame.midY * 0.5 + girl2.frame.height * 0.5
        girl2.position = CGPoint(x:girlX, y:girlY)
        girl2.physicsBody?.isDynamic = true
        girl2.zPosition = 10
        girl2.physicsBody?.velocity = .zero
//        girl2.physicsBody?.angularVelocity = 0.0
        girl2.setScale(screenScale)
    }
    

    func startGame() {
       
        gameState = .running
        switch numberPlayer {
        case .OnePlayer:
            resetGirl1()
        case .TwoPlayer:
            resetGirl1()
            resetGirl2()
        }

        scrollSpeed = startingScrollSpeed
        brickLevel = .low
        lastUpdateTime = nil
        for brick in bricks {
            brick.removeFromParent()
        }
        bricks.removeAll(keepingCapacity: true)
        for gem in gems {
            removeGem(gem)
        }
    }
    func gameOver() {
        self.removeAllChildren()
        let gameOverScene = GameOverScene(size: self.size)
        gameOverScene.numberPlayer = numberPlayer
        gameOverScene.scaleMode = .aspectFill
        gameOverScene.gameName = .WayBackHome
        gameOverScene.pScore1st = score1st
        gameOverScene.pScore2nd = score2nd
        let transition = SKTransition.crossFade(withDuration: 1.0)
        self.scene!.view?.presentScene(gameOverScene, transition: transition)
    }
    func spawnBrick (atPosition position: CGPoint) -> SKSpriteNode {
        let brick = SKSpriteNode(imageNamed: "wbh.sidewalk")
        brick.position = position
        brick.zPosition = 8
        addChild(brick)
        brick.setScale(screenScale)
        brickSize = CGSize(width: brick.size.width * screenScale, height: brick.size.height * screenScale)
        bricks.append(brick)
        let center = brick.centerRect.origin
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size, center: center)
        brick.physicsBody?.affectedByGravity = false
        brick.physicsBody?.categoryBitMask = WbhPhysicsCategory.brick
        brick.physicsBody?.collisionBitMask = 0
        return brick
        
    }
    func spawnGem1 (atPosition position: CGPoint) {
        let gem = SKSpriteNode(imageNamed: "wbh.gem")
        gem.position.x = position.x
        gem.position.y = position.y - gem.size.height * 0.6
        gem.zPosition = 9
        addChild(gem)
        gem.physicsBody = SKPhysicsBody(rectangleOf: gem.size, center: gem.centerRect.origin)
        gem.physicsBody?.categoryBitMask = WbhPhysicsCategory.gem1
        gem.physicsBody?.collisionBitMask = 0
        gem.physicsBody?.affectedByGravity = false
        gems.append(gem)
    }
    func spawnGem2 (atPosition position: CGPoint) {
        let gem = SKSpriteNode(imageNamed: "wbh.gem")
        gem.position.x = position.x
        gem.position.y = position.y + gem.size.height * 0.6
        gem.zPosition = 9
        addChild(gem)
        gem.physicsBody = SKPhysicsBody(rectangleOf: gem.size, center: gem.centerRect.origin)
        gem.physicsBody?.categoryBitMask = WbhPhysicsCategory.gem2
        gem.physicsBody?.collisionBitMask = 0
        gem.physicsBody?.affectedByGravity = false
        gems.append(gem)
    }
    func removeGem(_ gem: SKSpriteNode) {
        gem.removeFromParent()
        if let gemIndex = gems.firstIndex(of: gem) {
            gems.remove(at: gemIndex)
        }
    }
    
    ///////////////////////////////////////
   
    func updateBricks(withScrollAmount currentScrollAmount: CGFloat) {
    
        var farthestRightBrickY: CGFloat = 0.0
        
        for brick in bricks {
            let newY = brick.position.y - currentScrollAmount
            if newY < -brickSize.height {
                brick.removeFromParent()
                if let brickIndex = bricks.firstIndex(of:brick) {
                    bricks.remove(at: brickIndex)
                }
            } else {
                brick.position = CGPoint(x: brick.position.x, y: newY)
                if brick.position.y > farthestRightBrickY  {
                    farthestRightBrickY = brick.position.y
                }
            }
        }
        
        while farthestRightBrickY < frame.height {
            var brickY = farthestRightBrickY + brickSize.height + 1.0
            let brickX = frame.width - (brickSize.width / 2.0) - brickLevel.rawValue
            

            let randomNumber = arc4random_uniform(99)
            if randomNumber < 5 {
                let gap = 20.0 * scrollSpeed
                brickY += gap
                let randomGemXAmount = CGFloat(arc4random_uniform(150))
                let newGemX = brickX - girl1.size.width - randomGemXAmount
                let newGemY = brickY - gap / 2.0
                switch numberPlayer {
                case .OnePlayer:
                    spawnGem1(atPosition: CGPoint(x: newGemX, y: newGemY))
                case .TwoPlayer:
                    spawnGem1(atPosition: CGPoint(x: newGemX, y: newGemY))
                    spawnGem2(atPosition: CGPoint(x: newGemX, y: newGemY))
                }
            }
            
            else  if randomNumber < 7 {
                if brickLevel == .high {
                    brickLevel = .low
                }
                else if brickLevel == .low {
                    brickLevel = .high
                }
            }
            
            

            let newBrick = spawnBrick(atPosition: CGPoint(x: brickX, y: brickY))
                farthestRightBrickY = newBrick.position.y
            }
            
        }
        func updateGems(withScrollAmount currentScrollAmount: CGFloat) {
            for gem in gems {
                let thisGemY = gem.position.y - currentScrollAmount
                gem.position = CGPoint(x:gem.position.x, y: thisGemY)
                if gem.position.y < 0.0 {
                    removeGem(gem)
                }
            }
        }
    //////////////////
        func updateBricksWithoutRandom(withScrollAmount currentScrollAmount: CGFloat) {
         
        
            var farthestRightBrickY: CGFloat = 0.0
            
            for brick in bricks {
                let newY = brick.position.y - currentScrollAmount
                if newY < -brickSize.height {
                    brick.removeFromParent()
                    if let brickIndex = bricks.firstIndex(of:brick) {
                        bricks.remove(at: brickIndex)
                    }
                } else {
                    brick.position = CGPoint(x: brick.position.x, y: newY)
                    if brick.position.y > farthestRightBrickY  {
                        farthestRightBrickY = brick.position.y
                    }
                }
            }
            
            while farthestRightBrickY < frame.height {
                let brickY = farthestRightBrickY + brickSize.height + 1.0
                let brickX = frame.width - (brickSize.width / 2.0) - brickLevel.rawValue
                

                

                let newBrick = spawnBrick(atPosition: CGPoint(x: brickX, y: brickY))
                farthestRightBrickY = newBrick.position.y
                }
                
            }
    
    ////////////////////////////////////////////////////////
    func updateGirl1() {
    /* if !girl.isOnGround {
        let velocityY = girl.velocity.y - gravitySpeed
        girl.velocity = CGPoint(x: girl.velocity.x, y:velocityY)
        let newGirlY: CGFloat = girl.position.y + girl.velocity.y
        girl.position = CGPoint(x: girl.position.x, y: newGirlY)
        
        if girl.position.y < girl.minimumY {
            girl.position.y = girl.minimumY
            girl.velocity = CGPoint.zero
            girl.isOnGround = true
        } */
        if let velocityX = girl1.physicsBody?.velocity.dx {
            if velocityX < -100 || velocityX > 100 {
                girl1.isOnGround = false
            }
        }
        let isOffScreen = girl1.position.x > frame.maxX || girl1.position.y < 0.0
        let maxRotation = CGFloat(GLKMathDegreesToRadians(75.0))
        let isTippedOver = girl1.zRotation > maxRotation || girl1.zRotation < -maxRotation
        
        if isOffScreen || isTippedOver {
            girl1Death = true
            girl1.removeFromParent()
            if numberPlayer == .OnePlayer {
                gameOver()
            } else if girl1Death && girl2Death {
                gameOver()
            }
        }
    }
    
    func updateGirl2() {
    /* if !girl.isOnGround {
        let velocityY = girl.velocity.y - gravitySpeed
        girl.velocity = CGPoint(x: girl.velocity.x, y:velocityY)
        let newGirlY: CGFloat = girl.position.y + girl.velocity.y
        girl.position = CGPoint(x: girl.position.x, y: newGirlY)
        
        if girl.position.y < girl.minimumY {
            girl.position.y = girl.minimumY
            girl.velocity = CGPoint.zero
            girl.isOnGround = true
        } */
        if let velocityX = girl2.physicsBody?.velocity.dx {
            if velocityX < -100 || velocityX > 100 {
                girl2.isOnGround = false
            }
        }
        let isOffScreen = girl2.position.x > frame.maxX || girl2.position.y < 0.0
        let maxRotation = CGFloat(GLKMathDegreesToRadians(75.0))
        let isTippedOver = girl2.zRotation > maxRotation || girl2.zRotation < -maxRotation
        
        if isOffScreen || isTippedOver {
            girl2Death = true
            girl2.removeFromParent()
            if girl1Death && girl2Death {
                gameOver()
            }
        }
    }
    
    
        // Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
        if gameState != .running {
            return
        }
        if scrollSpeed == 5.0 {
            updateBricksWithoutRandom(withScrollAmount: scrollSpeed)
            switch numberPlayer {
            case .OnePlayer:
                updateGirl1()
            case .TwoPlayer:
                updateGirl1()
                updateGirl2()
            }
            updateGems(withScrollAmount: scrollSpeed)
        } else {
            updateBricks(withScrollAmount: scrollSpeed)
            switch numberPlayer {
            case .OnePlayer:
                updateGirl1()
            case .TwoPlayer:
                updateGirl1()
                updateGirl2()
            }
            updateGems(withScrollAmount: scrollSpeed)
        }
        scrollSpeed += 0.001
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        if node.name == "pause" {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let pauseScene = PauseScene(size: self.size)
            pauseScene.sceneShare.wayBackHomeGameScene = self
            pauseScene.gameName = .WayBackHome
            pauseScene.scaleMode = .aspectFill
            self.scene?.isPaused = true
            self.scene!.view?.presentScene(pauseScene, transition: transition)
        }
        switch numberPlayer {
        case .OnePlayer:
            if gameState == .running {
               for touch in touches {
                   let location = touch.location(in: self)
                   if location.y < frame.midY && girl1.isOnGround {
                       girl1.physicsBody?.velocity = .zero
                       girl1.physicsBody?.applyImpulse(CGVector(dx: -260.0, dy: 0))
                       run(SKAction.playSoundFileNamed("wbh.jump.mp3", waitForCompletion: false))
                   }
               }
                
            } else {
                if let startLabel: SKLabelNode = childNode(withName: "Start Label") as? SKLabelNode {
                    startLabel.removeFromParent()
                }
                startGame()
            }
        case .TwoPlayer:
            if gameState == .running {
               for touch in touches {
                   let location = touch.location(in: self)
                   if location.y < frame.midY && girl1.isOnGround {
                       girl1.physicsBody?.velocity = .zero
                       girl1.physicsBody?.applyImpulse(CGVector(dx: -260.0, dy: 0))
                       run(SKAction.playSoundFileNamed("wbh.jump.mp3", waitForCompletion: false))
                   }
                   if location.y > frame.midY && girl2.isOnGround {
                       girl2.physicsBody?.velocity = .zero
                       girl2.physicsBody?.applyImpulse(CGVector(dx: -260.0, dy: 0))
                       run(SKAction.playSoundFileNamed("wbh.jump.mp3", waitForCompletion: false))
                   }
               }
                
            } else {
                if let startLabel: SKLabelNode = childNode(withName: "Start Label") as? SKLabelNode {
                    startLabel.removeFromParent()
                }
                startGame()
            }
        }
    }
    

    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == WbhPhysicsCategory.girl1  && contact.bodyB.categoryBitMask == WbhPhysicsCategory.brick {
            if let velocityX = girl1.physicsBody?.velocity.dx {
                if !girl1.isOnGround && velocityX < 100.0 {
                    girl1.createSparks()
                }
            }
            girl1.isOnGround = true
        } else if contact.bodyA.categoryBitMask == WbhPhysicsCategory.girl1  && contact.bodyB.categoryBitMask == WbhPhysicsCategory.gem1 {
            if let gem = contact.bodyB.node as? SKSpriteNode {
                removeGem(gem)
                score1st += 50
                run(SKAction.playSoundFileNamed("wbh.gem.mp3", waitForCompletion: false))
            }
        } else if contact.bodyA.categoryBitMask == WbhPhysicsCategory.girl2  && contact.bodyB.categoryBitMask == WbhPhysicsCategory.brick {
            if let velocityX = girl2.physicsBody?.velocity.dx {
                if !girl2.isOnGround && velocityX < 100.0 {
                    girl2.createSparks()
                }
            }
            girl2.isOnGround = true
        } else if contact.bodyA.categoryBitMask == WbhPhysicsCategory.girl2  && contact.bodyB.categoryBitMask == WbhPhysicsCategory.gem2 {
            if let gem = contact.bodyB.node as? SKSpriteNode {
                removeGem(gem)
                score2nd += 50
                run(SKAction.playSoundFileNamed("wbh.gem.mp3", waitForCompletion: false))
            }
        }
        
    }
    

}

