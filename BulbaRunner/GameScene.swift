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
    
    //consts
    // objetos de colision
    
    //lo que sucede cuando nos movemos en la scena
    override func didMove(to view: SKView) {
        
        
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
    
 //class
}
