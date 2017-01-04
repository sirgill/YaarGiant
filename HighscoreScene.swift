//
//  HighscoreScene.swift
//  YaarGiant
//
//  Created by Surinder Singh Gill on 1/3/17.
//  Copyright © 2017 Surinder Singh Gill. All rights reserved.
//

import SpriteKit

class HighscoreScene: SKScene {
    
    private var scoreLabel: SKLabelNode?;
    private var coinLabel: SKLabelNode?;
    
    override func didMove(to view: SKView) {
        getReference();
        setScore();
    }
    
    private func getReference() {
        scoreLabel = self.childNode(withName: "Score Label") as? SKLabelNode!;
        coinLabel = self.childNode(withName: "Coin Label") as? SKLabelNode!;
    }
    
    private func setScore() {
        if GameManager.instance.getEasyDifficulty() {
            scoreLabel?.text = String(GameManager.instance.getEasyDifficultyScore());
            coinLabel?.text = String(GameManager.instance.getEasyDifficultyCoinScore());
        } else if GameManager.instance.getMediumDifficulty() {
            scoreLabel?.text = String(GameManager.instance.getMediumDifficultyScore());
            coinLabel?.text = String(GameManager.instance.getMediumDifficultyCoinScore());
        } else if GameManager.instance.getHardDifficulty() {
            scoreLabel?.text = String(GameManager.instance.getHardDifficultyScore());
            coinLabel?.text = String(GameManager.instance.getHardDifficultyCoinScore());
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self);
            
            if nodes(at: location)[0].name == "Back" {
                let scene = MainMenuScene(fileNamed: "MainMenu");
                scene?.scaleMode = SKSceneScaleMode.aspectFill;
                self.view?.presentScene(scene!, transition: SKTransition.doorsCloseVertical(withDuration: 1));
            }
            
        }
        
    }
    
}
