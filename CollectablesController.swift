//
//  CollectablesController.swift
//  YaarGiant
//
//  Created by Surinder Singh Gill on 1/3/17.
//  Copyright © 2017 Surinder Singh Gill. All rights reserved.
//

import SpriteKit

class CollectablesController {
    
    func getCollectable() -> SKSpriteNode {
        var collectable = SKSpriteNode();
        
        if Int(randomBetweenNumbers(firstNum: 0, secondNum: 7)) >= 4 {
            
            if GameplayController.instance.life < 2 {
                collectable = SKSpriteNode(imageNamed: "Life");
                collectable.name = "Life";
                collectable.physicsBody = SKPhysicsBody(rectangleOf: collectable.size);
            } else {
                collectable.name = "Empty";
            }
            
        } else {
            
            collectable = SKSpriteNode(imageNamed: "Coin");
            collectable.name = "Coin";
            collectable.physicsBody = SKPhysicsBody(circleOfRadius: collectable.size.height / 2);
        }
        
        collectable.physicsBody?.affectedByGravity = false;
        collectable.physicsBody?.categoryBitMask = ColliderType.DARK_CLOUD_AND_COLLECTABLES;
        collectable.physicsBody?.collisionBitMask = ColliderType.PLAYER;
        collectable.zPosition = 2;
        
        return collectable;
    }
    
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum);
    }
    
}
