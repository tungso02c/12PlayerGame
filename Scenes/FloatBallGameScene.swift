//
//  FloatBallGameScene.swift
//  12Players
//
//  Created by Lê Thị Minh Thảo on 31/01/2023.
//

import CoreMotion
import SpriteKit

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
}

class FloatBallGameScene: ParentScene, SKPhysicsContactDelegate {
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    var startPosition: CGPoint!
    var motionManager: CMMotionManager!

    var isGameOver = false
    var scoreLabel: SKLabelNode!
    var lv = 1

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    let nextLevel = UserDefaults.standard
    override func didMove(to view: SKView) {
        
        let level = nextLevel.integer(forKey: "nextLevel")
        if level > 0 && level < 6 {
            lv = level
        }
//        UserDefaults.standard.removePersistentDomain(forName: "nextLevel")
//        UserDefaults.standard.synchronize()
        let background = SKSpriteNode(imageNamed: "fb.background.jpg")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.blendMode = .replace
        background.size = frame.size
        background.zPosition = -1
        addChild(background)

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        score = nextLevel.integer(forKey: "score")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 15, y: 5)
        scoreLabel.zPosition = 1
        addChild(scoreLabel)

        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self

        createPlayer()
        loadLevel(lv)

        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
    }

    func loadLevel(_ lv: Int) {
        let cellWidth = CGFloat(frame.width / 16)
        let cellHeight = CGFloat(frame.height / 16)
        if let levelPath = Bundle.main.path(forResource: "fb.level\(lv)", ofType: "txt") {
            if let levelString = try? String(contentsOfFile: levelPath) {
                let lines = levelString.components(separatedBy: "\n")

                for (row, line) in lines.enumerated() {
                    for (column, letter) in line.enumerated() {
                        let position = CGPoint(x: cellWidth * CGFloat(column) + cellWidth * 0.5  , y: cellHeight * CGFloat(row) + cellHeight * 0.5)
                        if letter == "x" {
                            // load wall
                            let node = SKSpriteNode(imageNamed: "fb.block")
                            node.position = position
                            node.size.width = cellWidth - 1
                            node.size.height = cellHeight - 1
                            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
                            node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
                            node.physicsBody?.isDynamic = false
                            addChild(node)
                        } else if letter == "v"  {
                            // load vortex
                            let node = SKSpriteNode(imageNamed: "fb.vortex")
                            node.name = "vortex"
                            node.position = position
                            node.size.width = cellWidth
                            node.size.height = cellWidth
                            node.setScale(frame.size.width * 0.05 / node.size.width)
                            node.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi, duration: 1)))
                            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                            node.physicsBody?.isDynamic = false

                            node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
                            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                            node.physicsBody?.collisionBitMask = 0
                            addChild(node)
                        } else if letter == "s"  {
                            // load star
                            let node = SKSpriteNode(imageNamed: "fb.star")
                            node.name = "star"
                            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                            node.physicsBody?.isDynamic = false

                            node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
                            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                            node.physicsBody?.collisionBitMask = 0
                            node.position = position
                            node.size.width = cellWidth
                            node.size.height = cellWidth
                            node.setScale(frame.size.width * 0.05 / node.size.width)
                            addChild(node)
                        } else if letter == "f"  {
                            // load finish
                            let node = SKSpriteNode(imageNamed: "fb.finish")
                            node.name = "finish"
                            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                            node.physicsBody?.isDynamic = false

                            node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
                            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                            node.physicsBody?.collisionBitMask = 0
                            node.position = position
                            node.size.width = cellWidth
                            node.size.height = cellWidth
                            node.setScale(frame.size.width * 0.05 / node.size.width)
                            addChild(node)
                        } else if letter == "p" {
                            player.position = position
                            startPosition = position
                        }
                    }
                }
            }
        }
    }

    func createPlayer() {
        player = SKSpriteNode(imageNamed: "fb.player")
        player.size.width = (frame.width / 16) * 0.8
        player.size.height = (frame.width / 16) * 0.8
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            lastTouchPosition = location
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            lastTouchPosition = location
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }

    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        #if targetEnvironment(simulator)
            if let currentTouch = lastTouchPosition {
                let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
                physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
            }
        #else
            if let accelerometerData = motionManager.accelerometerData {
                physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
            }
        #endif
    }

    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node == player {
            playerCollided(with: contact.bodyB.node!)
        } else if contact.bodyB.node == player {
            playerCollided(with: contact.bodyA.node!)
        }
    }

    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1

            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])

            player.run(sequence) { [unowned self] in
                self.createPlayer()
                self.player.position = startPosition
                self.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            lv += 1
            if lv >= 6 {
                nextLevel.set(1, forKey: "nextLevel")
            } else{
                nextLevel.set(lv, forKey: "nextLevel")
                nextLevel.set(score, forKey: "score")
            }
            moveToNextLevel(lv)
        }
    }
    
    func moveToNextLevel(_ lv: Int){
        self.removeAllChildren()
        let transition = SKTransition.crossFade(withDuration: 1.0)
        let floatBallGameScene = FloatBallGameScene(size: self.size)
        floatBallGameScene.backScene = self
        floatBallGameScene.numberPlayer = numberPlayer
        floatBallGameScene.scaleMode = .aspectFill
        self.scene!.view?.presentScene(floatBallGameScene, transition: transition)
        
    }
}


