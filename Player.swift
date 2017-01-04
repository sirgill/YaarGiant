//
//  Player.swift
//  YaarGiant
//
//  Created by Surinder Singh Gill on 1/3/17.
//  Copyright © 2017 Surinder Singh Gill. All rights reserved.
//

import SpriteKit

struct ColliderType {
    static let PLAYER: UInt32 = 0;
    static let CLOUD: UInt32 = 1;
    static let DARK_CLOUD_AND_COLLECTABLES: UInt32 = 2;
}

class Player: SKSpriteNode {
    
    private var playerIdle = SKTexture(imageNamed: "Player 1");
    private var textureAtlas = SKTextureAtlas();
    private var playerAnimation = [SKTexture]();
    private var animatePlayerAction = SKAction();
    private let ANIMATION_KEY = "Animate";
    
    var lastY = CGFloat();
    
    func initializePlayerAndAnimations() {
        textureAtlas = SKTextureAtlas(named: "Player.atlas");
        
        for i in 2...textureAtlas.textureNames.count {
            let name = "Player \(i)";
            playerAnimation.append(SKTexture(imageNamed: name));
        }
        
        // resize means that it will resize all textures depending on the playres size, restore means it will restore the player back to his original animation when the animation finishes
        animatePlayerAction = SKAction.animate(with: playerAnimation, timePerFrame: 0.08, resize: true, restore: false);
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width - 50, height: self.size.height - 5));
        self.physicsBody?.affectedByGravity = true;
        self.physicsBody?.allowsRotation = false;
        self.physicsBody?.restitution = 0;
        self.physicsBody?.categoryBitMask = ColliderType.PLAYER;
        self.physicsBody?.collisionBitMask = ColliderType.CLOUD;
        self.physicsBody?.contactTestBitMask = ColliderType.DARK_CLOUD_AND_COLLECTABLES;
        
        lastY = self.position.y;
        
    }
    
    func animatePlayer(moveLeft: Bool) {
        
        if moveLeft {
            self.xScale = -fabs(self.xScale);
        } else {
            self.xScale = fabs(self.xScale);
        }
        
        self.run(SKAction.repeatForever(animatePlayerAction), withKey: ANIMATION_KEY);
    }
    
    func stopPlayerAnimation() {
        self.removeAction(forKey: ANIMATION_KEY);
        self.texture = playerIdle;
        self.size = self.texture!.size();
    }
    
    func move(toLeft: Bool) {
        if toLeft {
            self.position.x -= 7;
        } else {
            self.position.x += 7;
        }
    }
    
    func setScore() {
        if self.position.y < lastY {
            GameplayController.instance.incrementScore();
            lastY = self.position.y;
        }
    }
    
}
