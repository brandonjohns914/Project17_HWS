//
//  GameScene.swift
//  Project17
//
//  Created by Brandon Johns on 5/5/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate                                                                      //SKpyhicscontactDelegate is required to set it to self
{
    
    var starfield: SKEmitterNode!                                                                                           //background
    var player: SKSpriteNode!
    
    var possibleEnemies = ["ball", "hammer", "tv"]                                                                          //Assests
    
    var gameTimer : Timer?
    
    var isGameOver = false
    
    var scoreLabel: SKLabelNode!
    var score = 0
    {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }//didset
    }//score
    
    
    
    
    override func didMove(to view: SKView)
    {
        
        backgroundColor = .black                                                                                    //setting background to black
        
        starfield = SKEmitterNode(fileNamed: "starfield")!                                                          //skEmitterNode file
        starfield.position = CGPoint(x: 1024, y: 384)                                                               // stars flow in right edge of screen halfway up
                                                                                                                    // right -> left
        starfield.advanceSimulationTime(10)                                                                         // make 10 seconds for star buffer before it even starts
        addChild(starfield)
        starfield.zPosition = -1                                                                                    //back
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)                                                                   // 100 in left half way up 384
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)                             // texture: picture inside sprite
                                                                                                                    // player.texture is player
        
        player.physicsBody?.contactTestBitMask = 1                                                                  // which contacts things its collides with
        addChild(player)
        
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)                                                                 // bottom left
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)                                                               // gravity is disabled
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
                                                                                                                    //timeInterveral = enemies every 0.35 sec
                                                                                                                    // repeats: true = repeating the whole game
        
        
        
    }//didMove
    
    @objc func createEnemy()
    {
        guard let enemy = possibleEnemies.randomElement() else { return }                                           // shuffle enemies exists if not leave
        
        
        
            let sprite = SKSpriteNode(imageNamed: enemy)                                                                // enemy created
            sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))                                             // x:1200 = right side of screen
            // y: range up and down of the screen
            addChild(sprite)
            
            sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)                             //
            sprite.physicsBody?.categoryBitMask = 1                                                                     // collide with player
            sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)                                                    // speed to the left
            
            sprite.physicsBody?.angularVelocity = 5                                                                     //spin through the air
            sprite.physicsBody?.linearDamping = 0                                                                       // how fast things slow down
            // never slow down
            sprite.physicsBody?.angularDamping = 0// never stop spinning
            
            
        
        
    }
    override func update(_ currentTime: TimeInterval)
    {
        
        for node in children
        {
            if node.position.x < -300                                                                               // node off screen
            {
                node.removeFromParent()                                                                            // delete node enemies
            }//if
        }//for
        
        if !isGameOver
        {
            score += 1                                                                                            // running score as long as its not over
        }//if
        
    }//update
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch = touches.first else { return }                                                                 // player touch
        
        var location = touch.location(in: self)                                                                         //touches in the view

        if location.y < 100                                                                                             // near bottom of screen
        {
            location.y = 100                                                                                            // cannot go below 100
        }//if
        else if location.y > 668                                                                                        // high cant go any higher
        {
            location.y = 668
        }//else if

        player.position = location                                                                                      // whever the player moves the player
    }//touchesMoved
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if children.contains(player)
        {
            stopTheGame()
        }
        else{return}
        
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact)
    {
       stopTheGame()
    }//didBegin
   
    func stopTheGame()
    {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position                                                                                // explosion after collison at position
        addChild(explosion)

        player.removeFromParent()                                                                                                   // remove player form node

        isGameOver = true                                                                                               // ends game
        
        gameTimer?.invalidate()
    }
} //GameScene
