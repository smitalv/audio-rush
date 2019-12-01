//
//  GameViewController.swift
//  Avoiding Obstacles
//
//  Created by Václav Smítal on 01/12/2019.
//  Copyright © 2019 Václav Smítal. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var barrierViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var playerViewLeftConstraint: NSLayoutConstraint!
    
    var timer: Timer?
    var screenWidth: CGFloat = 0
    var screenHeight: CGFloat = 0
    var horizontalPosition: CGFloat = 128
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let screenSize = UIScreen.main.bounds
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height
        self.playerView.layer.cornerRadius = 24
        playerViewLeftConstraint.constant = self.screenWidth / 2
        self.timer = Timer.scheduledTimer(timeInterval: 0.025, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    @objc func fire()
    {
        self.barrierViewTopConstraint.constant += 1
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        if let touch = touches.first {
            let location = touch.location(in: self.view)
            if(location.x < 24) {
                self.horizontalPosition = 24
            } else if(location.x > (self.screenWidth - 24)) {
                self.horizontalPosition = self.screenWidth - 24
            } else {
                self.horizontalPosition = location.x
            }

            playerViewLeftConstraint.constant = self.horizontalPosition
        }
    }
    
    @IBAction func tappedPause(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
}
