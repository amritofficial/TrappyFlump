//
//  GameScene.swift
//  Trappy Flump
//  Amrit Pal Singh
//

import SpriteKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var score = 0
    // boolean value to end or start the game
    var gameOver = false
    // to display the score on the top of the screen
    var scoreLabel = SKLabelNode()
    // no longer in use but still in the code
    // replaced with the buttons
    var gameoverLabel = SKLabelNode()
    // The main game character of the game
    var trump = SKSpriteNode()
    // Used for the background
    var bg = SKSpriteNode()
    // Needed to create Brick Pipe
    var pipe1 = SKSpriteNode()
        var pipe2 = SKSpriteNode()
        // Acts as a container to add all the moving object
    var movingObjects = SKSpriteNode()
    // Container to hold the buttons and label if implemented
    var labelContainer = SKSpriteNode()
    
    var startButton = SKSpriteNode(imageNamed: "play.png")
    var startBackground = SKSpriteNode(imageNamed: "bg2.png")
    
    enum ColliderType: UInt32 {
        case trump = 1
        case Object = 2
        case Gap = 4
    }
    
    // Runs the for loop for the background image
    func makebg() {
        let bgTexture = SKTexture(imageNamed: "bg2.png")
        
        let movebg = SKAction.moveBy(x: -bgTexture.size().width, y: 0, duration: 9)
        let replacebg = SKAction.moveBy(x: bgTexture.size().width, y: 0, duration: 0)
        // the replace function in a simple way returns the same background giving an impression
        // of never ended background
        let movebgForever = SKAction.repeatForever(SKAction.sequence([movebg, replacebg]))
        
        // the standardized background configuration
        for i in 0..<3 {
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * CGFloat(i), y: self.frame.midY)
            bg.size.height = self.frame.height
            bg.zPosition = -5
            bg.run(movebgForever)
            movingObjects.addChild(bg)
        }

    }
    
    // the very first method that is executed and initializes all the needed
    // objects and variables
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.startBackground.position = CGPoint(x: self.size.width / 2, y: self.startBackground.size.height - 120)
        self.startBackground.size = self.size
//        self.startBackground.setScale(2.0)
        self.addChild(movingObjects)
        self.addChild(labelContainer)
        startButton.position = CGPoint(x :self.frame.midX, y: self.frame.midY)
        startButton.name = "start"
         self.addChild(startBackground)
        self.addChild(startButton)
       
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let button = SKSpriteNode(imageNamed: "restart.png")
        let aboutButton = SKSpriteNode(imageNamed: "location.png")
        
        if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue {
            
            score = score + 1
            scoreLabel.text = String(score)
        } else {
            if gameOver == false {
                gameOver = true
                self.speed = 0
                gameoverLabel.fontName = "Helvetica"
                gameoverLabel.fontSize = 30
                gameoverLabel.text = "Game Over! Tap to play again."
                gameoverLabel.position = CGPoint(x :self.frame.midX, y: self.frame.midY)
                button.position = CGPoint(x :self.frame.midX, y: self.frame.midY)
                button.name = "restart"
                labelContainer.addChild(button)
                aboutButton.name = "about"
                aboutButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 120 )
                aboutButton.zPosition = 2.0
                labelContainer.addChild(aboutButton)
            }
        }
        
    }
    
    // the function that starts the game on button click
    func startGame() {
        makebg()
        
        // just default configuration of the score label to make it look cool
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x:self.frame.midX, y:self.frame.size.height - 70)
        self.addChild(scoreLabel)
        
        // Flappy trump animation
        // the image is replaced one by one with 5 different images
        // the trump{0}.png is just a bigger resolution but it wasn't implemented
        // because the sprites didn't move
        let trumpTexture = SKTexture(imageNamed: "tbird1.png")
        trumpTexture.filteringMode = .nearest
        let trumpTexture2 = SKTexture(imageNamed: "tbird2.png")
        trumpTexture2.filteringMode = .nearest
        let trumpTexture3 = SKTexture(imageNamed: "tbird3.png")
        trumpTexture2.filteringMode = .nearest
        let trumpTexture4 = SKTexture(imageNamed: "tbird4.png")
        trumpTexture2.filteringMode = .nearest
        let trumpTexture5 = SKTexture(imageNamed: "tbird5.png")
        trumpTexture2.filteringMode = .nearest
        
        // create the animation of the five images
        let animation = SKAction.animate(with: [trumpTexture, trumpTexture2, trumpTexture3, trumpTexture4, trumpTexture5], timePerFrame: 0.1)
        // repeat the animation forever
        let maketrumpFlap = SKAction.repeatForever(animation)
        
        trump = SKSpriteNode(texture: trumpTexture)
        let trumpRect = CGRect(x: 50, y: 50, width: self.frame.width, height: self.frame.height)
        trump.position = CGPoint(x: trumpRect.midX, y: trumpRect.midY)
        trump.setScale(1.5)
        trump.run(maketrumpFlap)
        
        // the physics provide all the collision handling with the pipes
        trump.physicsBody = SKPhysicsBody(circleOfRadius: trumpTexture.size().height/2)
        trump.physicsBody!.isDynamic = true
        trump.physicsBody?.allowsRotation = false
        trump.physicsBody?.affectedByGravity = true
        trump.physicsBody!.categoryBitMask = ColliderType.trump.rawValue
        trump.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        trump.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        //added allowRotation property and set to false - to disable the effect of rotation when collides with a pipe
        trump.physicsBody!.allowsRotation = false
        
        self.addChild(trump)
        
        let ground = SKNode()
        ground.position = CGPoint(x: 0, y: 0)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: 1))
        
        ground.physicsBody!.isDynamic = false
        ground.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(ground)
        
        _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(GameScene.makePipes), userInfo: nil, repeats: true)
    }
    
    // function used to randomly generate pipes
    @objc
    func makePipes() {
        
        let gapHeight = trump.size.height * 4
        let movementAmount = arc4random() % UInt32(self.frame.size.height / 2)
        let pipeOffset = CGFloat(movementAmount) - self.frame.size.height / 4
        let movePipes = SKAction.moveBy(x: -self.frame.size.width * 2, y: 0, duration: TimeInterval(self.frame.size.width / 100))
        let removePipes = SKAction.removeFromParent()
        let moveAndRemovePipes = SKAction.sequence([movePipes, removePipes])
        
        //changed pipeTexture and pipe1 from var to let
        let pipeTexture = SKTexture(imageNamed: "pipe1brick.png")
        let pipe1 = SKSpriteNode(texture: pipeTexture)
        pipe1.position = CGPoint(x: self.frame.midX + self.frame.size.width, y: self.frame.midY + pipeTexture.size().height/2 + gapHeight / 2 + pipeOffset)
        pipe1.run(moveAndRemovePipes)
        
        pipe1.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        pipe1.physicsBody!.isDynamic = false
        
        pipe1.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        pipe1.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        pipe1.physicsBody!.collisionBitMask = ColliderType.Object.rawValue

        
        movingObjects.addChild(pipe1)
        
        //changed pipe2Texture and pipe2 from var to let
        let pipe2Texture = SKTexture(imageNamed: "pipe2brick.png")
        let pipe2 = SKSpriteNode(texture: pipe2Texture)
        pipe2.position = CGPoint(x: self.frame.midX + self.frame.size.width, y: self.frame.midY - pipe2Texture.size().height/2 - gapHeight / 2 + pipeOffset)
        pipe2.run(moveAndRemovePipes)
        
        pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        pipe2.physicsBody!.isDynamic = false
        
        pipe2.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        movingObjects.addChild(pipe2)
        
        //changed gap variable from var to let
        let gap = SKNode()
        gap.position = CGPoint(x: self.frame.midX + self.frame.size.width, y: self.frame.midY + pipeOffset)
        gap.run(moveAndRemovePipes)
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipe1.size.width, height: gapHeight))
        gap.physicsBody!.isDynamic = false
        
        gap.physicsBody!.categoryBitMask = ColliderType.Gap.rawValue
        gap.physicsBody!.contactTestBitMask = ColliderType.trump.rawValue
        gap.physicsBody!.collisionBitMask = ColliderType.Gap.rawValue
        
        movingObjects.addChild(gap)
        
    }

    
