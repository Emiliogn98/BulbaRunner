//
//  GameScene.swift
//  BulbaRunner
//
//  Created by MacBookMBA4 on 16/05/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    //variables
    // nodos objetos con posicion en la scena
      var gameNode: SKNode!
      var groundNode: SKNode!
      var backgroundNode: SKNode!
      var cactusNode: SKNode!
      var bulbaNode: SKNode!
      var arbustoNode: SKNode!
      var dulceNode: SKNode!
    
    // score
    var scoreNode : SKLabelNode!
    var resetInstructions: SKLabelNode!
    var score = 0 as Int
    // sonidos
    
    //sprites
    var bulbaSprite: SKSpriteNode!
    //spawn
    var spawnRate = 1.5 as Double //tiempo de respawn
    var timeSinceLastSpawn = 0.0 as Double
    //  generis vars
 
    var groundHeight: CGFloat?
    var bulbaYPosition: CGFloat?
    var groundSpeed = 200 as CGFloat
    //consts
    let foreground = 1 as CGFloat // cgfloat nos ayuda con los puntos flotantes para varios tipos de sistemas
    let background = 0 as CGFloat
    
    // objetos de colision// bitwise left shift operator
    //
    // moves 0 bits to left for 00000001
    let groundCategory = 1 << 0 as UInt32
        let bulbaCategory = 1 << 1 as UInt32
        let cactusCategory = 1 << 2 as UInt32
    // moves 3 bits to left for 00000001 then you have 00001000
        let bushCategory = 1 << 3 as UInt32
    
    //lo que sucede cuando nos movemos en la scena
    override func didMove(to view: SKView) {
        self.backgroundColor = .white
            
            self.physicsWorld.contactDelegate = self
            self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
        
        //ground
             groundNode = SKNode()
             groundNode.zPosition = background
           createAndMoveGround()
            addCollisionToGround()
        
        //background elements
              backgroundNode = SKNode()
              backgroundNode.zPosition = background
              //createMoon()
              //createClouds()
        //cactus
        cactusNode = SKNode()
        cactusNode.zPosition = foreground
        //bulba
        bulbaNode = SKNode()
        bulbaNode.zPosition = foreground
        createBulba()
              
        // crear metodo para crear bulba
        
        //score
               score = 0
               scoreNode = SKLabelNode(fontNamed: "Arial")
               scoreNode.fontSize = 30
               scoreNode.zPosition = foreground
               scoreNode.text = "Score: 0"
               scoreNode.fontColor = SKColor.gray
               scoreNode.position = CGPoint(x: 150, y: 100)
        //reset instructions
               resetInstructions = SKLabelNode(fontNamed: "Arial")
               resetInstructions.fontSize = 50
               resetInstructions.text = "Tap to Restart"
               resetInstructions.fontColor = SKColor.white
               resetInstructions.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
               
        //parent game node
        gameNode = SKNode()
        gameNode.addChild(groundNode)
        gameNode.addChild(backgroundNode)
        gameNode.addChild(bulbaNode)
        gameNode.addChild(cactusNode)
       // gameNode.addChild(birdNode)
        gameNode.addChild(scoreNode)
        gameNode.addChild(resetInstructions)
        self.addChild(gameNode)

     //didmove
    }
    
    // Metodos
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       if(gameNode.speed < 1.0){
           resetGame()
           return
       }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(gameNode.speed > 0){
                 groundSpeed += 0.10
                 
                 score += 1
                 scoreNode.text = "Score: \(score/5)"
                 
                 if(currentTime - timeSinceLastSpawn > spawnRate){
                     timeSinceLastSpawn = currentTime
                     spawnRate = Double.random(in: 1.0 ..< 3.5)
                     
                     if(Int.random(in: 0...10) < 8){
                         spawnCactus()
                     } else {
                        // spawnBird()
                     }
                 }
             }
    }
    func resetGame(){
        gameNode.speed = 1.0
        timeSinceLastSpawn = 0.0
               groundSpeed = 500
               score = 0
               
               cactusNode.removeAllChildren()
              // birdNode.removeAllChildren()
               
               resetInstructions.fontColor = SKColor.white
               
               let bulbaTexture1 = SKTexture(imageNamed: "bulba.png")
               let bulbaTexture2 = SKTexture(imageNamed: "bulba.png")
        bulbaTexture1.filteringMode = .nearest
        bulbaTexture2.filteringMode = .nearest
               
               let runningAnimation = SKAction.animate(with: [bulbaTexture1, bulbaTexture2], timePerFrame: 0.12)
               
               bulbaSprite.position = CGPoint(x: self.frame.size.width * 0.15, y: bulbaYPosition!)
               bulbaSprite.run(SKAction.repeatForever(runningAnimation))
        
    }
    func gameOver() {
            gameNode.speed = 0.0
            
            resetInstructions.fontColor = SKColor.gray
            
            let deadBulbaTexture = SKTexture(imageNamed: "bulba.png")
        deadBulbaTexture.filteringMode = .nearest
            
            bulbaSprite.removeAllActions()
            bulbaSprite.texture = deadBulbaTexture
        }
    func createBulba(){
        let screenWidth = self.frame.size.width
        let bulbaScale = 4.0 as CGFloat
        
        //texturas
        let bulbaTexture1 = SKTexture(imageNamed: "bulba.png")
        let bulbaTexture2 = SKTexture(imageNamed: "bulba.png")
        bulbaTexture1.filteringMode = .nearest
        bulbaTexture2.filteringMode = .nearest
        
        // animacion
        let runningAnimation = SKAction.animate(with: [bulbaTexture1,bulbaTexture2], timePerFrame: 0.12)
        bulbaSprite = SKSpriteNode()
        bulbaSprite.size = bulbaTexture1.size()
        bulbaSprite.setScale(bulbaScale)
        bulbaNode.addChild(bulbaSprite)
        
        let physicsBox = CGSize(width: bulbaTexture1.size().width * bulbaScale, height: bulbaTexture1.size().height * bulbaScale)
        bulbaSprite.physicsBody = SKPhysicsBody(rectangleOf: physicsBox)
        bulbaSprite.physicsBody?.isDynamic = true
        bulbaSprite.physicsBody?.mass = 1.0
        bulbaSprite.physicsBody?.categoryBitMask = bulbaCategory
        bulbaSprite.physicsBody?.contactTestBitMask = cactusCategory | bushCategory
        bulbaSprite.physicsBody?.collisionBitMask = groundCategory
        //metodo groundheit
        bulbaYPosition = getGroundHeight() + bulbaTexture1.size().height * bulbaScale
        
        bulbaSprite.position = CGPoint(x: screenWidth * 0.15 , y: bulbaYPosition!)
        bulbaSprite.run(SKAction.repeatForever(runningAnimation))

    }
    func getGroundHeight() -> CGFloat {
        if let gHeight = groundHeight{
            return gHeight
        } else {
            exit(0)
        }
    }
    func spawnCactus() {
           let cactusTextures = ["bulba"]
           let cactusScale = 3.0 as CGFloat
           
           //texture
           let cactusTexture = SKTexture(imageNamed: "bulba.png" + cactusTextures.randomElement()!)
           cactusTexture.filteringMode = .nearest
           
           //sprite
           let cactusSprite = SKSpriteNode(texture: cactusTexture)
           cactusSprite.setScale(cactusScale)
           
           //physics
           let contactBox = CGSize(width: cactusTexture.size().width * cactusScale,
                                   height: cactusTexture.size().height * cactusScale)
           cactusSprite.physicsBody = SKPhysicsBody(rectangleOf: contactBox)
           cactusSprite.physicsBody?.isDynamic = true
           cactusSprite.physicsBody?.mass = 1.0
          cactusSprite.physicsBody?.categoryBitMask = cactusCategory
           cactusSprite.physicsBody?.contactTestBitMask = bulbaCategory
           cactusSprite.physicsBody?.collisionBitMask = groundCategory
           
           //add to scene
           cactusNode.addChild(cactusSprite)
           //animate
      //  animateCactus(sprite: cactusSprite, texture: cactusTexture)
       }
    func createAndMoveGround() {
            let screenWidth = self.frame.size.width
            
            //ground texture
            let groundTexture = SKTexture(imageNamed: "ground.png")
            groundTexture.filteringMode = .nearest
            
            let homeButtonPadding = 50.0 as CGFloat
            groundHeight = groundTexture.size().height + homeButtonPadding
            
            //ground actions
            let moveGroundLeft = SKAction.moveBy(x: -groundTexture.size().width,
                                                 y: 0.0, duration: TimeInterval(screenWidth / groundSpeed))
            let resetGround = SKAction.moveBy(x: groundTexture.size().width, y: 0.0, duration: 0.0)
            let groundLoop = SKAction.sequence([moveGroundLeft, resetGround])
            
            //ground nodes
            let numberOfGroundNodes = 1 + Int(ceil(screenWidth / groundTexture.size().width))
            
            for i in 0 ..< numberOfGroundNodes {
                let node = SKSpriteNode(texture: groundTexture)
                node.anchorPoint = CGPoint(x: 0.0, y: 0.0)
                node.position = CGPoint(x: CGFloat(i) * groundTexture.size().width, y: groundHeight!)
                groundNode.addChild(node)
                node.run(SKAction.repeatForever(groundLoop))
            }
        }
    
    func addCollisionToGround() {
        let groundContactNode = SKNode()
        groundContactNode.position = CGPoint(x: 0, y: groundHeight! - 30)
        groundContactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width * 3,
                                                                          height: groundHeight!))
        groundContactNode.physicsBody?.friction = 0.0
        groundContactNode.physicsBody?.isDynamic = false
        groundContactNode.physicsBody?.categoryBitMask = groundCategory
        
        groundNode.addChild(groundContactNode)
    }

 //class
}
