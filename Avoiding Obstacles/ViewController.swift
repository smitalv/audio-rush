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

    var visibility = false
    var difficulty = "normal"
    var leaderboard_id = "not_visible_normal"
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        authenticateLocalPlayer()
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
        } else {
            self.visibility = true
            self.visibilityButton.setImage(UIImage(named: "ion-eye"), for: .normal)
        }

        self.updateLeaderboardId()
    }
    
    @IBAction func tappedDifficultyButton(_ sender: UIButton) {
        if(self.difficulty == "normal") {
            self.difficulty = "hard"
            self.difficultyButton.setImage(UIImage(named: "tachometer-fast"), for: .normal)
        } else if(self.difficulty == "hard") {
            self.difficulty = "easy"
            self.difficultyButton.setImage(UIImage(named: "tachometer-slow"), for: .normal)
        } else {
            self.difficulty = "normal"
            self.difficultyButton.setImage(UIImage(named: "tachometer-normal"), for: .normal)
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
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true

                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })

            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error)
            }
        }
    }

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: false, completion: nil)
    }
}

