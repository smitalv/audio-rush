//
//  PauseViewController.swift
//  Avoiding Obstacles
//
//  Created by Václav Smítal on 04/12/2019.
//  Copyright © 2019 Václav Smítal. All rights reserved.
//

import UIKit
import GameKit

class GameOverViewController: UIViewController, GKGameCenterControllerDelegate {
    @IBOutlet weak var scoreLabel: UILabel!

    var leaderboard_id = "not_visible_normal"

    public var score: Int = 0

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        scoreLabel.text = String(self.score)

        let bestScoreInt = GKScore(leaderboardIdentifier: self.leaderboard_id)
        bestScoreInt.value = Int64(self.score)
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }
    }

    @IBAction func tappedPlayAgainButton(_ sender: UIButton) {
        self.dismiss(animated: false)
        (self.presentingViewController as! GameViewController).start()
    }
    
    @IBAction func tappedMenuButton(_ sender: UIButton) {
        self.dismiss(animated: false)
        self.presentingViewController?.dismiss(animated: false)
    }

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: false, completion: nil)
    }
}

