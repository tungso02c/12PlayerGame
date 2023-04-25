//
//  gptgame.swift
//  12Players
//
//  Created by Lê Thị Minh Thảo on 04/02/2023.
//

import SpriteKit

class GameScene: SKScene {
    
    let player1 = SKLabelNode(text: "Player 1")
    let player2 = SKLabelNode(text: "Player 2")
    var player1Score = 0
    var player2Score = 0
    let serveLabel = SKLabelNode(text: "")
    var ball = SKSpriteNode(imageNamed: "ball")
    
    override func didMove(to view: SKView) {
        player1.position = CGPoint(x: size.width/4, y: size.height/2)
        addChild(player1)
        
        player2.position = CGPoint(x: size.width * 3/4, y: size.height/2)
        addChild(player2)
        
        serveLabel.position = CGPoint(x: size.width/2, y: size.height * 3/4)
        addChild(serveLabel)
        
        ball.position = CGPoint(x: size.width/2, y: size.height/2)
        ball.size = CGSize(width: 50, height: 50)
        addChild(ball)
        
        player1.text = "Player 1: \(player1Score)"
        player2.text = "Player 2: \(player2Score)"
        serveLabel.text = "\(player1.text!.split(separator: " ")[0]) to serve"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let serve = Int.random(in: 0...1)
        let startPosition = ball.position
        let endPosition: CGPoint
        let animationDuration = 1.0
        
        if serve == 0 {
            player1Score += 1
            player1.text = "Player 1: \(player1Score)"
            endPosition = CGPoint(x: size.width * 3/4, y: size.height/2)
            serveLabel.text = "\(player2.text!.split(separator: " ")[0]) to serve"
        } else {
            player2Score += 1
            player2.text = "Player 2: \(player2Score)"
            endPosition = CGPoint(x: size.width/4, y: size.height/2)
            serveLabel.text = "\(player1.text!.split(separator: " ")[0]) to serve"
        }
        
        let moveAction = SKAction.move(to: endPosition, duration: animationDuration)
        let bounceAction = SKAction.sequence([moveAction, moveAction.reversed()])
        ball.run(bounceAction)
        
        if player1Score >= 21 || player2Score >= 21 {
            let winner = player1Score > player2Score ? player1 : player2
            let winLabel = SKLabelNode(text: "\(winner.text!.split(separator: " ")[0]) wins!")
            winLabel.position = CGPoint(x: size.width/2, y: size.height/2)
            addChild(winLabel)
        }
    }
}

