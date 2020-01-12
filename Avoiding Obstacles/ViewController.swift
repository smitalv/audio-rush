//
//  ViewController.swift
//  Avoiding Obstacles
//
//  Created by Václav Smítal on 01/12/2019.
//  Copyright © 2019 Václav Smítal. All rights reserved.
//

import UIKit
import GameKit

class ViewController: UIViewController, GKGameCenterControllerDelegate {

    @IBOutlet weak var visibilityButton: UIButton!
    @IBOutlet weak var difficultyButton: UIButton!
    
    var gcEnabled = Bool()
    var gcDefaultLeaderBoard = String()
    var defaults = UserDefaults.standard

    var visibility = false
    var difficulty = "normal"
    var leaderboard_id = "not_visible_normal"
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if (defaults.bool(forKey: "visibility")) {
            self.visibility = true
            self.visibilityButton.setImage(UIImage(named: "ion-eye"), for: .normal)
            self.visibilityButton.accessibilityLabel = "Visibility enabled. Tap to disable."
        } else {
            self.visibility = false
            self.visibilityButton.setImage(UIImage(named: "ion-eye-disabled"), for: .normal)
            self.visibilityButton.accessibilityLabel = "Visibility disabled. Tap to enable."
        }

        if (defaults.string(forKey: "difficulty") == "hard") {
            self.difficulty = "hard"
            self.difficultyButton.setImage(UIImage(named: "tachometer-fast"), for: .normal)
            self.difficultyButton.accessibilityLabel = "Hard difficulty. Tap to change."
        } else if (defaults.string(forKey: "difficulty") == "easy") {
            self.difficulty = "easy"
            self.difficultyButton.setImage(UIImage(named: "tachometer-slow"), for: .normal)
            self.difficultyButton.accessibilityLabel = "Easy difficulty. Tap to change."
        } else {
            self.difficulty = "normal"
            self.difficultyButton.setImage(UIImage(named: "tachometer-normal"), for: .normal)
            self.difficultyButton.accessibilityLabel = "Normal difficulty. Tap to change."
        }

        if (!defaults.bool(forKey: "initialized")) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "getStarted") as! GetStartedPageViewController
            self.present(vc, animated: true, completion: nil)
        } else {
            authenticateLocalPlayer()
        }

        self.updateLeaderboardId()
    }

    func startGame() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "game") as! GameViewController
        vc.modalPresentationStyle = .fullScreen
        vc.visibility = self.visibility
        vc.difficulty = self.difficulty
        vc.leaderboard_id = self.leaderboard_id
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func tappedPlay(_ sender: UIButton) {
        self.startGame()
    }
    
    @IBAction func tappedLeaderboardButton(_ sender: UIButton) {
        fullyAuthenticateLocalPlayer()
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = leaderboard_id
        present(gcVC, animated: false, completion: nil)
    }
    
    @IBAction func tappedVisibilityButton(_ sender: UIButton) {
        if(self.visibility) {
            self.visibility = false
            self.visibilityButton.setImage(UIImage(named: "ion-eye-disabled"), for: .normal)
            self.visibilityButton.accessibilityLabel = "Visibility disabled. Tap to enable."
            defaults.set(false, forKey: "visibility")
        } else {
            self.visibility = true
            self.visibilityButton.setImage(UIImage(named: "ion-eye"), for: .normal)
            self.visibilityButton.accessibilityLabel = "Visibility enabled. Tap to disable."
            defaults.set(true, forKey: "visibility")
        }

        self.updateLeaderboardId()
    }
    
    @IBAction func tappedDifficultyButton(_ sender: UIButton) {
        if(self.difficulty == "normal") {
            self.difficulty = "hard"
            self.difficultyButton.setImage(UIImage(named: "tachometer-fast"), for: .normal)
            self.difficultyButton.accessibilityLabel = "Hard difficulty. Tap to change."
            defaults.set("hard", forKey: "difficulty")
        } else if(self.difficulty == "hard") {
            self.difficulty = "easy"
            self.difficultyButton.setImage(UIImage(named: "tachometer-slow"), for: .normal)
            self.difficultyButton.accessibilityLabel = "Easy difficulty. Tap to change."
            defaults.set("easy", forKey: "difficulty")
        } else {
            self.difficulty = "normal"
            self.difficultyButton.setImage(UIImage(named: "tachometer-normal"), for: .normal)
            self.difficultyButton.accessibilityLabel = "Normal difficulty. Tap to change."
            defaults.set("normal", forKey: "difficulty")
        }

        self.updateLeaderboardId()
    }

    func updateLeaderboardId() {
        var visibilityPart: String
        if(self.visibility) {
            visibilityPart = "visible"
        } else {
            visibilityPart = "not_visible"
        }

        self.leaderboard_id = visibilityPart + "_" + self.difficulty
    }
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local

        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if(((ViewController) != nil) && (!self.defaults.bool(forKey: "initialized"))) {
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                self.gcEnabled = true
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error as Any)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
            } else {
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error as Any)
            }
        }
    }

    func fullyAuthenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local

        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                self.gcEnabled = true
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error as Any)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
            } else {
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error as Any)
            }
        }
    }

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: false, completion: nil)
    }
}

