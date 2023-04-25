//
//  GameOverScene.swift
//  12Players
//
//  Created by Lê Thị Minh Thảo on 31/01/2023.
//

import SpriteKit

class GameOverScene: ParentScene {
   
    override func didMove(to view: SKView) {
        
        setHeader(withName: "game over", andBackground: "header_background", width: frame.width * 0.6 , position: CGPoint(x: self.frame.midX, y: self.frame.maxY * 0.9))

        let panel = SKShapeNode(rectOf: CGSize(width: frame.width * 0.96, height: frame.height * 0.1))
        panel.position = CGPoint(x: frame.midX, y: frame.maxY * 0.1)
        panel.lineWidth = 2
        addChild(panel)

        let scoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        scoreLabel.text = "SCORE"
        scoreLabel.fontColor =  UIColor(red: 219 / 255, green: 226 / 255, blue: 215 / 255, alpha: 1.0)
        scoreLabel.position = CGPoint(x: frame.midX, y: panel.position.y + panel.frame.height * 0.5)
        addChild(scoreLabel)
        
        setScorePanel(withName: "Player1 : \(pScore1st)", andBackground: "header_background", width: frame.width * 0.4 , position: CGPoint(x: frame.maxX * 0.25, y: frame.maxY * 0.1))
        setScorePanel(withName: "Player2 : \(pScore2nd)", andBackground: "header_background", width: frame.width * 0.4 , position: CGPoint(x: frame.maxX * 0.75, y: frame.maxY * 0.1))
        
        let titles = ["restart", "options", "best" , "menu"]
        
        for (index, title) in titles.enumerated() {
            let button = ButtonNode(titled: title, backgroundName: "button_background")
            button.position = CGPoint(x: self.frame.midX, y: self.frame.maxY * 0.6 - CGFloat(100 * index) * button.screenScale)
            button.size.width = frame.width * 0.4
            button.name = title
            button.label.name = title
            addChild(button)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "restart" {
            switch gameName {
            case .BloomBall :
                let transition = SKTransition.crossFade(withDuration: 1.0)
                let bloomBallMenuScene = BloomBallGameScene(size: self.size)
                bloomBallMenuScene.numberPlayer = numberPlayer
                bloomBallMenuScene.level = level
                sceneShare.bloomBallGameScene = nil
                self.scene!.view?.presentScene(bloomBallMenuScene, transition: transition)
            case .WayBackHome :
                let transition = SKTransition.crossFade(withDuration: 1.0)
                let wayBackHomeGameScene = WayBackHomeGameScene(size: self.size)
                wayBackHomeGameScene.score1st = pScore1st
                wayBackHomeGameScene.score2nd = pScore2nd
                wayBackHomeGameScene.numberPlayer = numberPlayer
                wayBackHomeGameScene.scaleMode = .aspectFill
                sceneShare.wayBackHomeGameScene = nil
                self.scene!.view?.presentScene(wayBackHomeGameScene, transition: transition)
//            case .AngelicaFighti :
//                let transition = SKTransition.crossFade(withDuration: 1.0)
//                let angelicaFightiGameScene = AngelicaFightiGameScene(size: self.size)
//                angelicaFightiGameScene.numberPlayer = numberPlayer
//                angelicaFightiGameScene.scaleMode = .aspectFill
//                sceneShare.angelicaFightiGameScene = nil
//                self.scene!.view?.presentScene(angelicaFightiGameScene, transition: transition)
//            case .WarFly :
//                let transition = SKTransition.crossFade(withDuration: 1.0)
//                let warFlyGameScene = WarFlyGameScene(size: self.size)
//                warFlyGameScene.numberPlayer = numberPlayer
//                warFlyGameScene.scaleMode = .aspectFill
//                sceneShare.warFlyGameScene = nil
//                self.scene!.view?.presentScene(warFlyGameScene, transition: transition)
            case .CrashPlane :
                let transition = SKTransition.crossFade(withDuration: 1.0)
                let crashPlaneGameScene = CrashPlaneGameScene(size: self.size)
                crashPlaneGameScene.numberPlayer = numberPlayer
                crashPlaneGameScene.score1st = pScore1st
                crashPlaneGameScene.score2nd = pScore2nd
                crashPlaneGameScene.scaleMode = .aspectFill
                sceneShare.crashPlaneGameScene = nil
                self.scene!.view?.presentScene(crashPlaneGameScene, transition: transition)
            default:
                print("Something wrong with gameName \(gameName)!")
                let transition = SKTransition.crossFade(withDuration: 1.0)
                let menuScene = MenuScene(size: self.size)
                menuScene.backScene = self
                menuScene.scaleMode = .aspectFill
                self.scene!.view?.presentScene(menuScene, transition: transition)
            }
            
        } else if node.name == "options" {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let optionScene = OptionsScene(size: self.size)
            optionScene.backScene = self
            optionScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(optionScene, transition: transition)
        } else if node.name == "best" {
            
//            let transition = SKTransition.crossFade(withDuration: 1.0)
//            let bestScene = BestScene(size: self.size)
//            bestScene.backScene = self
//            bestScene.scaleMode = .aspectFill
//            self.scene!.view?.presentScene(bestScene, transition: transition)
        } else if node.name == "menu" {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let menuScene = MenuScene(size: self.size)
            menuScene.backScene = self
            menuScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(menuScene, transition: transition)
        }
    }
}


