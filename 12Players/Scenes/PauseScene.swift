//
//  PauseScene.swift
//  12Players
//
//  Created by Lê Thị Minh Thảo on 31/01/2023.
//

import SpriteKit

class PauseScene: ParentScene {
    
    override func didMove(to view: SKView) {
        
        setHeader(withName: "pause", andBackground: "header_background", width: frame.width * 0.6 ,  position: CGPoint(x: self.frame.midX, y: self.frame.maxY * 0.9))
        
        let titles = ["resume", "restart", "options", "menu"]
        
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
        
        if node.name == "resume" {
            switch gameName {
            case .CrashPlane :
                let transition = SKTransition.crossFade(withDuration: 1.0)
                guard let gameScene = sceneShare.crashPlaneGameScene else { return }
                gameScene.scaleMode = .aspectFill
                self.scene!.view?.presentScene(gameScene, transition: transition)
                //            case .CarRace :
                //                let transition = SKTransition.crossFade(withDuration: 1.0)
                //                guard let gameScene = sceneShare.carRaceGameScene else { return }
                //                gameScene.scaleMode = .aspectFill
                //                self.scene!.view?.presentScene(gameScene, transition: transition)
                //            case .WarFly :
                //                let transition = SKTransition.crossFade(withDuration: 1.0)
                //                guard let gameScene = sceneShare.warFlyGameScene else { return }
                //                gameScene.scaleMode = .aspectFill
                //                self.scene!.view?.presentScene(gameScene, transition: transition)
                //            case .AngelicaFighti :
                //                let transition = SKTransition.crossFade(withDuration: 1.0)
                //                guard let gameScene = sceneShare.angelicaFightiGameScene else { return }
                //                gameScene.scaleMode = .aspectFill
                //                self.scene!.view?.presentScene(gameScene, transition: transition)
            case .WayBackHome :
                let transition = SKTransition.crossFade(withDuration: 1.0)
                guard let gameScene = sceneShare.wayBackHomeGameScene else { return }
                gameScene.scaleMode = .aspectFill
                self.scene!.view?.presentScene(gameScene, transition: transition)
            case .FloatBall :
                let transition = SKTransition.crossFade(withDuration: 1.0)
                guard let gameScene = sceneShare.floatBallGameScene else { return }
                gameScene.scaleMode = .aspectFill
                self.scene!.view?.presentScene(gameScene, transition: transition)
            case .BloomBall :
                let transition = SKTransition.crossFade(withDuration: 1.0)
                guard let gameScene = sceneShare.bloomBallGameScene else { return }
                gameScene.scaleMode = .aspectFill
                self.scene!.view?.presentScene(gameScene, transition: transition)
            case .GrabNumber :
                let transition = SKTransition.crossFade(withDuration: 1.0)
                guard let gameScene = sceneShare.grabNumberGameScene else { return }
                gameScene.scaleMode = .aspectFill
                self.scene!.view?.presentScene(gameScene, transition: transition)
            }
        } else if node.name == "restart" {
            switch gameName {
            case .CrashPlane:
                let transition = SKTransition.crossFade(withDuration: 1.0)
                let crashPlaneGameScene = CrashPlaneGameScene(size: self.size)
                crashPlaneGameScene.numberPlayer = numberPlayer
                crashPlaneGameScene.score1st = pScore1st
                crashPlaneGameScene.score2nd = pScore2nd
                crashPlaneGameScene.scaleMode = .aspectFill
                sceneShare.crashPlaneGameScene = nil
                self.scene!.view?.presentScene(crashPlaneGameScene, transition: transition)
//            case .CarRace:
//                let transition = SKTransition.crossFade(withDuration: 1.0)
//                let carRaceGameScene = CarRaceGameScene(size: self.size)
//                carRaceGameScene.numberPlayer = numberPlayer
//                carRaceGameScene.level = level
//                sceneShare.carRaceGameScene = nil
//                self.scene!.view?.presentScene(carRaceGameScene, transition: transition)
//            case .WarFly:
//                let transition = SKTransition.crossFade(withDuration: 1.0)
//                let warFlyGameScene = WarFlyGameScene(size: self.size)
//                warFlyGameScene.numberPlayer = numberPlayer
//                warFlyGameScene.scaleMode = .aspectFill
//                sceneShare.warFlyGameScene = nil
//                self.scene!.view?.presentScene(warFlyGameScene, transition: transition)
//            case .AngelicaFighti:
//                let transition = SKTransition.crossFade(withDuration: 1.0)
//                let angelicaFightiGameScene = AngelicaFightiGameScene(size: self.size)
//                angelicaFightiGameScene.numberPlayer = numberPlayer
//                angelicaFightiGameScene.scaleMode = .aspectFill
//                sceneShare.angelicaFightiGameScene = nil
//                self.scene!.view?.presentScene(angelicaFightiGameScene, transition: transition)
            case .WayBackHome:
                let transition = SKTransition.crossFade(withDuration: 1.0)
                let wayBackHomeGameScene = WayBackHomeGameScene(size: self.size)
                wayBackHomeGameScene.score1st = pScore1st
                wayBackHomeGameScene.score2nd = pScore2nd
                wayBackHomeGameScene.numberPlayer = numberPlayer
                wayBackHomeGameScene.scaleMode = .aspectFill
                sceneShare.wayBackHomeGameScene = nil
                self.scene!.view?.presentScene(wayBackHomeGameScene, transition: transition)
            case .FloatBall:
                let transition = SKTransition.crossFade(withDuration: 1.0)
                let floatBallGameScene = FloatBallGameScene(size: self.size)
                floatBallGameScene.numberPlayer = numberPlayer
                floatBallGameScene.level = level
                sceneShare.floatBallGameScene = nil
                self.scene!.view?.presentScene(floatBallGameScene, transition: transition)
            case .BloomBall:
                let transition = SKTransition.crossFade(withDuration: 1.0)
                let bloomBallMenuScene = BloomBallGameScene(size: self.size)
                bloomBallMenuScene.numberPlayer = numberPlayer
                bloomBallMenuScene.level = level
                sceneShare.bloomBallGameScene = nil
                self.scene!.view?.presentScene(bloomBallMenuScene, transition: transition)
            case .GrabNumber:
                let transition = SKTransition.crossFade(withDuration: 1.0)
                let grabNumberGameScene = GrabNumberGameScene(size: self.size)
                grabNumberGameScene.numberPlayer = numberPlayer
                grabNumberGameScene.level = level
                sceneShare.grabNumberGameScene = nil
                self.scene!.view?.presentScene(grabNumberGameScene, transition: transition)
            }
        } else if node.name == "options" {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let optionScene = OptionsScene(size: self.size)
            optionScene.backScene = self
            optionScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(optionScene, transition: transition)
        } else if node.name == "menu" {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let menuScene = MenuScene(size: self.size)
            menuScene.backScene = self
            menuScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(menuScene, transition: transition)
        }
    }
}

