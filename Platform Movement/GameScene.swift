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
    var enemy = SKSpriteNode(texture: SKTexture(imageNamed: "enemy_1"))
    var enemyLeft = false
    var enemyRight = false
    var enemyPosition:CGFloat = 0.0
    var runningEnemyTextures = [SKTexture]()

    var bullet1 = SKSpriteNode(imageNamed: "bullet1")
    var bullet1IsOn = false
    var bullet1Speed = 30
    var watchAttack = SKSpriteNode(imageNamed: "watchAttackRemain1")
    var watchAttack0 = SKSpriteNode(imageNamed: "watchAttackRemain0")
    var watchBomb = SKSpriteNode(imageNamed: "watch")
    var watchBombIsOn = false
    var watchBombVelocityX = CGFloat(0)
    var watchBombVelocityY = CGFloat(0)
    
    var door = SKSpriteNode(imageNamed: "door")
    var doorOpen = SKSpriteNode(imageNamed: "doorOpen")
    var button = SKSpriteNode(imageNamed: "button")
    var buttonOn = SKSpriteNode(imageNamed: "button2")
    


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
    
    var elevator = SKSpriteNode(imageNamed: "elevator")
    var elevatorGoUp = false
    var elevatorPosition:CGFloat = 0.0
    
    enum ColliderType:UInt32 {
        
        case man = 1
        case Bomb = 2
        case door = 4
        case button = 8
        case enemy = 16
        case bullet1 = 32
        case buttonOn = 64
        case elevator = 128
        case ground = 256
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
        
        
        //enemyMovement("right")
        
        stageMaxRight = self.size.width / 2
        stageMaxLeft = -stageMaxRight
        loadManTextures()
        loadEnemyTextures()
        self.man.name = "man"
        self.watchBomb.name = "watchBomb"
        self.door.name = "door"
        self.button.name = "button"

        self.backgroundColor = UIColor.whiteColor()
        self.ground.anchorPoint = CGPointMake(0, 0.5)
        self.ground.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) + (self.ground.size.height * 3 ))
        
        self.manBaseline = self.ground.position.y + (self.ground.size.height / 2 ) + (self.man.size.height/2)
        self.man.position = CGPointMake(CGRectGetMinX(self.frame) + (self.man.size.width * 2 ), self.manBaseline)
        self.enemy.position = CGPointMake(CGRectGetMaxX(self.frame) - (self.enemy.size.width * 3 ), self.manBaseline + 15)
        
        self.door.position = CGPointMake(CGRectGetMaxX(self.frame) - (self.door.size.width * 8 ), self.manBaseline + 28)
        
        self.button.position = CGPointMake(CGRectGetMinX(self.frame) + (self.button.size.width - 5 ), self.manBaseline - 22)
        
        self.elevator.position = CGPointMake(CGRectGetMaxX(self.frame) - (self.elevator.size.width ), self.manBaseline - 54)
        
        
        
        addChild(elevator)

        
        self.man.zPosition = self.ground.zPosition + 1
        
        self.addChild(man)
        self.addChild(enemy)
        self.addChild(self.ground)
        self.addChild(door)
        self.addChild(button)
        enemyPosition = self.enemy.position.x
        elevatorPosition = self.elevator.position.y
        
        self.leftControl.zPosition = self.ground.zPosition + 1
        self.rightControl.zPosition = self.ground.zPosition + 1
        self.jump.zPosition = self.ground.zPosition + 1
        self.enemy.zPosition = self.ground.zPosition + 1
        self.man.zPosition = 3
        self.door.zPosition = 4
        self.doorOpen.zPosition = 4
        self.watchBomb.zPosition = 3
        self.button.zPosition = 3
        elevator.zPosition = 5
        
        
        enemyLeft = true
        runEnemy()
        
        
      
       
        self.man.physicsBody = SKPhysicsBody(rectangleOfSize: self.man.size)
        self.man.physicsBody?.affectedByGravity = true
        self.man.physicsBody?.dynamic = true
        self.man.physicsBody?.categoryBitMask = ColliderType.man.rawValue
        self.man.physicsBody?.contactTestBitMask = ColliderType.Bomb.rawValue | ColliderType.door.rawValue | ColliderType.button.rawValue | ColliderType.elevator.rawValue | ColliderType.ground.rawValue
        self.man.physicsBody?.collisionBitMask = ColliderType.Bomb.rawValue | ColliderType.door.rawValue | ColliderType.button.rawValue | ColliderType.elevator.rawValue | ColliderType.ground.rawValue
        
        self.watchBomb.physicsBody = SKPhysicsBody(rectangleOfSize: self.watchBomb.size)
        self.watchBomb.physicsBody?.dynamic = false
        self.watchBomb.physicsBody?.categoryBitMask = ColliderType.Bomb.rawValue
        self.watchBomb.physicsBody?.contactTestBitMask = ColliderType.man.rawValue
        self.watchBomb.physicsBody?.collisionBitMask = ColliderType.man.rawValue
        
        self.door.physicsBody = SKPhysicsBody(rectangleOfSize: self.door.size)
        self.door.physicsBody?.affectedByGravity = false
        self.door.physicsBody?.dynamic = false
        self.door.physicsBody?.categoryBitMask = ColliderType.door.rawValue
        self.door.physicsBody?.contactTestBitMask = ColliderType.man.rawValue
        self.door.physicsBody?.collisionBitMask = ColliderType.man.rawValue
        
        self.button.physicsBody = SKPhysicsBody(rectangleOfSize: self.button.size)
        self.button.physicsBody?.affectedByGravity = false
        self.button.physicsBody?.dynamic = false
        self.button.physicsBody?.categoryBitMask = ColliderType.button.rawValue
        self.button.physicsBody?.contactTestBitMask = ColliderType.man.rawValue
        self.button.physicsBody?.collisionBitMask = ColliderType.man.rawValue
        
        self.bullet1.physicsBody = SKPhysicsBody(rectangleOfSize: self.bullet1.size)
        self.bullet1.physicsBody?.affectedByGravity = false
        self.bullet1.physicsBody?.dynamic = true
        self.bullet1.physicsBody?.categoryBitMask = ColliderType.bullet1.rawValue
        self.bullet1.physicsBody?.contactTestBitMask = ColliderType.enemy.rawValue
        self.bullet1.physicsBody?.collisionBitMask = ColliderType.enemy.rawValue
        
        self.enemy.physicsBody = SKPhysicsBody(rectangleOfSize: self.enemy.size)
        self.enemy.physicsBody?.affectedByGravity = false
        self.enemy.physicsBody?.dynamic = true
        self.enemy.physicsBody?.categoryBitMask = ColliderType.enemy.rawValue
        self.enemy.physicsBody?.contactTestBitMask = ColliderType.bullet1.rawValue
        self.enemy.physicsBody?.collisionBitMask = ColliderType.bullet1.rawValue
        
        self.elevator.physicsBody = SKPhysicsBody(rectangleOfSize: self.elevator.size)
        self.elevator.physicsBody?.affectedByGravity = false
        self.elevator.physicsBody?.dynamic = false
        self.elevator.physicsBody?.categoryBitMask = ColliderType.elevator.rawValue
        self.elevator.physicsBody?.contactTestBitMask = ColliderType.man.rawValue
        self.elevator.physicsBody?.collisionBitMask = ColliderType.man.rawValue

        self.ground.physicsBody = SKPhysicsBody(rectangleOfSize: self.ground.size)
        self.ground.physicsBody?.affectedByGravity = false
        self.ground.physicsBody?.dynamic = false
        self.ground.physicsBody?.categoryBitMask = ColliderType.ground.rawValue
        self.ground.physicsBody?.contactTestBitMask = ColliderType.man.rawValue
        self.ground.physicsBody?.collisionBitMask = ColliderType.man.rawValue
        

        
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
    
    
    /*func enemyMovement(direction:String) {
        if direction == "left" {
            enemyLeft = true
            enemy.xScale = -1
            enemyRight = false
            runEnemy()
        } else {
            enemyRight = true
            enemy.xScale = 1
            enemyLeft = false
            runEnemy()
        }
        
    }*/

    
    func runMan() {
        man.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(runningManTextures, timePerFrame: 0.2, resize:false, restore:true)))
    }
    
    func runEnemy() {
        enemy.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(runningEnemyTextures, timePerFrame: 0.2, resize:false, restore:true)))
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
                
                if self.nodeAtPoint(location) == self.elevator {
                    
                    elevatorGoUp = true
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
    
    func loadEnemyTextures() {
        
        let runningAtlas = SKTextureAtlas(named:"enemy")
        for i in 1...3 {
            
            let textureName = "enemy_\(i)"
            let temp = runningAtlas.textureNamed(textureName)
            runningEnemyTextures.append(temp)
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
    
    func didBeginContact(/*otherBody: SKPhysicsBody,*/contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == ColliderType.man.rawValue || contact.bodyB.categoryBitMask == ColliderType.ground.rawValue {
            
            onGround = true
        }
        
        if contact.bodyA.categoryBitMask == ColliderType.elevator.rawValue || contact.bodyB.categoryBitMask == ColliderType.elevator.rawValue {
            
            print("ele")
            self.man.position.y -= 3.0
            onGround = true
        }
        
        
        if contact.bodyB.categoryBitMask == ColliderType.Bomb.rawValue {
            print("BOMB")
            watchBomb.removeFromParent()
            watchAttack0.removeFromParent()
        /*
            watchAttack = SKSpriteNode(imageNamed: "watchAttackRemain1")
            self.watchAttack.position = CGPointMake(CGRectGetMaxX(self.frame) - (self.jump.size.width * 2), (CGRectGetMidY(self.frame) - (self.leftControl.size.height * 2.2) + 60 ))*/
            addChild(self.watchAttack)
            watchBombIsOn = false
        }
        /*switch(otherBody.categoryBitMask){*/
        if contact.bodyA.categoryBitMask == ColliderType.man.rawValue || contact.bodyB.categoryBitMask == ColliderType.door.rawValue {
            print("door")
        }
        
        if contact.bodyB.categoryBitMask == ColliderType.button.rawValue {
            
            print("button")
            doorOpen.position = door.position
            door.removeFromParent()
            buttonOn.position = button.position
            button.removeFromParent()
            self.addChild(buttonOn)
            self.addChild(doorOpen)
            
        }
        
        if contact.bodyA.categoryBitMask == ColliderType.bullet1.rawValue || contact.bodyB.categoryBitMask == ColliderType.enemy.rawValue {
            
            print("shooting enemy")
            enemy.removeFromParent()
        }
        
        
      
            
        
    
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
        
        if onGround == true {
            
            velocityY = 0
            
        }
        
        if onGround == false {
            
            self.velocityY += self.gravity
            self.man.position.y -= velocityY
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
           
            /*if watchBomb {
                return
            }*/
        }
        if watchBomb.position.x > stageMaxRight {
            watchBomb.position.x = stageMaxLeft
            
            /*if manRight {
                return
            }*/
        }

        
        
            }
    
    /*func updateEnemyPosition() {
        let enemyPosition = self.enemy.position.x
        self.enemy.position.x += 8
        
        if self.enemy.position.x > enemyPosition + 100  {
            
            enemy.position.x = enemyPosition + 100
            
            enemyMovement("left")
            
            if enemyRight {
                
                return
            }
            
        }
        
        if self.enemy.position.x < enemyPosition - 100 {
            
            enemy.position.x = enemyPosition - 100
            
            enemyMovement("right")
            
            if enemyLeft {
                
                return
            }
        }
        
        if enemyLeft {
            enemy.position.x -= CGFloat(self.manSpeed)
        } else if enemyRight {
            enemy.position.x += CGFloat(self.manSpeed)
        }
        
    }*/
    
    func updateEnemyPosition() {
        
        
        
        if enemyLeft == true {
            
            enemy.xScale = 1
            
            
        self.enemy.position.x -= 1
        
        if self.enemy.position.x < enemyPosition - 30  {
            
            self.enemy.position.x = enemyPosition - 30
            
            enemyLeft = false
            enemyRight = true
        }
        }

            if enemyRight == true {
                
                enemy.xScale = -1
                
                
            
            self.enemy.position.x += 1
            
            if self.enemy.position.x > enemyPosition + 30 {
                
                self.enemy.position.x = enemyPosition + 30
                
                enemyRight = false
                enemyLeft = true
                }
        }
    }
    
    func updateElevatorPosition(){
        
        if elevatorGoUp == true {
            
            if self.elevator.position.y < elevatorPosition + 100 {
                
                self.elevator.position.y += 3.0
            }
            
            if self.elevator.position.y == elevatorPosition + 100 {
                
                elevatorGoUp = false
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        
    
       self.man.zRotation = 0
        updateManPosition()
        updateBullet1Position()
        updateWatchBombPosition()
        updateEnemyPosition()
        updateElevatorPosition()
        
        
            /*if self.man.position.y < self.manBaseline {
            self.man.position.y = self.manBaseline
            velocityY = 0.0
            self.man.zRotation = 0
            self.onGround = true*/
                
                /*if watchBombIsOn == true {
                    
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
                }*/

                
                
        
        //}
    }
}

