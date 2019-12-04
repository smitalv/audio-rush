//
//  PauseViewController.swift
//  Avoiding Obstacles
//
//  Created by Václav Smítal on 04/12/2019.
//  Copyright © 2019 Václav Smítal. All rights reserved.
//

import UIKit

class PauseViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!

    public var score: Int = 0
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        scoreLabel.text = String(self.score)
    }
    
    @IBAction func tappedResumeButton(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    @IBAction func tappedMenuButton(_ sender: UIButton) {
        self.dismiss(animated: false)
        self.presentingViewController?.dismiss(animated: false)
    }
}

