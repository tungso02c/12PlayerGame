//
//  CrashPlaneGameScene.swift
//  12Players
//
//  Created by Lê Thị Minh Thảo on 31/01/2023.
//

import SpriteKit


class CrashPlaneGameScene: ParentScene, SKPhysicsContactDelegate {
    enum CrashPlaneGameState {
        case Logo
        case Playing
        case Dead
    }
    var gameState = CrashPlaneGameState.Logo
    var logo: SKSpriteNode!
    var player1st: SKSpriteNode!
    var player2nd: SKSpriteNode!
    var backGroundMusic: SKAudioNode!
    var player1stDeath = false
    var player2ndDeath = false
    var score1stLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
    var score2ndLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
    var score1st = 0 {
        didSet {
            if score1stLabel.parent == self {
                score1stLabel.text = "Player1: \(score1st)"
            }
        }
    }
    var score2nd = 0 {
        didSet {
            if score2ndLabel.parent == self {
                score2ndLabel.text = "Player2: \(score2nd)"
            }
        }
    }
    override func didMove(to view: SKView) {
        self.scene?.isPaused = false
        // checking if scene persists
        guard sceneShare.crashPlaneGameScene == nil else { return }
        createCrashPlaneLayout()
    }
    func createCrashPlaneRock() {
        // 1
        let topRockTexture = SKTexture(imageNamed: "cp.top.rock")
        let bottomRockTexture = SKTexture(imageNamed: "cp.bottom.rock")

        let topRock = SKSpriteNode(texture: topRockTexture)
        topRock.physicsBody = SKPhysicsBody(texture: topRockTexture, size: topRockTexture.size())
        topRock.physicsBody?.isDynamic = false
        topRock.zPosition = -20
        topRock.setScale(screenScale)
        
        let bottomRock = SKSpriteNode(texture: bottomRockTexture)
        bottomRock.physicsBody = SKPhysicsBody(texture: bottomRockTexture, size: bottomRockTexture.size())
        bottomRock.physicsBody?.isDynamic = false
        bottomRock.zPosition = -20
        bottomRock.setScale(screenScale)

        // 2
        let rockCollision1st = SKSpriteNode(color: .clear, size: CGSize(width: frame.width, height: 32))
        rockCollision1st.physicsBody = SKPhysicsBody(rectangleOf: rockCollision1st.size)
        rockCollision1st.physicsBody?.isDynamic = false
        rockCollision1st.name = "scoreDetect1st"
        
        let rockCollision2nd = SKSpriteNode(color: .clear, size: CGSize(width: frame.width, height: 32))
        rockCollision2nd.physicsBody = SKPhysicsBody(rectangleOf: rockCollision2nd.size)
        rockCollision2nd.physicsBody?.isDynamic = false
        rockCollision2nd.name = "scoreDetect2nd"

        addChild(topRock)
        addChild(bottomRock)
        addChild(rockCollision1st)
        addChild(rockCollision2nd)


        // 3
        let yPosition = frame.height + (topRock.frame.height + bottomRock.frame.height) * 0.5

        let xPosition = CGFloat.random(in: -50...frame.width * 0.33)

        
        let rockDistance: CGFloat = frame.width * 0.15

       // 4
        topRock.position = CGPoint(x: xPosition - rockDistance, y: yPosition )
        bottomRock.position = CGPoint(x: xPosition + (topRock.size.width + bottomRock.size.width) * 0.5 + rockDistance, y: yPosition - bottomRock.frame.height * 0.25 )
        rockCollision1st.position = CGPoint(x: frame.midX, y: yPosition - rockCollision1st.frame.height * 0.5)
        rockCollision2nd.position = CGPoint(x: frame.midX, y: yPosition + rockCollision1st.frame.height * 0.5)

        let endPosition = frame.height + (topRock.frame.height + bottomRock.frame.height)

        let moveAction = SKAction.moveBy(x: 0 , y: -endPosition, duration: 6.2)
        let moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
        topRock.run(moveSequence)
        bottomRock.run(moveSequence)
        rockCollision1st.run(moveSequence)
        rockCollision2nd.run(moveSequence)
    }
    func createPauseButton() {
        let pause = SKSpriteNode(imageNamed: "pause")
        pause.size = CGSize(width: frame.width * 0.05, height: frame.height * 0.05)
        pause.position = CGPoint(x: frame.minX + pause.size.width * 0.5, y: frame.midY)
        pause.zPosition = 10
        pause.name = "pause"
        addChild(pause)
    }
    func startCrashPlaneRocks() {
        let create = SKAction.run { [unowned self] in
            self.createCrashPlaneRock()
        }

        let wait = SKAction.wait(forDuration: 3)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatForever(sequence)

        run(repeatForever)
    }
    func createCrashPlane1stPlayer() {
        let player1stTexture = SKTexture(imageNamed: "cp.player-1")
        player1st = SKSpriteNode(texture: player1stTexture)
        player1st.zPosition = 10
        player1st.position = CGPoint(x: frame.maxX * 0.4, y: frame.maxY * 0.25)
        player1st.name = "player1st"
        addChild(player1st)
        player1st.setScale(screenScale)
        player1st.physicsBody = SKPhysicsBody(texture: player1stTexture, size: player1stTexture.size())
        player1st.physicsBody!.contactTestBitMask = player1st.physicsBody!.collisionBitMask
        player1st.physicsBody?.isDynamic = false

        player1st.physicsBody?.collisionBitMask = 0

        let frame2 = SKTexture(imageNamed: "cp.player-2")
        let frame3 = SKTexture(imageNamed: "cp.player-3")
        let animation = SKAction.animate(with: [player1stTexture, frame2, frame3, frame2], timePerFrame: 0.01)
        let runForever = SKAction.repeatForever(animation)

        player1st.run(runForever)
        
    }
    func createCrashPlane2ndPlayer() {
        let player2ndTexture = SKTexture(imageNamed: "cp.player-1")
        player2nd = SKSpriteNode(texture: player2ndTexture)
        player2nd.zPosition = 10
        player2nd.position.x = player1st.position.x
        player2nd.position.y = player1st.position.y + 100
        player2nd.name = "player2nd"
        addChild(player2nd)
        player2nd.setScale(screenScale)
        player2nd.physicsBody = SKPhysicsBody(texture: player2ndTexture, size: player2ndTexture.size())
        player2nd.physicsBody!.contactTestBitMask = player2nd.physicsBody!.collisionBitMask
        player2nd.physicsBody?.isDynamic = false

        player2nd.physicsBody?.collisionBitMask = 0

        let frame2 = SKTexture(imageNamed: "cp.player-2")
        let frame3 = SKTexture(imageNamed: "cp.player-3")
        let animation = SKAction.animate(with: [player2ndTexture, frame2, frame3, frame2], timePerFrame: 0.01)
        let runForever = SKAction.repeatForever(animation)

        player2nd.run(runForever)
        
    }
    

