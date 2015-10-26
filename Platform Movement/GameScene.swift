//
//  GameScene.swift
//  Platform Movement
//
//  Created by Riyang Liu on 10/11/15.
//  Copyright (c) 2015 Computer Programming Club. All rights reserved.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var eve:UIEvent!
    let jump = SKSpriteNode(imageNamed: "jump")
    let rightControl = SKSpriteNode(imageNamed: "rightControl")
    let leftControl = SKSpriteNode(imageNamed: "leftControl")
    let basicAttack = SKSpriteNode(imageNamed: "basicAttack")
    let ground = SKSpriteNode(imageNamed: "groundPlaceHolder2")
    var man = SKSpriteNode(texture: SKTexture(imageNamed: "run_0"))
    var manBaseline = CGFloat(0)

    var bullet1 = SKSpriteNode(imageNamed: "bullet1")
    var bullet1IsOn = false
    var bullet1Speed = 30
    var watchAttack = SKSpriteNode(imageNamed: "watchAttackRemain1")
    var watchAttack0 = SKSpriteNode(imageNamed: "watchAttackRemain0")
    var watchBomb = SKSpriteNode(imageNamed: "watch")
    var watchBombIsOn = false
    var watchBombVelocityX = CGFloat(0)
    var watchBombVelocityY = CGFloat(0)
    

    var onGround = true
    var velocityY = CGFloat(0)
    var velocityX = CGFloat(0)
    let gravity = CGFloat(0.6)
    var isMoving = false
    
    
    var manSpeed = 2
    var runningManTextures = [SKTexture]()
    var stageMaxLeft:CGFloat = 0
    var stageMaxRight:CGFloat = 0
    var manLeft = false
    var manLeftSpeed = 0
    var manRight = false
    var IsManRight = true
    
    enum ColliderType:UInt32 {
        
        case man = 1
        case Bomb = 2
    }
    
    

    
    
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.physicsWorld.contactDelegate = self
        
        self.leftControl.position = CGPointMake(CGRectGetMinX(self.frame) + (self.leftControl.size.width), (CGRectGetMidY(self.frame) - (self.leftControl.size.height * 2.2)))
        addChild(self.leftControl)
        
        self.rightControl.position = CGPointMake(CGRectGetMinX(self.frame) + (self.leftControl.size.width * 2), (CGRectGetMidY(self.frame) - (self.leftControl.size.height * 2.2)))
        addChild(self.rightControl)
        
        self.jump.position = CGPointMake(CGRectGetMaxX(self.frame) - (self.jump.size.width * 2), (CGRectGetMidY(self.frame) - (self.leftControl.size.height * 2.2)))
        addChild(self.jump)
        
        self.basicAttack.position = CGPointMake(CGRectGetMaxX(self.frame) - (self.basicAttack.size.width * 4), (CGRectGetMidY(self.frame) - (self.basicAttack.size.height * 2.2)))
        addChild(self.basicAttack)
        
        
        self.watchAttack.position = CGPointMake(CGRectGetMaxX(self.frame) - (self.jump.size.width * 2), (CGRectGetMidY(self.frame) - (self.leftControl.size.height * 2.2) + 60 ))
        addChild(self.watchAttack)
        
        self.watchAttack0.position = CGPointMake(CGRectGetMaxX(self.frame) - (self.jump.size.width * 2), (CGRectGetMidY(self.frame) - (self.leftControl.size.height * 2.2) + 60 ))
        
        
        
        
        
        
        stageMaxRight = self.size.width / 2
        stageMaxLeft = -stageMaxRight
        loadManTextures()
        self.man.name = "man"
        self.watchBomb.name = "watchBomb"

        self.backgroundColor = UIColor.whiteColor()
        self.ground.anchorPoint = CGPointMake(0, 0.5)
        self.ground.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) + (self.ground.size.height * 3 ))
        
        self.manBaseline = self.ground.position.y + (self.ground.size.height / 2 ) + (self.man.size.height/2)
        self.man.position = CGPointMake(CGRectGetMinX(self.frame) + (self.man.size.width * 2 ), self.manBaseline)
        
        self.man.zPosition = self.ground.zPosition + 1
        
        
        self.addChild(man)
        self.addChild(self.ground)
        
        self.leftControl.zPosition = self.ground.zPosition + 1
        self.rightControl.zPosition = self.ground.zPosition + 1
        self.jump.zPosition = self.ground.zPosition + 1
        
        
        
    }
    
    func moveMan(direction:String) {
        if direction == "left" {
            manLeft = true
            man.xScale = -1
            manRight = false
            runMan()
        } else {
            manRight = true
            man.xScale = 1
            manLeft = false
            runMan()
        }
        
    }
    
    func runMan() {
        man.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(runningManTextures, timePerFrame: 0.2, resize:false, restore:true)))
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
            for touch:AnyObject in touches {
                
            let location = touch.locationInNode(self)
                if self.nodeAtPoint(location) == self.leftControl{
                    
                moveMan("left")
                    isMoving = true
                    IsManRight = false
                    
                    }
        
            if self.nodeAtPoint(location) == self.rightControl {
                moveMan("right")
                
                isMoving = true
                IsManRight = true
                
                }
                
            if self.nodeAtPoint(location) == self.jump {
                        if self.onGround {
                        self.velocityY = -16.0
                        self.onGround = false
                            
                        isMoving = true
                    }
                }
                
                if self.nodeAtPoint(location) == self.basicAttack {
                    if bullet1IsOn == false {
                    self.bullet1.position = man.position
                    addChild(self.bullet1)
                    bullet1.zPosition = 2
                    bullet1IsOn = true
                    
                    isMoving = true
                    }
                }
                
                if self.nodeAtPoint(location) == self.watchAttack || self.nodeAtPoint(location) == self.watchAttack0 {
                    
                    if watchBombIsOn == false {
                        watchBombVelocityX = CGFloat(5)
                        watchBombVelocityY = CGFloat(7)
                        self.watchBomb.position.y = man.position.y
                        self.watchBomb.position.x = man.position.x + 40
                        addChild(self.watchBomb)
                        watchBomb.zPosition = 3
                        watchBombIsOn = true
                        self.watchAttack.removeFromParent()
                        /*
                        self.watchAttack = SKSpriteNode(imageNamed: "watchAttackRemain0")
                        self.watchAttack.position = CGPointMake(CGRectGetMaxX(self.frame) - (self.jump.size.width * 2), (CGRectGetMidY(self.frame) - (self.leftControl.size.height * 2.2) + 60 ))*/
                        addChild(self.watchAttack0)
                        isMoving = true
                    }
                }
                
             eve = event
        }
        }
    
    
    
        
    
    
    func cancelMoves() {
        manLeft = false
        manRight = false
        man.removeAllActions()
    }
    
    
    func loadManTextures() {
        let runningAtlas = SKTextureAtlas(named:"run")
        for i in 1...2 {
            let textureName = "run_\(i)"
            let temp = runningAtlas.textureNamed(textureName)
            runningManTextures.append(temp)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if self.velocityY < -8.0 {
            self.velocityY = -8.0
        }
        
        if eve!.allTouches()!.count == 1 {
            
            cancelMoves()
            
        } else {
            
            
        }
        
        if isMoving == true {
            
            
        } else {
            cancelMoves()
        }
        
        isMoving = false
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        
            print("das")
            watchBomb.removeFromParent()
            watchAttack0.removeFromParent()
        /*
            watchAttack = SKSpriteNode(imageNamed: "watchAttackRemain1")
            self.watchAttack.position = CGPointMake(CGRectGetMaxX(self.frame) - (self.jump.size.width * 2), (CGRectGetMidY(self.frame) - (self.leftControl.size.height * 2.2) + 60 ))*/
            addChild(self.watchAttack)
        watchBombIsOn = false
            
        
    }
    
    func updateManPosition() {
        if man.position.x < stageMaxLeft {
            //if nextScreen(currentLevel - 1) {
                man.position.x = stageMaxRight
          //  }
            if manLeft {
                return
            }
        }
        if man.position.x > stageMaxRight {
           // if nextScreen(currentLevel + 1) {
                man.position.x = stageMaxLeft
           // }
            if manRight {
                return
            }
        }
        
        if manLeft {
            man.position.x -= CGFloat(self.manSpeed)
        } else if manRight {
            man.position.x += CGFloat(self.manSpeed)
        }
    }
    
    func updateBullet1Position() {
        
        if IsManRight == true {
            
            self.bullet1.position.x += CGFloat(self.bullet1Speed)
    
            
        } else {
            
            self.bullet1.position.x -= CGFloat(self.bullet1Speed)
            
    
            }

        if bullet1.position.x <= man.position.x - 200 || bullet1.position.x >= man.position.x + 200 {
            
            bullet1.removeFromParent()
            
            bullet1IsOn = false
        }
        
        
    }
    
    func updateWatchBombPosition() {
        
        
        if IsManRight == true {
            
            self.watchBomb.position.x += watchBombVelocityX
            self.watchBomb.position.y += watchBombVelocityY
            self.watchBomb.zRotation += 100
            
        } else {
            
            self.watchBomb.position.x -= watchBombVelocityX
            self.watchBomb.position.y += watchBombVelocityY
            self.watchBomb.zRotation -= 100
        }
        
        if watchBombIsOn == true {
        if watchBomb.position.x <= man.position.x - 100 || watchBomb.position.x >= man.position.x + 100 {
            
            
            
            if IsManRight == true {
                
                self.watchBomb.position.y -= gravity*20
                self.watchBomb.zRotation += 50
                
            } else {
                
                
                self.watchBomb.position.y -= gravity*20
                self.watchBomb.zRotation -= 50
                
            }

            
        }
        }
        
        if watchBombIsOn == true {
        if self.watchBomb.position.y < self.manBaseline {
        self.watchBomb.position.y = self.manBaseline - 10
        watchBombVelocityX = 0.0
        watchBombVelocityY = 0.0
        self.watchBomb.zRotation = 0
        }
            
            

        }
        
       
            
        if watchBomb.position.x < stageMaxLeft {
            
            watchBomb.position.x = stageMaxRight
           
            if manLeft {
                return
            }
        }
        if watchBomb.position.x > stageMaxRight {
            watchBomb.position.x = stageMaxLeft
            
            if manRight {
                return
            }
        }

        
        
            }
    
    override func update(currentTime: CFTimeInterval) {
        
        self.velocityY += self.gravity
        self.man.position.y -= velocityY
       
        updateManPosition()
        updateBullet1Position()
        updateWatchBombPosition()
        
        
            if self.man.position.y < self.manBaseline {
            self.man.position.y = self.manBaseline
            velocityY = 0.0
            self.man.zRotation = 0
            self.onGround = true
                
                if watchBombIsOn == true {
                    man.zPosition = watchBomb.zPosition
                    self.man.physicsBody = SKPhysicsBody(rectangleOfSize: self.man.size)
                    self.man.physicsBody?.affectedByGravity = false
                    self.man.physicsBody?.categoryBitMask = ColliderType.man.rawValue
                    self.man.physicsBody?.contactTestBitMask = ColliderType.Bomb.rawValue
                    self.man.physicsBody?.collisionBitMask = ColliderType.Bomb.rawValue
                    
                    self.watchBomb.physicsBody = SKPhysicsBody(rectangleOfSize: self.watchBomb.size)
                    self.watchBomb.physicsBody?.dynamic = false
                    self.watchBomb.physicsBody?.categoryBitMask = ColliderType.Bomb.rawValue
                    self.watchBomb.physicsBody?.contactTestBitMask = ColliderType.man.rawValue
                    self.watchBomb.physicsBody?.collisionBitMask = ColliderType.man.rawValue
                }

                
                
        
        }
    }

}
