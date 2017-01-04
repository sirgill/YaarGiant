//
//  GameplayScene.swift
//  YaarGiant
//
//  Created by Surinder Singh Gill on 1/3/17.
//  Copyright © 2017 Surinder Singh Gill. All rights reserved.
//

import SpriteKit

class GameplayScene: SKScene, SKPhysicsContactDelegate {
    
    private var mainCamera: SKCameraNode?;
    
    private let cloudsController = CloudsController();
    
    private var player: Player?;
    
    private var bg1: BGClass?;
    private var bg2: BGClass?;
    private var bg3: BGClass?;
    
    private var canMove = false;
    private var moveLeft = false;
    
    private var center: CGFloat?;
    
    private var acceleration = CGFloat();
    private var cameraSpeed = CGFloat();
    private var maxSpeed = CGFloat();
    
    private let playerMinX = CGFloat(-214);
    private let playerMaxX = CGFloat(214);
    
    private var cameraDistanceBeforeCreatingNewClouds = CGFloat();
    
    private let distanceBetweenClouds = CGFloat(240);
    private let minX = CGFloat(-160);
    private let maxX = CGFloat(160);
    
    private var pausePanel: SKSpriteNode?;
    
    override func didMove(to view: SKView) {
        initializeGame();
    }
    
    private func initializeGame() {
        
        physicsWorld.contactDelegate = self;
        
        center = self.frame.size.width / self.frame.size.height;
        
        player = self.childNode(withName: "Player") as? Player;
        player?.initializePlayerAndAnimations();
        
        mainCamera = self.childNode(withName: "MainCamera") as? SKCameraNode!;
        
        getBackgrounds();
        
        getLabels();
        
        GameplayController.instance.initializeVariables();
        
        cloudsController.arrangeCloudsInScene(scene: self.scene!, distaneBetweenClouds: distanceBetweenClouds, center: center!, minX: minX, maxX: maxX, player: player! , initialClouds: true);
        
        cameraDistanceBeforeCreatingNewClouds = mainCamera!.position.y - 400;
        
        setCameraSpeed();
        
    }
    
    private func getBackgrounds() {
        bg1 = self.childNode(withName: "BG 1") as? BGClass!
        bg2 = self.childNode(withName: "BG 2") as? BGClass!
        bg3 = self.childNode(withName: "BG 3") as? BGClass!
    }
    
    override func update(_ currentTime: TimeInterval) {
        managePlayer();
        moveCamera();
        manageBackgrounds();
        createNewClouds();
        player?.setScore();
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody = SKPhysicsBody();
        var secondBody = SKPhysicsBody();
        
        if contact.bodyA.node?.name == "Player" {
            firstBody = contact.bodyA;
            secondBody = contact.bodyB;
        } else {
            firstBody = contact.bodyB;
            secondBody = contact.bodyA;
        }
        
        if firstBody.node?.name == "Player" && secondBody.node?.name == "Life" {
            self.run(SKAction.playSoundFileNamed("Life Sound.wav", waitForCompletion: false));
            GameplayController.instance.incrementLife();
            secondBody.node?.removeFromParent()
        }
        
        if firstBody.node?.name == "Player" && secondBody.node?.name == "Coin" {
            self.run(SKAction.playSoundFileNamed("Coin Sound.wav", waitForCompletion: false));
            GameplayController.instance.incrementCoin();
            secondBody.node?.removeFromParent()
        }
        
        if firstBody.node?.name == "Player" && secondBody.node?.name == "Dark Cloud" {
            
            self.scene?.isPaused = true;
            
            GameplayController.instance.life -= 1;
            
            if GameplayController.instance.life >= 0 {
                GameplayController.instance.lifeText?.text = "x\(GameplayController.instance.life)"
            } else {
                createEndScorePanel()
            }
            
            firstBody.node?.removeFromParent();
            
            Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(GameplayScene.playerDied), userInfo: nil, repeats: false);
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self);
            
            if nodes(at: location)[0].name != "Pause" && nodes(at: location)[0].name != "Resume" && nodes(at: location)[0].name != "Quit" {
                if !self.scene!.isPaused {
                    if location.x > center! {
                        moveLeft = false;
                        player?.animatePlayer(moveLeft: moveLeft);
                    } else {
                        moveLeft = true;
                        player?.animatePlayer(moveLeft: moveLeft);
                    }
                }
            }
            
            if nodes(at: location)[0].name == "Pause" {
                self.scene?.isPaused = true;
                createPausePanel();
            }
            
