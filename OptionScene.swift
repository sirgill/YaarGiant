//
//  OptionScene.swift
//  YaarGiant
//
//  Created by Surinder Singh Gill on 1/3/17.
//  Copyright © 2017 Surinder Singh Gill. All rights reserved.
//

import SpriteKit

class OptionScene: SKScene {
    
    private var easyBtn: SKSpriteNode?;
    private var mediumBtn: SKSpriteNode?;
    private var hardBtn: SKSpriteNode?;
    
    private var sign: SKSpriteNode?;
    
    override func didMove(to view: SKView) {
        initializeVariables();
        setSign();
    }
    
    func initializeVariables() {
        easyBtn = self.childNode(withName: "Easy") as? SKSpriteNode!;
        mediumBtn = self.childNode(withName: "Medium") as? SKSpriteNode!;
        hardBtn = self.childNode(withName: "Hard") as? SKSpriteNode!;
        sign = self.childNode(withName: "Sign") as? SKSpriteNode!;
    }
    
    func setSign() {
        if GameManager.instance.getEasyDifficulty() == true {
            sign?.position.y = (easyBtn?.position.y)!;
        } else if GameManager.instance.getMediumDifficulty() == true {
            sign?.position.y = (mediumBtn?.position.y)!;
        } else if GameManager.instance.getHardDifficulty() == true {
            sign?.position.y = (hardBtn?.position.y)!;
        }
    }
    
    fileprivate func setDifficulty(_ difficulty: String) {
        switch(difficulty) {
        case "easy":
            GameManager.instance.setEasyDifficulty(true);
            GameManager.instance.setMediumDifficulty(false);
            GameManager.instance.setHardDifficulty(false);
            break;
            
        case "medium":
            GameManager.instance.setEasyDifficulty(false);
            GameManager.instance.setMediumDifficulty(true);
            GameManager.instance.setHardDifficulty(false);
            break;
            
        case "hard":
            GameManager.instance.setEasyDifficulty(false);
            GameManager.instance.setMediumDifficulty(false);
            GameManager.instance.setHardDifficulty(true);
            break;
            
        default:
            break;
        }
        GameManager.instance.saveData();
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self);
            
            if nodes(at: location)[0] == easyBtn {
                sign!.position.y = easyBtn!.position.y;
                setDifficulty("easy");
            }
            
            if nodes(at: location)[0] == mediumBtn {
                mediumBtn!.position.y = easyBtn!.position.y;
                setDifficulty("medium");
            }
            
            if nodes(at: location)[0] == hardBtn {
                sign!.position.y = hardBtn!.position.y;
                setDifficulty("hard");
            }
            
            sign?.zPosition = 4;
            
            if nodes(at: location)[0].name == "Back" {
                let scene = MainMenuScene(fileNamed: "MainMenu");
                scene?.scaleMode = SKSceneScaleMode.aspectFill;
                self.view?.presentScene(scene!, transition: SKTransition.doorsCloseVertical(withDuration: 1));
            }
            
        }
        
    }
    
}
