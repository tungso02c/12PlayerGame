//
//  BloomBallGameScene.swift
//  12Players
//
//  Created by Lê Thị Minh Thảo on 31/01/2023.
//

import SpriteKit

struct BbPhysicsCategory {
    static let paddle1: UInt32 = 0x1 << 0
    static let brick: UInt32 = 0x1 << 1
    static let wall: UInt32 = 0x1 << 2
//    static let floor: UInt32 = 0x1 << 3
    static let ball1: UInt32 = 0x1 << 4
    static let block: UInt32 = 0x1 << 5
    static let box: UInt32 = 0x1 << 6
    static let dropbox: UInt32 = 0x1 << 7
    static let dropblock: UInt32 = 0x1 << 8
    static let edge: UInt32 = 0x1 << 9
}
class BloomBallGameScene: ParentScene , SKPhysicsContactDelegate {
    
    let cellDia: CGFloat = UIScreen.main.bounds.width / 62
    var paddle1 : SKShapeNode!
    var paddle1PhysicBody : SKShapeNode!
    var isTouchEnd = false
    
    override func didMove(to view: SKView) {
        
        self.scene?.isPaused = false
        // checking if scene persists
        guard sceneShare.bloomBallGameScene == nil else { return }
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        makeEdge()
        createPauseButton()
        makePaddle1()
        makeBall1(0)
        loadLevel(level)
        
    }
    
    func makeEdge() {
        let edge = SKPhysicsBody(edgeLoopFrom: self.frame)
        edge.categoryBitMask = BbPhysicsCategory.edge
        edge.friction = 0
        self.physicsBody = edge
    }
    
