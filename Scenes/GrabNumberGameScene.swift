//
//  GrabNumberGameScene.swift
//  12Players
//
//  Created by Lê Thị Minh Thảo on 31/01/2023.
//

import SpriteKit

class GrabNumberGameScene: ParentScene {
    var grab1Touch = false
    var grab2Touch = false
    var nextNumber1: SKLabelNode!
    var nextNumber2: SKLabelNode!
    var touchNum: Int = 1 {
        didSet {
            nextNumber1.text = "Let's grab: \(touchNum)"
            nextNumber2.text = "Let's grab: \(touchNum)"
        }
    }
    var scoreGrab1: Int = 0
    var scoreGrab2: Int = 0
    
    override func didMove(to view: SKView) {
        
        self.scene?.isPaused = false
        // checking if scene persists
        guard sceneShare.grabNumberGameScene == nil else { return }
        let columns: Int = 12
        let cell: CGFloat = frame.width / CGFloat(columns)
        let rows: Int = columns + 2
        let arr = Array(0...columns * rows)
        var numbers = Dictionary(uniqueKeysWithValues: zip(arr, arr))
                
        let grab1 = SKShapeNode(circleOfRadius: cell * 2)
        grab1.position = CGPoint(x: frame.midX, y: frame.minY - cell)
        grab1.name = "grab1"
        grab1.fillColor = .blue
        addChild(grab1)
        
        let grab2 = SKShapeNode(circleOfRadius: cell * 2)
        grab2.position = CGPoint(x: frame.midX, y: frame.maxY + cell)
        grab2.name = "grab2"
        grab2.fillColor = .red
        addChild(grab2)
        
        let pause = SKSpriteNode(imageNamed: "pause")
        pause.size = CGSize(width: frame.width * 0.05, height: frame.height * 0.05)
        pause.position = CGPoint(x: frame.maxX - pause.size.width , y: cell * 0.5)
        pause.zPosition = 10
        pause.zRotation = .pi * 0.5
        pause.name = "pause"
        addChild(pause)
        
        nextNumber1 = SKLabelNode(fontNamed: "Arial-BoldMT")
        nextNumber1.position = CGPoint(x: frame.minX, y: cell * 0.5)
        nextNumber1.horizontalAlignmentMode = .left
        nextNumber1.text = "Let's grab: \(touchNum)"
        nextNumber1.fontColor = .white
        nextNumber1.setScale(screenScale)
        addChild(nextNumber1)
        
        nextNumber2 = SKLabelNode(fontNamed: "Arial-BoldMT")
        nextNumber2.position = CGPoint(x: frame.maxX, y: frame.maxY - cell * 0.5)
        nextNumber2.horizontalAlignmentMode = .left
        nextNumber2.zRotation = .pi
        nextNumber2.text = "Let's grab: \(touchNum)"
        nextNumber2.fontColor = .white
        nextNumber2.setScale(screenScale)
        addChild(nextNumber2)
        
        for row in 0..<rows  {
            for col in 0..<columns {
                let position = CGPoint(x: cell * CGFloat(col) + cell * 0.5, y: cell * CGFloat(row) + (frame.height - frame.width - cell) * 0.5)
                guard let rnd = numbers.randomElement() else {
                    return
                }
                numbers.removeValue(forKey: rnd.key)
                let number = SKLabelNode(fontNamed: "Arial-BoldMT")
                let bgShape = SKShapeNode(circleOfRadius: cell * 0.5 - 2)
                bgShape.zPosition = 8
                number.zPosition = 10
                bgShape.fillColor = .white
                number.fontColor = .black
                if rnd.value > 0 && rnd.value < 100 {
                    bgShape.name = "\(rnd.value)"
                    number.text = "\(rnd.value)."
                    number.horizontalAlignmentMode = .center
                    number.verticalAlignmentMode = .center
                    bgShape.position = position
                    number.zRotation = .pi * Double.random(in: 0...2)
                    number.setScale(screenScale)
                    bgShape.addChild(number)
                    addChild(bgShape)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        if node.name == "pause" {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let pauseScene = PauseScene(size: self.size)
            pauseScene.sceneShare.grabNumberGameScene = self
            pauseScene.gameName = .GrabNumber
            pauseScene.scaleMode = .aspectFill
            self.scene?.isPaused = true
            self.scene!.view?.presentScene(pauseScene, transition: transition)
        }
        if node.name == "grab1" {
            grab1Touch = true
            grab2Touch = false
        }
        if node.name == "grab2" {
            grab2Touch = true
            grab1Touch = false
        }
        
        if touchNum == 100 {
            endGameAlert()
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        if let number = childNode(withName: "\(touchNum)") as? SKShapeNode {
            if objects.contains(number) {
                if grab2Touch {
                    number.fillColor = .red
                    touchNum += 1
                    scoreGrab2 += 1
                }
                if grab1Touch {
                    number.fillColor = .blue
                    touchNum += 1
                    scoreGrab1 += 1
                }
            }
        }
        if touchNum == 100 {
            endGameAlert()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        if let number = childNode(withName: "\(touchNum)") as? SKShapeNode {
            if objects.contains(number) {
                if grab2Touch {
                    number.fillColor = .red
                    touchNum += 1
                    scoreGrab2 += 1
                }
                if grab1Touch {
                    number.fillColor = .blue
                    touchNum += 1
                    scoreGrab1 += 1
                }
            }
        }
        if touchNum == 100 {
            endGameAlert()
        }
    }
    
    func endGameAlert() {
        let winner = SKLabelNode(fontNamed: "Arial-BoldMT")
        winner.text = scoreGrab2 >= scoreGrab1 ? "Red Win!" : "Blue Win!"
        winner.position = CGPoint(x: frame.midX, y: frame.midY)
        winner.fontColor = scoreGrab2 >= scoreGrab1 ? .red : .blue
        winner.zRotation = scoreGrab2 >= scoreGrab1 ? .pi : .pi * 2
        winner.zPosition = 10
        winner.fontSize = 32
        addChild(winner)
        
        let fadeOut = SKAction.fadeOut(withDuration: 1)
        let remove = SKAction.removeFromParent()
        let wait = SKAction.wait(forDuration: 1)
        let restartOption = SKAction.run { [unowned self] in
            self.restartOption()
        }
        let sequence = SKAction.sequence([fadeOut, wait, restartOption ,remove])
        winner.run(sequence)
    }
    
    func restartOption() {
        let transition = SKTransition.crossFade(withDuration: 1.0)
        let grabNumberGameScene = GrabNumberGameScene(size: self.size)
        grabNumberGameScene.numberPlayer = numberPlayer
        grabNumberGameScene.scaleMode = .aspectFill
        self.scene!.view?.presentScene(grabNumberGameScene, transition: transition)
    }
}


