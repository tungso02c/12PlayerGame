//
//  ButtonNode.swift
//  12Players
//
//  Created by Lê Thị Minh Thảo on 31/01/2023.
//

import SpriteKit

class ButtonNode: SKSpriteNode {
    var screenScale = UIDevice.current.userInterfaceIdiom == .pad ? 1.0 : 0.6
    let label: SKLabelNode = {
        let l = SKLabelNode(text: "")
        l.fontColor = UIColor(red: 219 / 255, green: 226 / 255, blue: 215 / 255, alpha: 1.0)
        l.fontName = "AmericanTypewriter-Bold"
        l.horizontalAlignmentMode = .center
        l.verticalAlignmentMode = .center
        l.zPosition = 2
        
        return l
    }()
    
    init(titled title: String?, backgroundName: String) {

        let texture = SKTexture(imageNamed: backgroundName)
        super.init(texture: texture, color: .clear, size: CGSize(width: texture.size().width * screenScale, height: texture.size().height * screenScale))
        if let title = title {
            label.text = title.uppercased()
        }
        label.fontSize = 30 * screenScale
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
