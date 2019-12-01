//
//  GameViewController.swift
//  Avoiding Obstacles
//
//  Created by Václav Smítal on 01/12/2019.
//  Copyright © 2019 Václav Smítal. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {

    @IBOutlet weak var barrierView: UIView!
    @IBOutlet weak var barrierViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var holeViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var playerViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var playerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var timer: Timer?
    var screenWidth: CGFloat = 0
    var screenHeight: CGFloat = 0
    var horizontalPosition: CGFloat = 0
    var player: AVAudioPlayer?
    var count = 100
    var holePosition: CGFloat = 128
    var step: CGFloat = 1
    var steps = 0
    var score = 0
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let screenSize = UIScreen.main.bounds
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height
        self.playerView.layer.cornerRadius = 24
        self.horizontalPosition = self.screenWidth / 2
        self.playerViewLeftConstraint.constant = self.horizontalPosition
        self.holePosition = CGFloat.random(in: 64 ... (self.screenWidth - 64))
        self.holeViewLeftConstraint.constant = self.holePosition;
        self.step = (self.screenHeight - barrierView.frame.origin.y) / 1000
        self.playerViewBottomConstraint.constant = CGFloat(self.step * 150)

        self.timer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    @objc func fire()
    {
        if(self.playerView.frame.origin.y == self.barrierView.frame.origin.y) {
            if(self.horizontalPosition - 24 < self.holePosition - 64 || self.horizontalPosition + 24 > self.holePosition + 64) {
                self.playSound(soundName: "incorrect")
            } else {
                self.playSound(soundName: "correct")
                self.score += 1
                self.scoreLabel.text = String(self.score)
            }
        }

        self.count += 1
        if(self.count >= 100 && self.steps < 800) {
            var soundName: String
            if(self.horizontalPosition < self.holePosition - 40) {
                soundName = "a4"
                self.playSound(soundName: soundName)
            } else if(self.horizontalPosition > self.holePosition + 40) {
                soundName = "d4"
                self.playSound(soundName: soundName)
            }
            
            self.count = 0
        }
        
        self.steps += 1
        if(self.steps >= 1000) {
            self.barrierViewTopConstraint.constant = 12
            self.barrierView.alpha -= 0.25
            self.holePosition = CGFloat.random(in: 64 ... (self.screenWidth - 64))
            self.holeViewLeftConstraint.constant = self.holePosition;
            
            self.steps = 0
        }
        
        self.barrierViewTopConstraint.constant += step
    }

    func playSound(soundName: String) {

        guard let url = Bundle.main.url(forResource: soundName, withExtension: "wav") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            player?.rate = 2

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
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
        self.timer?.invalidate()
        self.timer = nil
        self.dismiss(animated: false)
    }
    
}