    func createPauseButton() {
        let pause = SKSpriteNode(imageNamed: "pause")
        pause.size = CGSize(width: frame.width * 0.05, height: frame.height * 0.05)
        pause.position = CGPoint(x: frame.midX , y: frame.maxY - pause.size.height * 0.5)
        pause.zPosition = 10
        pause.zRotation = .pi * 0.5
        pause.name = "pause"
        addChild(pause)
    }
    
    
    func makeBall1(_ type : Int) {
        if type == 0 {
            let ball1 = SKShapeNode(circleOfRadius: CGFloat(cellDia * 0.7))
            ball1.name = "ball1"
            ball1.fillColor = .white
            ball1.position = CGPoint(x: frame.midX, y: paddle1.position.y + ball1.frame.size.height * 2)
            ball1.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(cellDia))
            ball1.physicsBody?.allowsRotation = false
            ball1.physicsBody?.friction = 0
            ball1.physicsBody?.restitution = 1
            ball1.physicsBody?.linearDamping = 0
            ball1.physicsBody?.isDynamic = true
            ball1.physicsBody?.categoryBitMask = BbPhysicsCategory.ball1
            ball1.physicsBody?.collisionBitMask = BbPhysicsCategory.wall | BbPhysicsCategory.paddle1 | BbPhysicsCategory.brick | BbPhysicsCategory.box | BbPhysicsCategory.block
            ball1.physicsBody?.contactTestBitMask = BbPhysicsCategory.brick | BbPhysicsCategory.paddle1 | BbPhysicsCategory.box | BbPhysicsCategory.block | BbPhysicsCategory.edge
            addChild(ball1)
            ball1.physicsBody?.velocity = .zero
            if Int.random(in: 1...2) == 2 {
                ball1.physicsBody?.applyImpulse(CGVector(dx: -cellDia * screenScale * CGFloat.random(in: 0.1...0.5), dy: cellDia * screenScale))
            } else{
                ball1.physicsBody?.applyImpulse(CGVector(dx: cellDia * screenScale * CGFloat.random(in: 0.1...0.5), dy: cellDia * screenScale))
            }
        } else if type == 1 {
            for direction in 1...3 {
                let ball1 = SKShapeNode(circleOfRadius: CGFloat(cellDia * 0.7))
                ball1.name = "ball1"
                ball1.fillColor = .white
                ball1.position = paddle1.position
                ball1.position.y = paddle1.position.y + ball1.frame.size.height * 2
                ball1.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(cellDia))
                ball1.physicsBody?.allowsRotation = false
                ball1.physicsBody?.friction = 0
                ball1.physicsBody?.restitution = 1
                ball1.physicsBody?.linearDamping = 0
                ball1.physicsBody?.isDynamic = true
                ball1.physicsBody?.categoryBitMask = BbPhysicsCategory.ball1
                ball1.physicsBody?.collisionBitMask = BbPhysicsCategory.wall | BbPhysicsCategory.paddle1 | BbPhysicsCategory.brick | BbPhysicsCategory.ball1 | BbPhysicsCategory.box | BbPhysicsCategory.block
                ball1.physicsBody?.contactTestBitMask = BbPhysicsCategory.brick | BbPhysicsCategory.paddle1  | BbPhysicsCategory.box | BbPhysicsCategory.block | BbPhysicsCategory.edge
                addChild(ball1)
                ball1.physicsBody?.velocity = .zero
                switch direction {
                case 1 :
                    ball1.physicsBody?.applyImpulse(CGVector(dx: -cellDia * screenScale , dy: cellDia * screenScale))
                case 2 :
                    ball1.physicsBody?.applyImpulse(CGVector(dx: 0, dy: cellDia * screenScale))
                case 3 :
                    ball1.physicsBody?.applyImpulse(CGVector(dx: cellDia * screenScale , dy: cellDia * screenScale))
                default:
                    print ("Cannot jump in here!")
                }
            }
        } else if type == 2 {
            var num = 0
            enumerateChildNodes(withName: "ball1") { [self]
                node, stop in
                num += 1
                if num < 30 {
                    for direction in 1...2 {
                        let ball1 = SKShapeNode(circleOfRadius: CGFloat(cellDia * 0.7))
                        ball1.name = "ball1"
                        ball1.position = node.position
                        ball1.fillColor = .white
                        ball1.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(cellDia))
                        ball1.physicsBody?.allowsRotation = false
                        ball1.physicsBody?.friction = 0
                        ball1.physicsBody?.restitution = 1
                        ball1.physicsBody?.linearDamping = 0
                        ball1.physicsBody?.isDynamic = true
                        ball1.physicsBody?.categoryBitMask = BbPhysicsCategory.ball1
                        ball1.physicsBody?.collisionBitMask = BbPhysicsCategory.wall | BbPhysicsCategory.paddle1 | BbPhysicsCategory.brick | BbPhysicsCategory.ball1 | BbPhysicsCategory.box | BbPhysicsCategory.block
                        ball1.physicsBody?.contactTestBitMask = BbPhysicsCategory.brick | BbPhysicsCategory.paddle1 | BbPhysicsCategory.box | BbPhysicsCategory.block | BbPhysicsCategory.edge
                        addChild(ball1)
                        ball1.physicsBody?.velocity = .zero
                        switch direction {
                        case 1 :
                            ball1.physicsBody?.applyImpulse(CGVector(dx: -cellDia * screenScale , dy: cellDia * screenScale))
                        case 2 :
                            ball1.physicsBody?.applyImpulse(CGVector(dx: 0, dy: cellDia * screenScale))
                        case 3 :
                            ball1.physicsBody?.applyImpulse(CGVector(dx: cellDia * screenScale , dy: cellDia * screenScale))
                        default:
                            print ("Cannot jump in here!")
                        }
                    }
                    return
                }
            }
        }
        
    }
    
    
    func makePaddle1() {
        
        paddle1 = SKShapeNode(ellipseOf: CGSize(width: frame.width * 0.25, height: frame.midY * 0.05))
        paddle1.fillColor = .white
        paddle1.position = CGPoint(x: frame.midX, y: frame.midY * 0.1)
        paddle1.physicsBody = SKPhysicsBody(edgeChainFrom: paddle1.path!)
        paddle1.name = "paddle1"
        paddle1.physicsBody?.friction = 0
        paddle1.physicsBody?.restitution = 1
        paddle1.physicsBody?.linearDamping = 0
        paddle1.physicsBody?.allowsRotation = false
        paddle1.physicsBody?.isDynamic = false
        paddle1.physicsBody?.categoryBitMask = BbPhysicsCategory.paddle1
        paddle1.physicsBody?.contactTestBitMask = BbPhysicsCategory.ball1 | BbPhysicsCategory.block | BbPhysicsCategory.box
        let edgeConstraint = SKConstraint.positionX(SKRange(lowerLimit: paddle1.frame.width * 0.5,
                                                            upperLimit: frame.width - paddle1.frame.width * 0.5))
        paddle1.constraints = [edgeConstraint]
        
        addChild(paddle1)
    }
    
    func loadLevel(_ lv: Int) {
        var lastRow = 0
        if let levelPath = Bundle.main.path(forResource: "bb.level\(lv)", ofType: "txt") {
            if let levelString = try? String(contentsOfFile: levelPath) {
                let lines = levelString.components(separatedBy: "\n")
                for (row, line) in lines.enumerated() {
                    for (column, letter) in line.enumerated() {

                        let currentPos = CGPoint(x: CGFloat(cellDia) * CGFloat(column) + cellDia < frame.width ? CGFloat(cellDia) * CGFloat(column) + cellDia : frame.width - cellDia , y: frame.height * getNotch() - cellDia - CGFloat(row) * cellDia)

                        if letter == "w" {
                            // load wall
                            makeWall(position: currentPos, color: .red)
                            lastRow = row
                        } else if letter == "p" {
                            // load picture
                            makeBrick(position: currentPos, color: .blue)
                        } else if letter == "b"{
                            // load brick
                            switch (Int(arc4random() % 100)){
                            case 0...92:
                                // load brick
                                makeBrick(position: currentPos, color: .white)
                            case 93...98:
                                // load box
                                makeBox(position: currentPos, color: .clear)
                                makeBrick(position: currentPos, color: .white)
                            default:
                                // load block
                                makeBlock(position: currentPos, color: .clear)
                                makeBrick(position: currentPos, color: .white)
                            }
                            
                        }
                    }
                }
            }
        }
        let leftSideWall = SKSpriteNode(color: .clear, size: CGSize(width: 2, height: frame.height - cellDia * CGFloat(lastRow)))
        let rightSideWall = SKSpriteNode(color: .clear, size: CGSize(width: 2, height: frame.height - cellDia * CGFloat(lastRow)))
        leftSideWall.position = CGPoint(x: frame.minX + cellDia * 0.5, y: (frame.height - cellDia * CGFloat(lastRow)) * 0.5)
        rightSideWall.position = CGPoint(x: frame.maxX - cellDia * 0.5, y: (frame.height - cellDia * CGFloat(lastRow)) * 0.5)
        
        leftSideWall.physicsBody = SKPhysicsBody(rectangleOf: leftSideWall.size)
        leftSideWall.physicsBody?.friction = 0
        leftSideWall.physicsBody?.restitution = 1
        leftSideWall.physicsBody?.allowsRotation = false
        leftSideWall.physicsBody?.isDynamic = false
        
        rightSideWall.physicsBody = SKPhysicsBody(rectangleOf: rightSideWall.size)
        rightSideWall.physicsBody?.friction = 0
        rightSideWall.physicsBody?.restitution = 1
        rightSideWall.physicsBody?.allowsRotation = false
        rightSideWall.physicsBody?.isDynamic = false
        
        addChild(leftSideWall)
        addChild(rightSideWall)
    }
    
    func makeBrick (position : CGPoint , color: UIColor) {
        let brick = SKSpriteNode(color: color, size: CGSize(width: cellDia - 1, height: cellDia - 1))
        brick.position = position
        brick.name = "brick"
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
        brick.physicsBody?.friction = 0
        brick.physicsBody?.restitution = 1
        brick.physicsBody?.linearDamping = 0
        brick.physicsBody?.allowsRotation = false
        brick.physicsBody?.isDynamic = false
        brick.physicsBody?.categoryBitMask = BbPhysicsCategory.brick
        brick.physicsBody?.contactTestBitMask = BbPhysicsCategory.ball1
        addChild(brick)
    }
    
    func makeBox(position : CGPoint , color: UIColor) {
        let box = SKSpriteNode(color: color, size: CGSize(width: cellDia - 1, height: cellDia - 1))
        box.position = position
        box.zPosition = 1
        box.name = "box"
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.friction = 0
        box.physicsBody?.restitution = 1
        box.physicsBody?.linearDamping = 0
        box.physicsBody?.allowsRotation = false
        box.physicsBody?.isDynamic = false
        box.physicsBody?.categoryBitMask = BbPhysicsCategory.box
        box.physicsBody?.contactTestBitMask = BbPhysicsCategory.ball1
        addChild(box)
    }
    
    func makeBlock(position : CGPoint , color: UIColor) {
        let block = SKSpriteNode(color: color, size: CGSize(width: 3 * cellDia - 1, height: cellDia - 1))
        block.position = position
        block.zPosition = 1
        block.name = "block"
        block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
        block.physicsBody?.friction = 0
        block.physicsBody?.restitution = 1
        block.physicsBody?.linearDamping = 0
        block.physicsBody?.allowsRotation = false
        block.physicsBody?.isDynamic = false
        block.physicsBody?.categoryBitMask = BbPhysicsCategory.block
        block.physicsBody?.contactTestBitMask = BbPhysicsCategory.ball1
        addChild(block)
    }
    func makeWall(position : CGPoint , color: UIColor) {
        let wall = SKSpriteNode(color: color, size: CGSize(width: cellDia - 1, height: cellDia - 1))
        wall.position = position
        wall.name = "wall"
        wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall.physicsBody?.friction = 0
        wall.physicsBody?.restitution = 1
        wall.physicsBody?.linearDamping = 0
        wall.physicsBody?.allowsRotation = false
        wall.physicsBody?.isDynamic = false
        wall.physicsBody?.categoryBitMask = BbPhysicsCategory.wall
        wall.physicsBody?.contactTestBitMask = BbPhysicsCategory.ball1
        addChild(wall)
    }
    
    func dropBlock(_ position : CGPoint){
        let block = SKSpriteNode(color: .cyan, size: CGSize(width: 3 * cellDia - 1, height: cellDia - 1))
        block.position = position
        block.name = "dropBlock"
        block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
        block.physicsBody?.friction = 0
        block.physicsBody?.restitution = 1
        block.physicsBody?.linearDamping = 0
        block.physicsBody?.allowsRotation = false
        block.physicsBody?.isDynamic = true
        block.physicsBody?.categoryBitMask = BbPhysicsCategory.dropblock
        block.physicsBody?.collisionBitMask = 0
        block.physicsBody?.contactTestBitMask = BbPhysicsCategory.paddle1
        addChild(block)
        block.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -cellDia * screenScale * 0.3))
    }
    
    func dropBox(_ position : CGPoint){
        let box = SKSpriteNode(color: .orange, size: CGSize(width: cellDia - 1, height: cellDia - 1))
        box.position = position
        box.name = "dropBox"
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.friction = 0
        box.physicsBody?.restitution = 1
        box.physicsBody?.linearDamping = 0
        box.physicsBody?.allowsRotation = false
        box.physicsBody?.isDynamic = true
        box.physicsBody?.categoryBitMask = BbPhysicsCategory.dropbox
        box.physicsBody?.collisionBitMask = 0
        box.physicsBody?.contactTestBitMask = BbPhysicsCategory.paddle1
        addChild(box)
        box.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -cellDia * screenScale * 0.1))
    }
    
    func moveToNextLevel(_ lv: Int){
        self.removeAllChildren()
        let transition = SKTransition.crossFade(withDuration: 1.0)
        let bloomBallGameScene = BloomBallGameScene(size: self.size)
        bloomBallGameScene.backScene = self
        bloomBallGameScene.numberPlayer = numberPlayer
        bloomBallGameScene.level = lv
        bloomBallGameScene.scaleMode = .aspectFill
        self.scene!.view?.presentScene(bloomBallGameScene, transition: transition)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let object = nodes(at: location)
        switch numberPlayer {
        case .OnePlayer :
            if !isTouchEnd {
                paddle1.position.x = location.x
            } else if (object.contains(paddle1)) {
                isTouchEnd = false
                paddle1.position.x = location.x
            }
        case .TwoPlayer :
            if !isTouchEnd {
                paddle1.position.x = location.x
            } else if (object.contains(paddle1)) {
                isTouchEnd = false
                paddle1.position.x = location.x
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouchEnd = true
    }
    override func update(_ currentTime: TimeInterval) {
        guard let _ = childNode(withName: "brick") else {
            print("last brick update")
            moveToNextLevel(level+1)
            return
        }
        guard let _ = childNode(withName: "ball1")  else {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let gameOverScene = GameOverScene(size: self.size)
            gameOverScene.numberPlayer = numberPlayer
            gameOverScene.gameName = .BloomBall
            gameOverScene.level = level
            gameOverScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(gameOverScene, transition: transition)
            return
        }
        enumerateChildNodes(withName: "ball1") { [self]
            node, stop in
            if node.position.x < frame.minX || node.position.x > frame.maxX {
                node.removeFromParent()
            }
            if node.position.y < frame.minY || node.position.y > frame.maxY {
                node.removeFromParent()
            }
            return
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        if node.name == "pause" {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let pauseScene = PauseScene(size: self.size)
            pauseScene.sceneShare.bloomBallGameScene = self
            pauseScene.gameName = .BloomBall
            pauseScene.level = level
            pauseScene.scaleMode = .aspectFill
            self.scene?.isPaused = true
            self.scene!.view?.presentScene(pauseScene, transition: transition)
        }

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball1" && contact.bodyB.categoryBitMask == BbPhysicsCategory.edge {
            nodeA.removeFromParent()
        } else if nodeB.name == "ball1" && contact.bodyA.categoryBitMask == BbPhysicsCategory.edge {
            nodeB.removeFromParent()
        }
                    
        if (nodeA.name == "ball1" && nodeB.name == "ball1") && (nodeA.speed > nodeB.speed) {
            nodeB.speed = nodeA.speed
        } else {
            nodeA.speed = nodeB.speed
        }
        if nodeA.name == "ball1" && nodeB.name == "brick" {
            nodeB.removeFromParent()
            guard let _ = childNode(withName: "brick") else {
                moveToNextLevel(level+1)
                return
            }
        }else if nodeB.name == "ball1" && nodeA.name == "brick" {
            nodeA.removeFromParent()
            guard let _ = childNode(withName: "brick") else {
                moveToNextLevel(level+1)
                return
            }
        }
        
        if nodeA.name == "ball1" && nodeB.name == "paddle1" {
            if nodeA.physicsBody?.velocity.dx == 0 {
                if Int.random(in: 1...2) == 2 {
                    nodeA.physicsBody?.applyImpulse(CGVector(dx: -cellDia * screenScale * 0.15, dy: cellDia * screenScale * 0.5))
                }
            }
        }else if nodeB.name == "ball1" && nodeA.name == "paddle1" {
            if nodeB.physicsBody?.velocity.dx == 0 {
                if Int.random(in: 1...2) == 2 {
                    nodeB.physicsBody?.applyImpulse(CGVector(dx: cellDia * screenScale * 0.15, dy: cellDia * screenScale * 0.5))
                }
            }
        }
        if nodeA.name == "ball1" && nodeB.name == "block" {
            dropBlock(nodeB.position)
            nodeB.removeFromParent()
        }else if nodeB.name == "ball1" && nodeA.name == "block" {
            dropBlock(nodeA.position)
            nodeA.removeFromParent()
        }
        if nodeA.name == "ball1" && nodeB.name == "box" {
            dropBox(nodeB.position)
            nodeB.removeFromParent()
        }else if nodeB.name == "ball1" && nodeA.name == "box" {
            dropBox(nodeA.position)
            nodeA.removeFromParent()
        }
        if nodeA.name == "dropBlock" && nodeB.name == "paddle1" {
            makeBall1(2)
            nodeA.removeFromParent()
        }else if nodeB.name == "dropBlock" && nodeA.name == "paddle1" {
            makeBall1(2)
            nodeB.removeFromParent()
        }
        if nodeA.name == "dropBox" && nodeB.name == "paddle1" {
            makeBall1(1)
            nodeA.removeFromParent()
        }else if nodeB.name == "dropBox" && nodeA.name == "paddle1" {
            makeBall1(1)
            nodeB.removeFromParent()
        }
        
    }
    
}
