//
//  GameplayController.swift
//  YaarGiant
//
//  Created by Surinder Singh Gill on 1/3/17.
//  Copyright © 2017 Surinder Singh Gill. All rights reserved.
//

import Foundation
import SpriteKit

class GameplayController {
    static let instance = GameplayController();
    private init() {}
    
    var scoreText: SKLabelNode?;
    var coinText: SKLabelNode?;
    var lifeText: SKLabelNode?;
    
    var score: Int = 0;
    var coin: Int = 0;
    var life: Int = 0;
    
    func initializeVariables() {
        if GameManager.instance.gameStartedFromMainMenu {
            
            GameManager.instance.gameStartedFromMainMenu = false;
            
            score = -1;
            coin = 0;
            life = 2;
            
            scoreText?.text = "\(score)";
            coinText?.text = "x\(coin)";
            lifeText?.text = "x\(life)";
            
        } else if GameManager.instance.gameRestartedPlayerDied {
            
            GameManager.instance.gameRestartedPlayerDied = false;
            
            scoreText?.text = "\(score)";
            coinText?.text = "x\(coin)";
            lifeText?.text = "x\(life)";
        }
    }
    
    func incrementScore() {
        score += 1;
        scoreText?.text = "\(score)"
    }
    
    func incrementCoin() {
        coin += 1;
        
        score += 200;
        
        coinText?.text = "x\(coin)"
        scoreText?.text = "\(score)"
    }
    
    func incrementLife() {
        life += 1;
        
        score += 300;
        
        lifeText?.text = "x\(life)"
        scoreText?.text = "\(score)"
        
        
    }
    
}

