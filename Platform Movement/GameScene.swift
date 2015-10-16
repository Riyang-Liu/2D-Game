//
//  GameScene.swift
//  Platform Movement
//
//  Created by Riyang Liu on 10/11/15.
//  Copyright (c) 2015 Computer Programming Club. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    
    var eve:UIEvent!
    let jump = SKSpriteNode(imageNamed: "jump")
    let rightControl = SKSpriteNode(imageNamed: "rightControl")
    let leftControl = SKSpriteNode(imageNamed: "leftControl")
    let ground = SKSpriteNode(imageNamed: "groundPlaceHolder")
    var man = SKSpriteNode(texture: SKTexture(imageNamed: "run_0"))
    var manBaseline = CGFloat(0)

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
    
    
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.leftControl.position = CGPointMake(CGRectGetMinX(self.frame) + (self.leftControl.size.width), (CGRectGetMidY(self.frame) - (self.leftControl.size.height * 2)))
        addChild(self.leftControl)
        
        self.jump.position = CGPointMake(CGRectGetMaxX(self.frame) - (self.jump.size.width * 2), (CGRectGetMidY(self.frame) - (self.leftControl.size.height * 2)))
        addChild(self.jump)
        
        self.rightControl.position = CGPointMake(CGRectGetMinX(self.frame) + (self.leftControl.size.width * 2), (CGRectGetMidY(self.frame) - (self.leftControl.size.height * 2)))
        addChild(self.rightControl)
        
        stageMaxRight = self.size.width / 2
        stageMaxLeft = -stageMaxRight
        loadManTextures()
        self.man.name = "man"

        self.backgroundColor = UIColor.whiteColor()
        self.ground.anchorPoint = CGPointMake(0, 0.5)
        self.ground.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) + (self.ground.size.height * 3 ))
        
        self.manBaseline = self.ground.position.y + (self.ground.size.height / 2 ) + (self.man.size.height/2)
        self.man.position = CGPointMake(CGRectGetMinX(self.frame) + (self.man.size.width * 2 ), self.manBaseline)
        
        self.man.zPosition = self.ground.zPosition + 1
        
        
        self.addChild(man)
        self.addChild(self.ground)
        
        
        
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
                    
                    }
        
            if self.nodeAtPoint(location) == self.rightControl {
                moveMan("right")
                
                isMoving = true
                
                }
                
            if self.nodeAtPoint(location) == self.jump {
                        if self.onGround {
                        self.velocityY = -16.0
                        self.onGround = false
                            
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
    
    override func update(currentTime: CFTimeInterval) {
        
        self.velocityY += self.gravity
        self.man.position.y -= velocityY
       
        updateManPosition()
        
        
            if self.man.position.y < self.manBaseline {
            self.man.position.y = self.manBaseline
            velocityY = 0.0
            self.man.zRotation = 0
            self.onGround = true
        }
    }

}
