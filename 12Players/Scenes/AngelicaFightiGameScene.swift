//
//  AngelicaFightiGameScene.swift
//  12Players
//
//  Created by Lê Thị Minh Thảo on 02/02/2023.
//

import SpriteKit

let screenSize: CGRect = UIScreen.main.bounds
class AngelicaFightiGameScene:ParentScene, SKPhysicsContactDelegate{
    
//    deinit{
//        print("MainScene is being deInitialized.");
//    }
//   
//    enum Scene{
//        case MainScene
//        case EndScene
//        case Character_Menu
//    }
//    let life1 = SKSpriteNode(imageNamed: "af.life")
//    let life2 = SKSpriteNode(imageNamed: "af.life")
//    let life3 = SKSpriteNode(imageNamed: "af.life")
//    fileprivate var lives = 3 {
//        didSet {
//            switch lives {
//            case 3:
//                life1.isHidden = false
//                life2.isHidden = false
//                life3.isHidden = false
//            case 2:
//                life1.isHidden = false
//                life2.isHidden = false
//                life3.isHidden = true
//            case 1:
//                life1.isHidden = false
//                life2.isHidden = true
//                life3.isHidden = true
//            default:
//                break
//            }
//        }
//    }
////    var gameinfo = GameInfo()
//    var isPlayerMoved:Bool = false
//    private var defaultPlist = NSMutableDictionary()
//    private var clientData = NSMutableDictionary()
//    // get user storage directory
//    let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
//    override func didMove(to view: SKView) {
//        self.scene?.isPaused = false
//        // checking if scene persists
//        guard sceneShare.angelicaFightiGameScene == nil else { return }
////        removeUIViews()
//        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanFrom(recognizer:)))
//        
//        self.view?.addGestureRecognizer(gestureRecognizer)
//        
//        // For Debug Use only
//        view.showsPhysics = false
//        
//        // Setting up delegate for Physics World & Set up gravity
//        physicsWorld.contactDelegate = self
//        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
//        
//        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
//        loadBackground()
//        loadgameinfo()
//        
//    }
//    
//    func load(){
//        // append it with the plist we created
//        let fullPathName = documentDir.appendingPathComponent("userinfo.plist")
//        
//        guard let sourceFilePath = Bundle.main.path(forResource: "userinfo", ofType: "plist") else{
//            print("Critical001:: userinfo.plist is missing. Please, add it to the main path")
//            return
//        }
//        
//        guard let originalPlist = NSMutableDictionary(contentsOfFile:sourceFilePath) else{
//            print("Critical002: Error loading contents of  \(fullPathName)")
//            return
//        }
//        
//        defaultPlist = originalPlist
//        
//        // load the contents into a variable
//        guard let virtualPList = NSMutableDictionary(contentsOfFile: fullPathName) else{
//            
//            let fileManager = FileManager.default
//            
//            if !fileManager.fileExists(atPath: fullPathName){
//                // savingx
//                if !originalPlist.write(toFile: fullPathName, atomically: false){
//                    print("FILE FAILED TO SAVE THE CHANGES ---- PLEASE FIX IT IN ViewController")
//                }
//            }
//            clientData = originalPlist
//            print("[Notice]: OriginalPlist being used.")
//            return
//        }
//        
//        clientData = virtualPList
//        
//        // Bulding up PlistChecker Variable
////        buildPlistChecker()
////        // Client has plist. Checking if client needs to update plist.
////        let (isGoodData, isBackupPossible, msg) = isChecked()
////
////        if isGoodData{
////            redirect(status: .Normal, message: "Success")
////        }
////        else if isBackupPossible{
////            print(msg)
////            redirect(status: .Backup, message: "Updating client's Plist and Performing Restore")
////        }
////        else{
////            print(msg)
////            redirect(status: .Reset, message: "Reseting client's Plist")
////        }
//    }
//    
//    func loadBackground(){
//        
//        createPauseButton()
//        let lifes  = [life1, life2, life3]
//        
//        for (index, life) in lifes.enumerated() {
//            life.position = CGPoint(x: screenSize.width - CGFloat(index + 1) * (life.size.width + 3), y: 20)
//            life.zPosition = 100
//            life.anchorPoint = CGPoint(x: 0.0, y: 0.0)
//            addChild(life)
//        }
//        let bg = SKSpriteNode()
//            bg.texture = SKTexture(imageNamed: "main_menu_background_1")
//            bg.position = CGPoint(x: screenSize.width/2, y: screenSize.height/2)
//            bg.size = CGSize(width: screenSize.width, height: screenSize.height)
//            bg.zPosition = -10
//            bg.name = "main_background_1"
//        self.addChild(bg)
//        
//        let cloud = SKSpriteNode()
//            cloud.texture = SKTexture(imageNamed: "main_menu_background_2")
//            cloud.position = CGPoint(x: screenSize.width/2, y: screenSize.height*0.40)
//            cloud.size = CGSize(width: screenSize.width, height: screenSize.height*3/4)
//            cloud.zPosition = -9
//            cloud.name = "main_background_2"
//        self.addChild(cloud)
//        
//        let cloud2 = SKSpriteNode()
//            cloud2.texture = SKTexture(imageNamed: "main_menu_background_3")
//            cloud2.position = CGPoint(x: -20 + screenSize.width/2, y: 0)
//            cloud2.size = CGSize(width: screenSize.width + 100, height: screenSize.height/2)
//            cloud2.zPosition = -8
//            cloud2.name = "main_background_3"
//        self.addChild(cloud2)
//        
//        let root = SKSpriteNode()
//            root.color = .clear
//            root.name = "main_menu_middle_root"
//            root.size = CGSize(width: screenSize.width, height: screenSize.height*0.7)
//            root.position = CGPoint(x: screenSize.width/2, y: screenSize.height*0.55)
//            root.zPosition = -7
//        self.addChild(root)
//        // note... anchor of root is 0.5, 0.5
//        
//        let bd_one = SKSpriteNode()
//            bd_one.anchorPoint = CGPoint(x: 0.5, y: 1)
//            bd_one.texture = SKTexture(imageNamed: "main_menu_building_1")
//            bd_one.position = CGPoint(x: 0, y: root.size.height/2)
//            bd_one.size = CGSize(width: screenSize.width/2, height: screenSize.height/2)
//            bd_one.name = "main_menu_building_1"
//        root.addChild(bd_one)
//        
//        let bd_one_shade = SKSpriteNode()
//            bd_one_shade.anchorPoint = CGPoint(x: 0.5, y: 1)
//            bd_one_shade.texture = SKTexture(imageNamed: "main_menu_building_1")
//            bd_one_shade.position = CGPoint(x: 0, y: -25)
//            bd_one_shade.size = CGSize(width: screenSize.width/2, height: screenSize.height/2)
//            bd_one_shade.name = "main_menu_building_1_Additional"
//        bd_one.addChild(bd_one_shade)
//        
//        let bd_two = SKSpriteNode()
//            bd_two.anchorPoint = CGPoint(x: 0.5, y: 1)
//            bd_two.texture = SKTexture(imageNamed: "main_menu_building_2")
//            bd_two.position = CGPoint(x: bd_one.size.width/3, y: bd_one.position.y - bd_one.size.height/2)
//            bd_two.size = CGSize(width: screenSize.width/3, height: screenSize.height/3)
//            bd_two.name = "main_menu_building_2"
//        root.addChild(bd_two)
//        
//        let bd_three = SKSpriteNode()
//            bd_three.anchorPoint = CGPoint(x: 0.5, y: 1)
//            bd_three.texture = SKTexture(imageNamed: "main_menu_building_3")
//            bd_three.position = CGPoint(x: -bd_one.size.width/3, y: bd_one.position.y - bd_one.size.height/2)
//            bd_three.size = CGSize(width: screenSize.width/3, height: screenSize.height/3.5)
//            bd_three.name = "main_menu_building_3"
//        root.addChild(bd_three)
//        
//
//        //DRAG TO MOVE
//        let dragtomove = SKSpriteNode()
//            dragtomove.size = CGSize(width: screenSize.width/2, height: screenSize.height/32)
//            dragtomove.position = CGPoint(x: 0, y: -screenSize.height/4)
//            dragtomove.texture = SKTexture(imageNamed: "main_menu_start_game")
//            dragtomove.name = "drag_to_move"
//            root.addChild(dragtomove)
//        
//        // Drag arrow Left
//        let arrowLeft = SKSpriteNode()
//            arrowLeft.size = CGSize(width: dragtomove.size.height, height: dragtomove.size.height*1.2)
//            arrowLeft.position = CGPoint(x: dragtomove.position.x - dragtomove.size.width/2 - 20, y: dragtomove.position.y)
//            arrowLeft.texture = SKTexture(imageNamed: "main_menu_arrow")
//            arrowLeft.name = "main_menu_arrow_left"
//            arrowLeft.zRotation = CGFloat(Double.pi)
//            root.addChild(arrowLeft)
//        
//        // Drag arrow Right
//        let arrowRight = SKSpriteNode()
//            arrowRight.size = CGSize(width: dragtomove.size.height, height: dragtomove.size.height*1.2)
//            arrowRight.position = CGPoint(x: dragtomove.position.x + dragtomove.size.width/2 + 20, y: dragtomove.position.y)
//            arrowRight.texture = SKTexture(imageNamed: "main_menu_arrow")
//            arrowRight.name = "main_menu_arrow_right"
//            root.addChild(arrowRight)
//        
//        // Actions to sprites
//        let buildMove = SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: 0, y: -5, duration: 2.3), SKAction.moveBy(x: 0, y: 5, duration: 1.8)]))
//            bd_one.run(buildMove)
//            bd_two.run(buildMove)
//            bd_three.run(buildMove)
//        
//        cloud2.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: 0, y: 15, duration: 3), SKAction.moveBy(x: 0, y: -15, duration: 3)])))
//        
//        cloud2.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 1.0, duration: 3.5), SKAction.scale(to: 1.1, duration: 3)])))
//        
//        arrowLeft.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: -5, y: 0, duration: 0.3), SKAction.moveBy(x: 5, y: 0, duration: 0.4)])))
//        
//        arrowRight.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: 5, y: 0, duration: 0.3), SKAction.moveBy(x: -5, y: 0, duration: 0.4)])))
//        
//    }
//    
//    private func createPauseButton() {
//        let pause = SKSpriteNode(imageNamed: "pause")
//        pause.size = CGSize(width: frame.width * 0.05, height: frame.height * 0.05)
//        pause.position = CGPoint(x: frame.minX + pause.size.width , y: frame.maxY - pause.size.height * 0.5)
//        pause.zPosition = 10
//        pause.zRotation = .pi * 0.5
//        pause.name = "pause"
//        addChild(pause)
//    }
//   private func loadgameinfo(){
//        // Check if any error from loading gameinfo
//        let check = gameinfo.load(scene: self)
//        
//        if(!check.0){
//            print("LOADING ERROR: ", check.1)
//            return
//        }
//    
//        // Add Character
//        self.addChild(gameinfo.getCurrentToonNode())
//    }
//    
////   private func createUIButton(bname: String, offsetPosX dx:CGFloat, offsetPosY dy:CGFloat) -> SKSpriteNode{
////        let button = SKSpriteNode()
////            button.anchorPoint = CGPoint(x: 0.5, y: 1)
////            button.texture = global.getMainTexture(main: .PurpleButton)
////            button.position = CGPoint(x: dx, y: dy)
////            button.size = CGSize(width: screenSize.width/4, height: screenSize.height/16)
////            button.name = bname
////        return button
////    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let location = touches.first!.location(in: self)
//        let node = self.atPoint(location)
//        if node.name == "pause" {
//            let transition = SKTransition.crossFade(withDuration: 1.0)
//            let pauseScene = PauseScene(size: self.size)
//            pauseScene.sceneShare.angelicaFightiGameScene = self
//            pauseScene.gameName = .AngelicaFighti
//            pauseScene.scaleMode = .aspectFill
//            self.scene?.isPaused = true
//            self.scene!.view?.presentScene(pauseScene, transition: transition)
//        }
//        var pos:CGPoint!
//        for touch in touches{
//            pos = touch.location(in: self)
//        }
//        
//        if isPlayerMoved{
//            // If player has swiped, it will not trigger this function
//            return
//        }
//        let childs = self.nodes(at: pos)
//        for c in childs{
//            if c.name == "character_building_button"{
//                prepareToChangeScene(scene: .Character_Menu)
//            }
//        }
//    }
//    
//    @objc func handlePanFrom(recognizer : UIPanGestureRecognizer) {
//        
//        let toon = gameinfo.getCurrentToon()
//        let player = gameinfo.getCurrentToonNode()
//        
//        if !isPlayerMoved{
//            isPlayerMoved = true
//            gameinfo.changeGameState(.Start)
//        }
//        
//        if recognizer.state == .began {
//            
//        } else if recognizer.state == .changed {
//            let locomotion = recognizer.translation(in: recognizer.view)
//            player.position.x = player.position.x + locomotion.x*2.0
//           // print(locomotion.x)
//                
//                //ceil((locomotion.x * 1.8))
//            
//            //  print (toon.getNode().position)
//            recognizer.setTranslation(CGPoint(x: 0,y: 0), in: self.view)
//            if (player.position.x < 0 ){
//                player.position.x = 0
//            }
//            else if (player.position.x > screenSize.width){
//                player.position.x = screenSize.width
//            }
//            
//            if (locomotion.x < -1){
//                player.run(SKAction.rotate(toAngle: 0.0872665, duration: 0.1))
//            }
//            else if (locomotion.x > 0.5){
//                player.run(SKAction.rotate(toAngle: -0.0872665, duration: 0.1))
//            }
//            else if (locomotion.x == 0.0){
//                player.run(SKAction.rotate(toAngle: 0, duration: 0.1))
//            }
//            
//            toon.updateProjectile()
//            
//            
//        } else if recognizer.state == .ended {
//            player.run(SKAction.rotate(toAngle: 0, duration: 0.1))
//        }
//        else if recognizer.state == .cancelled{
//            print ("FAILED CANCEL")
//        }
//        else if recognizer.state == .failed{
//            print ("FAILED")
//        }
//    }
//
//    func didBegin(_ contact: SKPhysicsContact) {
//        var contactType:ContactType = .None
//        var higherNode:SKSpriteNode?
//        var lowerNode:SKSpriteNode?
//        
//        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask{
//            higherNode = contact.bodyA.node as! SKSpriteNode?
//            lowerNode = contact.bodyB.node as! SKSpriteNode?
//        }
//        else if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
//            higherNode = contact.bodyB.node as! SKSpriteNode?
//            lowerNode = contact.bodyA.node as! SKSpriteNode?
//        }
//        else{
//            return
//        }
//        
//        guard let h_node = higherNode, let l_node = lowerNode else {
//            return
//        }
//        
//        /*
//         POSSIBLE CASES ( lowerNode vs HigherNode ):
//         
//         
//         PLAYER & ENEMY  =  HitByEnemy  -> Description: Enemy hit the player
//         PLAYER & COIN   =  GotCoin     -> Description: Player got money
//         ENEMY  & Projectile = EnemyGotHit -> Description: Enemy hit By the player
//         ALL    & IMUNE  =  Immune
//         
//         NOTE: None < Player < Enemy < Projectile < Currency < Wall < Imune
//         
//         NOTE2: Enemy's projectile are considered as Enemy. Thus, need to ignore when projectile hit enemy attack
//         */
//        
//        if (h_node.physicsBody?.categoryBitMask == PhysicsCategory.Imune){
//            contactType = .Immune
//        }
//            
//        else if (l_node.name! == "Enemy_Regular" || l_node.name! == "Enemy_Boss" ) && h_node.name!.contains("bullet"){
//            contactType = .EnemyGotHit
//        }
//        else if l_node.name! == "toon" && h_node.name! == "coin"{
//            contactType = .PlayerGetCoin
//        }
//            
//        else if l_node.name! == "toon" && h_node.name!.contains("Enemy"){
//            contactType = .HitByEnemy
//        }
//        else if l_node.name!.contains("Enemy") && l_node.name!.contains("Attack") && h_node.name == "bullet"{
//            // Handle case where bullet hit enemy's attack
//            return
//        }
//        
//        contactUpdate(lowNode: l_node, highNode: h_node, contactType: contactType)
//    }
//    
//    func contactUpdate(lowNode: SKSpriteNode, highNode: SKSpriteNode, contactType:ContactType){
//        let regular = gameinfo.regular_enemies
//        let boss = gameinfo.boss
//        
//        switch contactType{
//            
//        case .EnemyGotHit:
//            // Generate FX Effect
//                //converting bullet to mainscene's coordinate
//            let newPos = self.convert(highNode.position, from: highNode.parent!)
//            let effect = gameinfo.getToonBulletEmmiterNode(x: newPos.x, y: newPos.y)
//            self.addChild(effect)
//            // update enemy
//            destroy(sknode: highNode)
//            if lowNode.name!.contains("Regular"){
//                regular.decreaseHP(ofTarget: lowNode, hitBy: highNode)
//            }
//            else if lowNode.name!.contains("Boss"){
//                boss.decreaseHP(ofTarget: lowNode, hitBy: highNode)
//            }
//            else{
//                print("WARNING: Should not reach here. Check contactUpdate in StartGame.swift")
//            }
//           
//            
//        case .HitByEnemy:
//            // particle effect testing
//            lives -= 1
//            if lives == 0 {
//                let hitparticle = SKEmitterNode()
//                hitparticle.particleTexture = global.getMainTexture(main: .Gold)
//                hitparticle.position = lowNode.position
//                hitparticle.particleLifetime = 1
//                hitparticle.particleBirthRate = 10
//                hitparticle.numParticlesToEmit  = 30
//                hitparticle.emissionAngleRange = 180
//                hitparticle.particleScale = 0.2
//                hitparticle.particleScaleSpeed = -0.2
//                hitparticle.particleSpeed = 100
//                self.addChild(hitparticle)
//                
//                lowNode.removeAllActions()
//                lowNode.removeFromParent()
//                highNode.removeAllActions()
//                prepareToChangeScene(scene: .EndScene)
//            }
//        case .Immune:
//            destroy(sknode: lowNode)
//            
//        case .PlayerGetCoin:
//            self.run(self.gameinfo.mainAudio.getAction(type: .Coin))
//            self.gameinfo.addCoin(amount: 1)
//            destroy(sknode: highNode)
//            
//        case .None:
//            break
//        }
//    }
//    
//    func destroy(sknode: SKSpriteNode){
//        sknode.physicsBody?.categoryBitMask = PhysicsCategory.None
//        sknode.removeAllActions()
//        sknode.removeFromParent()
//    }
//    
//    func prepareToChangeScene(scene:Scene){
//        // remove all gestures
//        for gesture in (view?.gestureRecognizers)!{
//            view?.removeGestureRecognizer(gesture)
//        }
//        
//        switch scene {
//        case .EndScene:
//
//            self.gameinfo.prepareToChangeScene()
//            self.recursiveRemovingSKActions(sknodes: self.children)
//            self.removeAllChildren()
//            self.removeAllActions()
//
//            let transition = SKTransition.crossFade(withDuration: 1.0)
//            let gameOverScene = GameOverScene(size: self.size)
//            gameOverScene.numberPlayer = .OnePlayer
//            gameOverScene.gameName = .AngelicaFighti
//            gameOverScene.scaleMode = .aspectFill
//            self.scene!.view?.presentScene(gameOverScene, transition: transition)
//        case .Character_Menu:
//            
//            self.gameinfo.prepareToChangeScene()
//            self.recursiveRemovingSKActions(sknodes: self.children)
//            self.removeAllChildren()
//            self.removeAllActions()
//
//            let newScene = CharacterMenuScene(size: self.size)
//            self.view?.presentScene(newScene)
//        default:
//            print("Should not reach here. PrepareToChangeScene from MainScene")
//        }
//        
//        
//    }
//
//    
}
