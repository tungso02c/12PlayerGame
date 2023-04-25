//
//  ParentScene.swift
//  12Players
//
//  Created by Lê Thị Minh Thảo on 31/01/2023.
//

import SpriteKit

class ParentScene: SKScene {
    enum NumberPlayer {
        case OnePlayer
        case TwoPlayer
    }
    enum GameName :String, CaseIterable {
//        case Menu = "Menu"
//        case AngelicaFighti = "Angelica Fight"
        case BloomBall = "Bloom Ball"
//        case CarRace = "Car Race"
        case CrashPlane = "Crash Plane"
        case FloatBall = "Float Ball"
        case GrabNumber = "Grab Number"
//        case WarFly = "War Fly"
        case WayBackHome = "Way Back Home"
    }
    var level = 1
    var numberPlayer = NumberPlayer.OnePlayer
    let gameSettings = GameSettings()
    let sceneShare = ShareScene.shared
    var backScene: SKScene?
    var gameName = GameName.WayBackHome
    var screenScale = UIDevice.current.userInterfaceIdiom == .pad ? 1.0 : 0.6
    var isNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return self.view!.safeAreaInsets.bottom > 20
        }
        return false
    }
    var pScore1st = 0
    var pScore2nd = 0
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.3, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setHeader(withName name: String?, andBackground backgroundName: String ,width: Double , position: CGPoint) {
        let header = ButtonNode(titled: name, backgroundName: backgroundName)
        header.size.width = width
        header.position = position
        header.label.fontColor = .cyan
        self.addChild(header)
    }
    
    func setScorePanel(withName name: String?, andBackground backgroundName: String ,width: Double , position :CGPoint) {
        let panel = ButtonNode(titled: name, backgroundName: backgroundName)
        panel.size.width = width
        panel.position = position
        panel.label.fontColor = .lightText
        panel.label.fontSize = panel.label.fontSize * screenScale
        self.addChild(panel)
    }
    func getNotch() -> Double {
        if (isNotch) {
            return 0.95
        } else {
            return 1.0
        }
    }
}

