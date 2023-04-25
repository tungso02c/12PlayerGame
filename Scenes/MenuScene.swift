//
//  MenuScene.swift
//  12Players
//
//  Created by Lê Thị Minh Thảo on 31/01/2023.
//

import SpriteKit

class MenuScene: ParentScene {
//    var backGroundMusic: SKAudioNode!
    override func didMove(to view: SKView) {
        removeAllChildren()
        gameSettings.loadGameSettings()
        let options = ButtonNode(titled: nil, backgroundName: "options")
        options.position = CGPoint(x: self.frame.midX, y: self.frame.maxY * 0.95 - options.size.height)
        options.name = "options"
        addChild(options)
        
        setHeader(withName: "2 players game menu", andBackground: "header_background" , width: frame.width,  position: CGPoint(x: self.frame.midX, y: options.position.y - options.size.height * 1.2))
        
        
        for (index, title) in GameName.allCases.enumerated() {
            let button = ButtonNode(titled: title.rawValue, backgroundName: "button_background")
            button.size.width = self.frame.width * 0.6
            button.position = CGPoint(x: self.frame.midX, y: self.frame.maxY * 0.6 - CGFloat(100 * index) * button.screenScale)
            button.name = title.rawValue
            button.label.name = title.rawValue
            addChild(button)
        }

        
//        if gameSettings.isMusic  {
//            if let musicURL = Bundle.main.url(forResource: "mn.begin", withExtension: "m4a") {
//                backGroundMusic = SKAudioNode(url: musicURL)
//                addChild(backGroundMusic)
//            }
//        } else if backGroundMusic != nil {
//            backGroundMusic.removeAllActions()
//            backGroundMusic.removeFromParent()
//        }
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        
        let node = self.atPoint(location)
        
        if node.name == GameName.CrashPlane.rawValue  {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let crashPlaneMenuScene = CrashPlaneMenuScene(size: self.size)
            crashPlaneMenuScene.backScene = self
            crashPlaneMenuScene.scaleMode = .aspectFill
            sceneShare.crashPlaneGameScene = nil
            self.scene!.view?.presentScene(crashPlaneMenuScene, transition: transition)
//        } else if node.name == GameName.WarFly.rawValue {
//            let transition = SKTransition.crossFade(withDuration: 1.0)
//            let warFlyMenuScene = WarFlyMenuScene(size: self.size)
//            warFlyMenuScene.backScene = self
//            warFlyMenuScene.scaleMode = .aspectFill
//            sceneShare.warFlyGameScene = nil
//            self.scene!.view?.presentScene(warFlyMenuScene, transition: transition)
//        } else if node.name == GameName.CarRace.rawValue {
//            let transition = SKTransition.crossFade(withDuration: 1.0)
//            let carRaceMenuScene = CarRaceMenuScene(size: self.size)
//            carRaceMenuScene.backScene = self
//            carRaceMenuScene.scaleMode = .aspectFill
//            sceneShare.carRaceGameScene = nil
//            self.scene!.view?.presentScene(carRaceMenuScene, transition: transition)
//        } else if node.name == GameName.AngelicaFighti.rawValue {
//            let transition = SKTransition.crossFade(withDuration: 1.0)
//            let angelicaFightiMenuScene = AngelicaFightiMenuScene(size: self.size)
//            angelicaFightiMenuScene.backScene = self
//            angelicaFightiMenuScene.scaleMode = .aspectFill
//            sceneShare.angelicaFightiGameScene = nil
//            self.scene!.view?.presentScene(angelicaFightiMenuScene, transition: transition)
        } else if node.name == GameName.WayBackHome.rawValue {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let wayBackHomeMenuScene = WayBackHomeMenuScene(size: self.size)
            wayBackHomeMenuScene.backScene = self
            wayBackHomeMenuScene.scaleMode = .aspectFill
            sceneShare.wayBackHomeGameScene = nil
            self.scene!.view?.presentScene(wayBackHomeMenuScene, transition: transition)
        } else if node.name == GameName.FloatBall.rawValue {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let floatBallMenuScene = FloatBallMenuScene(size: self.size)
            floatBallMenuScene.backScene = self
            floatBallMenuScene.scaleMode = .aspectFill
            sceneShare.floatBallGameScene = nil
            self.scene!.view?.presentScene(floatBallMenuScene, transition: transition)
        } else if node.name == GameName.BloomBall.rawValue {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let bloomBallMenuScene = BloomBallMenuScene(size: self.size)
            bloomBallMenuScene.backScene = self
            bloomBallMenuScene.scaleMode = .aspectFill
            sceneShare.bloomBallGameScene = nil
            self.scene!.view?.presentScene(bloomBallMenuScene, transition: transition)
        } else if node.name == GameName.GrabNumber.rawValue {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let grabNumberMenuScene = GrabNumberMenuScene(size: self.size)
            grabNumberMenuScene.backScene = self
            grabNumberMenuScene.scaleMode = .aspectFill
            sceneShare.grabNumberGameScene = nil
            self.scene!.view?.presentScene(grabNumberMenuScene, transition: transition)
        } else if node.name == "options" {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let optionScene = OptionsScene(size: self.size)
            optionScene.backScene = self
            optionScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(optionScene, transition: transition)
        }
        
    }

}
