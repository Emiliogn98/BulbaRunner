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
    var resetIntructions: SKLabelNode!
    var score = 0 as Int
    // sonidos
    
    //sprites
    var bulbaSprite: SKSpriteNode!
    //spawn
    var spawnRate = 1.5 as Double //tiempo de respawn
    var timeSinceLastSpawn = 0.0 as Double
    //  generis vars
    var groundHeight: CGFloat?
    //consts
    let foreground = 1 as CGFloat // cgfloat nos ayuda con los puntos flotantes para varios tipos de sistemas
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
        //cactus
        cactusNode = SKNode()
        cactusNode.zPosition = foreground
        //bulba
        bulbaNode = SKNode()
        bulbaNode.zPosition = foreground
        // crear metodo para crear bulba
        
    }
    
    // Metodos
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       if(gameNode.speed < 1.0){
           //resetGame()
           return
       }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    func resetGame(){
        gameNode.speed = 1.0
        
    }
    func createBulba(){
        let screenWidth = self.frame.size.width
        let bulbaScale = 4.0 as CGFloat
        
        //texturas
        let bulbaTexture1 = SKTexture(imageNamed: "BulbaRunner/Assets/bulba2")
        let bulbaTexture2 = SKTexture(imageNamed: "BulbaRunner/Assets/bulba")
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
       // bulbaYPosition = getGroundHeight() + bulbaTexture1.size().height * bulbaScale
        
     //   bulbaSprite.position = CGPoint(x: screenWidth * 0.15 , y: bulbaYPosition!)
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
           let cactusTextures = ["cactus",]
           let cactusScale = 3.0 as CGFloat
           
           //texture
           let cactusTexture = SKTexture(imageNamed: "BulbaRunner.assets/cactus" + cactusTextures.randomElement()!)
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
    
 //class
}