            if nodes(at: location)[0].name == "Resume" {
                self.pausePanel?.removeFromParent();
                self.scene?.isPaused = false;
            }
            
            if nodes(at: location)[0].name == "Quit" {
                let scene = MainMenuScene(fileNamed: "MainMenu");
                scene?.scaleMode = SKSceneScaleMode.aspectFill;
                self.view?.presentScene(scene!, transition: SKTransition.doorsCloseVertical(withDuration: 1));
            }
            
        }
        canMove = true;
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        canMove = false;
        player?.stopPlayerAnimation();
    }
    
    private func managePlayer() {
        if canMove {
            player?.move(toLeft: moveLeft);
        }
        
        if player!.position.x > playerMaxX {
            player!.position.x = playerMaxX;
        }
        
        if player!.position.x < playerMinX {
            player!.position.x = playerMinX;
        }
        
        if player!.position.y - player!.size.height * 3.7 > mainCamera!.position.y {
            self.scene?.isPaused = true;
            
            GameplayController.instance.life -= 1;
            
            if GameplayController.instance.life >= 0 {
                GameplayController.instance.lifeText?.text = "x\(GameplayController.instance.life)"
            } else {
                createEndScorePanel()
            }
            
            Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(GameplayScene.playerDied), userInfo: nil, repeats: false);
        }
        
        if player!.position.y + player!.size.height * 3.7 < mainCamera!.position.y {
            self.scene?.isPaused = true;
            
            GameplayController.instance.life -= 1;
            
            if GameplayController.instance.life >= 0 {
                GameplayController.instance.lifeText?.text = "x\(GameplayController.instance.life)"
            } else {
                createEndScorePanel()
            }
            
            Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(GameplayScene.playerDied), userInfo: nil, repeats: false);
        }
        
    }
    
    private func manageBackgrounds() {
        bg1?.moveBG(camera: mainCamera!);
        bg2?.moveBG(camera: mainCamera!);
        bg3?.moveBG(camera: mainCamera!);
    }
    
    private func moveCamera() {
        cameraSpeed += acceleration;
        if cameraSpeed > maxSpeed {
            cameraSpeed = maxSpeed;
        }
        
        self.mainCamera?.position.y -= cameraSpeed;
    }
    
    private func createNewClouds() {
        if cameraDistanceBeforeCreatingNewClouds > mainCamera!.position.y {
            
            cameraDistanceBeforeCreatingNewClouds = mainCamera!.position.y - 400;
            
            cloudsController.arrangeCloudsInScene(scene: self.scene!, distaneBetweenClouds: distanceBetweenClouds, center: center!, minX: minX, maxX: maxX, player: player! , initialClouds: false);
            
            checkForChildsOutOfScreen();
            
        }
    }
    
    private func checkForChildsOutOfScreen() {
        for child in children {
            if child.position.y > mainCamera!.position.y + self.scene!.size.height {
                
                let childName = child.name?.components(separatedBy: " ");
                
                if childName![0] != "BG" {
                    child.removeFromParent();
                }
                
            }
        }
    }
    
    private func getLabels() {
        GameplayController.instance.scoreText = self.mainCamera?.childNode(withName: "ScoreLabel") as? SKLabelNode!;
        GameplayController.instance.coinText = self.mainCamera?.childNode(withName: "CoinLabel") as? SKLabelNode!;
        GameplayController.instance.lifeText = self.mainCamera?.childNode(withName: "LifeLabel") as? SKLabelNode!;
    }
    
    private func createPausePanel() {
        
        pausePanel = SKSpriteNode(imageNamed: "Pause Menu");
        let resumeBtn = SKSpriteNode(imageNamed: "Resume Button");
        let quitBtn = SKSpriteNode(imageNamed: "Quit Button 2");
        
        pausePanel?.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        pausePanel?.xScale = 1.6;
        pausePanel?.yScale = 1.6;
        pausePanel?.zPosition = 5;
        
        pausePanel?.position = CGPoint(x: self.mainCamera!.frame.size.width / 2, y: self.mainCamera!.frame.size.height / 2);
        
        resumeBtn.name = "Resume";
        resumeBtn.zPosition = 6;
        resumeBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        resumeBtn.position = CGPoint(x: pausePanel!.position.x, y: pausePanel!.position.y + 25);
        
        quitBtn.name = "Quit";
        quitBtn.zPosition = 6;
        quitBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        quitBtn.position = CGPoint(x: pausePanel!.position.x, y: pausePanel!.position.y - 45);
        
        pausePanel?.addChild(resumeBtn);
        pausePanel?.addChild(quitBtn);
        
        self.mainCamera?.addChild(pausePanel!);
        
    }
    
    private func createEndScorePanel() {
        let endScorePanel = SKSpriteNode(imageNamed: "Show Score");
        let scoreLabel = SKLabelNode(fontNamed: "Blow");
        let coinLabel = SKLabelNode(fontNamed: "Blow");
        
        endScorePanel.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        endScorePanel.zPosition = 8;
        endScorePanel.xScale = 1.5;
        endScorePanel.yScale = 1.5;
        
        scoreLabel.text = "x\(GameplayController.instance.score)"
        coinLabel.text = "x\(GameplayController.instance.coin)"
        
        endScorePanel.addChild(scoreLabel);
        endScorePanel.addChild(coinLabel);
        
        scoreLabel.fontSize = 50;
        scoreLabel.zPosition = 7;
        
        coinLabel.fontSize = 50;
        coinLabel.zPosition = 7;
        
        endScorePanel.position = CGPoint(x: mainCamera!.frame.size.width / 2, y: mainCamera!.frame.size.height / 2);
        
        scoreLabel.position = CGPoint(x: endScorePanel.position.x - 60, y: endScorePanel.position.y + 10);
        coinLabel.position = CGPoint(x: endScorePanel.position.x - 60, y: endScorePanel.position.y - 105);
        
        mainCamera?.addChild(endScorePanel);
        
    }
    
    private func setCameraSpeed() {
        if GameManager.instance.getEasyDifficulty() {
            acceleration = 0.001;
            cameraSpeed = 1.5;
            maxSpeed = 4;
        } else if GameManager.instance.getMediumDifficulty() {
            acceleration = 0.002;
            cameraSpeed = 2;
            maxSpeed = 6;
        } else if GameManager.instance.getHardDifficulty() {
            acceleration = 0.003;
            cameraSpeed = 2.5;
            maxSpeed = 8;
        }
    }
    
    @objc
    private func playerDied() {
        if GameplayController.instance.life >= 0 {
            GameManager.instance.gameRestartedPlayerDied = true;
            
            let scene = GameplayScene(fileNamed: "GameplayScene");
            scene?.scaleMode = SKSceneScaleMode.aspectFill;
            self.view?.presentScene(scene!, transition: SKTransition.doorsCloseVertical(withDuration: 1));
        } else {
            if GameManager.instance.getEasyDifficulty() {
                let highscore = GameManager.instance.getEasyDifficultyScore();
                let coinScore = GameManager.instance.getEasyDifficultyCoinScore();
                
                if highscore < Int32(GameplayController.instance.score) {
                    GameManager.instance.setEasyDifficultyScore(Int32(GameplayController.instance.score));
                }
                
                if coinScore < Int32(GameplayController.instance.coin) {
                    GameManager.instance.setEasyDifficultyCoinScore(Int32(GameplayController.instance.coin));
                }
                
            } else if GameManager.instance.getMediumDifficulty() {
                let highscore = GameManager.instance.getMediumDifficultyScore();
                let coinScore = GameManager.instance.getMediumDifficultyCoinScore();
                
                if highscore < Int32(GameplayController.instance.score) {
                    GameManager.instance.setMediumDifficultyScore(Int32(GameplayController.instance.score));
                }
                
                if coinScore < Int32(GameplayController.instance.coin) {
                    GameManager.instance.setMediumDifficultyCoinScore(Int32(GameplayController.instance.coin));
                }
                
            } else if GameManager.instance.getHardDifficulty() {
                let highscore = GameManager.instance.getHardDifficultyScore();
                let coinScore = GameManager.instance.getHardDifficultyCoinScore();
                
                if highscore < Int32(GameplayController.instance.score) {
                    GameManager.instance.setHardDifficultyScore(Int32(GameplayController.instance.score));
                }
                
                if coinScore < Int32(GameplayController.instance.coin) {
                    GameManager.instance.setHardDifficultyCoinScore(Int32(GameplayController.instance.coin));
                }
                
            }
            
            GameManager.instance.saveData();
            
            let scene = MainMenuScene(fileNamed: "MainMenu");
            scene?.scaleMode = SKSceneScaleMode.aspectFill;
            self.view?.presentScene(scene!, transition: SKTransition.doorsCloseVertical(withDuration: 1));
        }
    }
    
}
