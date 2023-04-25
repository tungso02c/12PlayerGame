//
//  CrashPlaneMenuScene.swift
//  12Players
//
//  Created by Lê Thị Minh Thảo on 31/01/2023.
//

import SpriteKit

class CrashPlaneMenuScene : ParentScene {
    
    override func didMove(to view: SKView) {
        let titles = ["1 PLAYER", "2 PLAYERS", "BACK"]
        setHeader(withName: "Crash Plane", andBackground: "header_background", width: frame.width * 0.6,  position: CGPoint(x: self.frame.midX, y: self.frame.maxY * 0.9))
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
        
        if node.name == "1 PLAYER" {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let crashPlaneGameScene = CrashPlaneGameScene(size: self.size)
            crashPlaneGameScene.backScene = self
            crashPlaneGameScene.numberPlayer = .OnePlayer
            crashPlaneGameScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(crashPlaneGameScene, transition: transition)
        } else if node.name == "2 PLAYERS" {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let crashPlaneGameScene = CrashPlaneGameScene(size: self.size)
            crashPlaneGameScene.backScene = self
            crashPlaneGameScene.numberPlayer = .TwoPlayer
            crashPlaneGameScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(crashPlaneGameScene, transition: transition)
        } else if node.name == "BACK" {
            
            let transition = SKTransition.crossFade(withDuration: 1.0)
            guard let backScene = backScene else { return }
            backScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(backScene, transition: transition)
        }
    }
    
}