//    func didBeginContact(contact: SKPhysicsContact) {
//
//        if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue {
//
//            score = score + 1
//            scoreLabel.text = String(score)
//        } else {
//            if gameOver == false {
//                gameOver = true
//                self.speed = 0
//                gameoverLabel.fontName = "Helvetica"
//                gameoverLabel.fontSize = 30
//                gameoverLabel.text = "Game Over! Tap to play again."
//                gameoverLabel.position = CGPoint(x :self.frame.midX, y: self.frame.midY)
//                labelContainer.addChild(gameoverLabel)
//            }
//        }
//    }
    
    // touches began is a system function that lets the user perform a function
    // based upon the type of button node that we created
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch == touches.first {
                if gameOver == false {
                    
                    enumerateChildNodes(withName: "//*", using: {(node, stop) in
                        if node.name == "start" {
                            if node.contains(touch.location(in:self)) {
                                print("start")
                                self.startGame()
                                self.removeChildren(in: [self.startButton, self.startBackground])
                                self.trump.physicsBody!.velocity = CGVector(dx: 0, dy:0)
                                self.trump.physicsBody!.applyImpulse(CGVector(dx: 0, dy:50))
                            }
                        }
                    })

                    self.trump.physicsBody!.velocity = CGVector(dx: 0, dy:0)
                    self.trump.physicsBody!.applyImpulse(CGVector(dx: 0, dy:50))
                
                } else {
        //            score = 0
        //            scoreLabel.text = "0"
        //            trump.position = CGPoint(x: self.frame.midX, y:self.frame.midY)
        //            trump.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
        //            movingObjects.removeAllChildren()
        //            makebg()
        //            self.speed = 1
        //            gameOver = false
        //            labelContainer.removeAllChildren()
                    
                    enumerateChildNodes(withName: "//*", using: {(node, stop) in
                        if node.name == "about" {
                            if node.contains(touch.location(in:self)) {
                                 print("about")
                                let scene:SKScene = MapSceneKit(size: self.size)
                                                    
                                self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.5))
                            }
                        }
                        else if node.name == "restart" {
                            if node.contains(touch.location(in:self)) {
                                print("restart")
                                self.score = 0
                                self.scoreLabel.text = "0"
                                self.trump.position = CGPoint(x: self.frame.midX, y:self.frame.midY)
                                self.trump.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
                                self.movingObjects.removeAllChildren()
                                self.makebg()
                                self.speed = 1
                                self.gameOver = false
                                self.labelContainer.removeAllChildren()
                            }
                            
                        }
                    })
        //            labelContainer.removeAllChildren()
                }
            }
        } // end for loop
    }
   
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