    func createCrashPlaneLayout() {
        
        createCrashPlaneSky()
        createCrashPlaneBackground()
        createCrashPlaneGround()
        createCrashPlaneLogos()
        createPauseButton()
        switch numberPlayer {
        case .OnePlayer :
            createPlayer1stScore()
            createCrashPlane1stPlayer()
        case .TwoPlayer :
            createPlayer1stScore()
            createPlayer2ndScore()
            createCrashPlane1stPlayer()
            createCrashPlane2ndPlayer()
        }
        physicsWorld.gravity = CGVector(dx: 5.0, dy: 0)
        physicsWorld.contactDelegate = self
        
        playM4aFile()
    }
    func playM4aFile() {
        if let musicURL = Bundle.main.url(forResource: "cp.music", withExtension: "m4a") {
            backGroundMusic = SKAudioNode(url: musicURL)
            addChild(backGroundMusic)
        }
    }
    
    func createCrashPlaneSky() {
        let topSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.14, brightness: 0.97, alpha: 1), size: CGSize(width: frame.width, height: frame.height))
        topSky.anchorPoint = CGPoint(x: 0.5, y: 1)

        let bottomSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.16, brightness: 0.96, alpha: 1), size: CGSize(width: frame.width, height: frame.height))
        bottomSky.anchorPoint = CGPoint(x: 1, y: 0.5)

        topSky.position = CGPoint(x: frame.minX, y: frame.midY)
        bottomSky.position = CGPoint(x: frame.maxX, y: frame.midY)

        addChild(topSky)
        addChild(bottomSky)

        bottomSky.zPosition = -40
        topSky.zPosition = -40
    }

    func createCrashPlaneBackground() {
        let backgroundTexture = SKTexture(imageNamed: "cp.background")

        for i in 0 ... 2 {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.zPosition = -30
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: frame.width * 0.1 , y: (backgroundTexture.size().height * CGFloat(i)) - CGFloat(1 * i))
            addChild(background)

            let moveLeft = SKAction.moveBy(x: 0 , y: -backgroundTexture.size().height, duration: 20)
            let moveReset = SKAction.moveBy(x: 0, y: backgroundTexture.size().height, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)

            background.run(moveForever)
        }
    }

    func createCrashPlaneGround() {
        let groundTexture = SKTexture(imageNamed: "cp.ground")

        for i in 0 ... 2 {
            let ground = SKSpriteNode(texture: groundTexture)
            ground.zPosition = -10
            ground.position = CGPoint(x: frame.width - groundTexture.size().width * 0.5 * screenScale, y:  (groundTexture.size().height * 0.5 + (groundTexture.size().height * CGFloat(i))))
            ground.physicsBody = SKPhysicsBody(texture: ground.texture!, size: ground.texture!.size())
            ground.physicsBody?.isDynamic = false

            addChild(ground)

            let moveLeft = SKAction.moveBy(x: 0, y: -groundTexture.size().height, duration: 5)
            let moveReset = SKAction.moveBy(x: 0, y: groundTexture.size().height, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)

            ground.run(moveForever)
        }
    }

    func createPlayer1stScore() {
        score1stLabel.fontSize = 24
        score1stLabel.position = CGPoint(x: 40, y: 40)
        score1stLabel.horizontalAlignmentMode = .left
        score1stLabel.text = "Player1: \(score1st)"
        score1stLabel.fontColor = UIColor.black
        score1stLabel.zRotation = .pi * 0.5
        addChild(score1stLabel)
    }
    func createPlayer2ndScore() {
        score2ndLabel.fontSize = 24
        score2ndLabel.position = CGPoint(x: 40, y: frame.maxY - 40)
        score2ndLabel.horizontalAlignmentMode = .right
        score2ndLabel.text = "Player2: \(score2nd)"
        score2ndLabel.fontColor = UIColor.black
        score2ndLabel.zRotation = .pi * 0.5

        addChild(score2ndLabel)
    }

    func createCrashPlaneLogos() {
        logo = SKSpriteNode(imageNamed: "cp.logo")
        logo.position = CGPoint(x: frame.midX, y: frame.midY)
        logo.zRotation = .pi * 0.5
        addChild(logo)

    }
    
    func gameOver() {
        self.removeAllChildren()
        let gameOverScene = GameOverScene(size: self.size)
        gameOverScene.numberPlayer = numberPlayer
        gameOverScene.gameName = .CrashPlane
        gameOverScene.pScore1st = score1st
        gameOverScene.pScore2nd = score2nd
        gameOverScene.scaleMode = .aspectFill
        let transition = SKTransition.crossFade(withDuration: 1.0)
        self.scene!.view?.presentScene(gameOverScene, transition: transition)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "pause" {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let pauseScene = PauseScene(size: self.size)
            pauseScene.sceneShare.crashPlaneGameScene = self
            pauseScene.gameName = .CrashPlane
            pauseScene.scaleMode = .aspectFill
            self.scene?.isPaused = true
            self.scene!.view?.presentScene(pauseScene, transition: transition)
        }
        switch numberPlayer {
        case .OnePlayer:
            switch gameState {
            case .Logo:
                let fadeOut = SKAction.fadeOut(withDuration: 0.5)
                let remove = SKAction.removeFromParent()
                let wait = SKAction.wait(forDuration: 0.5)
                let activatePlayer = SKAction.run { [unowned self] in
                    self.player1st.physicsBody?.isDynamic = true
                    self.startCrashPlaneRocks()
                }
                gameState = .Playing
                let sequence = SKAction.sequence([fadeOut, wait, activatePlayer, remove])
                logo.run(sequence)
            case .Playing:
                logo.isHidden = true
                self.player1st.physicsBody?.isDynamic = true
                for touch in touches {
                    let location = touch.location(in: self)
                    if location.y < frame.midY {
                        player1st.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                        player1st.physicsBody?.applyImpulse(CGVector(dx: -20, dy: 0))
                    }
                }
            case .Dead:
                let transition = SKTransition.crossFade(withDuration: 1.0)
                let gameOverScene = GameOverScene(size: self.size)
                gameOverScene.numberPlayer = .OnePlayer
                gameOverScene.gameName = .CrashPlane
                gameOverScene.backScene = CrashPlaneGameScene(size: self.size)
                gameOverScene.scaleMode = .aspectFill
                self.scene!.view?.presentScene(gameOverScene, transition: transition)
                
            }
        case .TwoPlayer:
            switch gameState {
            case .Logo:
                let fadeOut = SKAction.fadeOut(withDuration: 0.5)
                let remove = SKAction.removeFromParent()
                let wait = SKAction.wait(forDuration: 0.5)
                let activatePlayer = SKAction.run { [unowned self] in
                    self.player1st.physicsBody?.isDynamic = true
                    self.player2nd.physicsBody?.isDynamic = true
                    self.startCrashPlaneRocks()
                }
                gameState = .Playing
                let sequence = SKAction.sequence([fadeOut, wait, activatePlayer, remove])
                logo.run(sequence)
            case .Playing:
                for touch in touches {
                    let location = touch.location(in: self)
                    if location.y < frame.midY {
                        player1st.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                        player1st.physicsBody?.applyImpulse(CGVector(dx: -20, dy: 0))
                    }else {
                        player2nd.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                        player2nd.physicsBody?.applyImpulse(CGVector(dx: -20, dy: 0))
                    }
                }
            case .Dead:
                let transition = SKTransition.crossFade(withDuration: 1.0)
                let gameOverScene = GameOverScene(size: self.size)
                gameOverScene.backScene = CrashPlaneGameScene(size: self.size)
                gameOverScene.numberPlayer = .TwoPlayer
                gameOverScene.gameName = .CrashPlane
                gameOverScene.scaleMode = .aspectFill
                self.scene!.view?.presentScene(gameOverScene, transition: transition)
            }
        }
    }
    func didBegin(_ contact: SKPhysicsContact) {
        switch numberPlayer {
        case .OnePlayer:
            guard let bodyA = contact.bodyA.node else { return }
            guard let bodyB = contact.bodyB.node else { return }
            if bodyA.name == "scoreDetect1st" || bodyB.name == "scoreDetect1st" {
                if bodyA == player1st {
                    bodyB.removeFromParent()
                } else {
                    bodyA.removeFromParent()
                }

                let sound = SKAction.playSoundFileNamed("cp.coin.wav", waitForCompletion: false)
                run(sound)
                score1st += 1
                return
            }
            if bodyA.name == "scoreDetect2nd" || bodyB.name == "scoreDetect2nd" {
                if bodyA == player1st {
                    bodyB.removeFromParent()
                } else {
                    bodyA.removeFromParent()
                }
                return
            }
            if bodyA == player1st || bodyB == player1st   {
                if let explosion = SKEmitterNode(fileNamed: "cp.explosion.sks") {
                    explosion.position = player1st.position
                    addChild(explosion)
                }

                let sound = SKAction.playSoundFileNamed("cp.explosion.wav", waitForCompletion: false)
                run(sound)

                player1st.removeFromParent()
                backGroundMusic.run(SKAction.stop())
                speed = 0
                gameState = .Dead
            }
        case .TwoPlayer:
            guard let bodyA = contact.bodyA.node else { return }
            guard let bodyB = contact.bodyB.node else { return }
            if bodyA.name == "scoreDetect1st" || bodyB.name == "scoreDetect1st" {
                if bodyA == player2nd || bodyB == player2nd {
                    return
                }
                if bodyA == player1st {
                    bodyB.removeFromParent()
                } else {
                    bodyA.removeFromParent()
                }

                let sound = SKAction.playSoundFileNamed("cp.coin.wav", waitForCompletion: false)
                run(sound)
                score1st += 1
                return
            }
            if bodyA.name == "scoreDetect2nd" || bodyB.name == "scoreDetect2nd" {
                if bodyA == player1st || bodyB == player1st {
                    return
                }
                if bodyA == player2nd {
                    bodyB.removeFromParent()
                } else {
                    bodyA.removeFromParent()
                }

                let sound = SKAction.playSoundFileNamed("cp.coin.wav", waitForCompletion: false)
                run(sound)
                score2nd += 1
                return
            }
            if bodyA == player1st || bodyB == player1st   {
                if let explosion = SKEmitterNode(fileNamed: "cp.explosion.sks") {
                    explosion.position = player1st.position
                    addChild(explosion)
                }

                let sound = SKAction.playSoundFileNamed("cp.explosion.wav", waitForCompletion: false)
                run(sound)

                player1st.removeFromParent()
                player1stDeath = true
                if player2ndDeath {
                    backGroundMusic.run(SKAction.stop())
                    speed = 0
                    gameOver()
                }
            }
            if bodyA == player2nd || bodyB == player2nd   {
                if let explosion = SKEmitterNode(fileNamed: "cp.explosion.sks") {
                    explosion.position = player2nd.position
                    addChild(explosion)
                }

                let sound = SKAction.playSoundFileNamed("cp.explosion.wav", waitForCompletion: false)
                run(sound)

                player2nd.removeFromParent()
                player2ndDeath = true
                if player1stDeath {
                    backGroundMusic.run(SKAction.stop())
                    speed = 0
                    gameOver()
                }
            }
        }
    }
}

