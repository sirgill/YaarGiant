//
//  BGClass.swift
//  YaarGiant
//
//  Created by Surinder Singh Gill on 1/3/17.
//  Copyright © 2017 Surinder Singh Gill. All rights reserved.
//


import SpriteKit

class BGClass: SKSpriteNode {
    
    func moveBG(camera: SKCameraNode) {
        if self.position.y - self.size.height - 10 > camera.position.y {
            self.position.y -= self.size.height * 3;
        }
    }
    
}
