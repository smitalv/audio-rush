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

    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var barrierView: UIView!
    @IBOutlet weak var barrierViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var holeViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var holeOverlayView: UIView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var playerViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var playerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var playerViewWidthContraint: NSLayoutConstraint!
    @IBOutlet weak var holeViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var tapToStartLabel: UILabel!
    
    var visibility = false
    var difficulty = "normal"
    var leaderboard_id = "not_visible_normal"
    
    var timer: Timer?
    var screenWidth: CGFloat = 0
    var screenHeight: CGFloat = 0
    var horizontalPosition: CGFloat = 0
    var player: AVAudioPlayer?
    var beepPlayer: AVAudioPlayer?
    var holePosition: CGFloat = 128
    var step: CGFloat = 1
    var steps = 0
    var score = 0
    var holeWidth: CGFloat = 128
    var status = "ok"
    var originalDelay = 0.004
    var playerSize: CGFloat = 0
    var dead = false
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !self.visibility {
            self.barrierView.alpha = 0
        }

        if self.difficulty == "easy" {
            self.originalDelay = 0.005
        } else if self.difficulty == "hard" {
            self.originalDelay = 0.0015
        } else {
            self.originalDelay = 0.003
        }

        let screenSize = UIScreen.main.bounds
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height
        self.step = (self.screenHeight - barrierView.frame.origin.y) / 1000

        self.start()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.isAccessibilityElement = false
        self.boardView.isUserInteractionEnabled = true
        self.tapToStartLabel.alpha = 1
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
            UIAccessibility.post(notification: .announcement, argument: "Tap to start")
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.timer?.invalidate()
        self.timer = nil
        self.beepPlayer?.stop()
    }

    @IBAction func tappedToStart(_ sender: UITapGestureRecognizer) {
        self.tapToStartLabel.alpha = 0
        self.playBeep(soundName: "loop")
        self.setSound()
        self.fire()
    }
    
    func start() {
        self.scoreLabel.alpha = 0
        self.boardView.backgroundColor = UIColor(named: "GreenColour")
        self.holeOverlayView.backgroundColor = self.boardView.backgroundColor
        self.status = "ok"
        self.score = 0
        self.steps = 0
        self.barrierViewTopConstraint.constant = 12
        self.scoreLabel.text = String(self.score)
        self.horizontalPosition = self.screenWidth / 2
        self.playerViewLeftConstraint.constant = self.horizontalPosition
        self.holePosition = CGFloat.random(in: 64 ... (self.screenWidth - 64))
        self.holeViewWidthConstraint.constant = self.holeWidth
        self.holeViewLeftConstraint.constant = self.holePosition;
        self.playerViewBottomConstraint.constant = CGFloat(self.step * 150)
        self.holeWidth = 0.35 * self.screenWidth
        self.holeViewWidthConstraint.constant = self.holeWidth
        self.playerSize = 0.12 * self.screenWidth
        self.playerViewWidthContraint.constant = self.playerSize
        self.playerView.layer.cornerRadius = self.playerSize / 2
        self.dead = false
    }

    @objc func fire() {
        if !self.dead {
            var interval = self.originalDelay - (Double(self.score) * 0.00005)
            if (interval < 0.0005) {
                interval = 0.0005
            }

            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(fire), userInfo: nil, repeats: true)

            self.setSound()

            if (self.playerView.frame.origin.y - 32 <= self.barrierView.frame.origin.y && self.playerView.frame.origin.y >= self.barrierView.frame.origin.y - CGFloat(self.playerSize)) {
                if (self.horizontalPosition - self.playerSize / 2 < self.holePosition - (self.holeWidth / 2) || self.horizontalPosition + self.playerSize / 2 > self.holePosition + (self.holeWidth / 2)) {
                    self.status = "ko"
                    self.dead = true
                    self.playSound(soundName: "incorrect")
                    if !UIAccessibility.isVoiceOverRunning {
                        self.endGame()
                    } else {
                        UIAccessibility.post(notification: .announcement, argument: "Game Over " + String(self.score) + " points")
                    }
                }
            }

            if (self.playerView.frame.origin.y < self.barrierView.frame.origin.y - CGFloat(self.playerSize) && self.status == "ok") {
                self.playSound(soundName: "correct")
                self.score += 1
                self.status = "ko"
            }

            self.boardView.backgroundColor = UIColor(named: "GreenColour")?.withAlphaComponent(1 - 0.001 * CGFloat(self.steps))
            self.holeOverlayView.backgroundColor = self.boardView.backgroundColor

            self.steps += 1
            if (self.steps >= 1000) {
                self.scoreLabel.text = String(self.score)
                self.barrierViewTopConstraint.constant = 12
                self.holePosition = CGFloat.random(in: 64...(self.screenWidth - 64))
                self.holeViewLeftConstraint.constant = self.holePosition;

                if (self.score > 20) {
                    self.holeWidth = (0.35 - 0.002 * CGFloat(self.score - 20)) * self.screenWidth
                    self.holeViewWidthConstraint.constant = self.holeWidth
                }
                self.steps = 0
                self.status = "ok"
            }

            if (self.visibility && self.barrierViewTopConstraint.constant < 270) {
                self.scoreLabel.alpha = (1 - (270 - self.barrierViewTopConstraint.constant) * 0.01)
            } else if (!self.visibility && self.steps < 150) {
                self.scoreLabel.alpha = (1 - CGFloat(150 - self.steps) * 0.01)
            } else if (self.steps > 800) {
                self.scoreLabel.alpha = CGFloat(1000 - self.steps) * 0.0005
            } else {
                self.scoreLabel.alpha = 1
            }

            self.barrierViewTopConstraint.constant += step
        }
    }

    func endGame() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "gameOver") as! GameOverViewController
        vc.modalPresentationStyle = .fullScreen
        vc.score = self.score
        vc.leaderboard_id = self.leaderboard_id
        self.present(vc, animated: false, completion: nil)
    }

    func setSound() {
        if (self.playerView.frame.origin.y + self.playerSize / 2 >= self.barrierView.frame.origin.y - 16) {
            if (self.horizontalPosition - self.playerSize / 2 < self.holePosition - (self.holeWidth / 2)) {
                let distance = (self.holePosition - self.holeWidth / 2) - (self.horizontalPosition - self.playerSize / 2)
                self.beepPlayer?.volume = 1 - Float(distance) / Float(self.screenWidth)
                if self.beepPlayer!.volume < Float(0.25) {
                    self.beepPlayer?.volume = 0.25
                }
                if (self.beepPlayer?.rate != 0.75) {
                    self.beepPlayer?.stop()
                    self.beepPlayer?.enableRate = true
                    self.beepPlayer?.rate = 0.75
                    self.beepPlayer?.play()
                }
            } else if (self.horizontalPosition + self.playerSize / 2 > self.holePosition + (self.holeWidth / 2)) {
                let distance = (self.horizontalPosition + self.playerSize / 2) - (self.holePosition + self.holeWidth / 2)
                self.beepPlayer?.volume = 1 - Float(distance) / Float(self.screenWidth)
                if self.beepPlayer!.volume < Float(0.25) {
                    self.beepPlayer?.volume = 0.25
                }
                if (self.beepPlayer?.rate != 1.5) {
                    self.beepPlayer?.stop()
                    self.beepPlayer?.enableRate = true
                    self.beepPlayer?.rate = 1.5
                    self.beepPlayer?.play()
                }
            } else {
                self.beepPlayer?.volume = 0
            }
        } else {
            self.beepPlayer?.volume = 0
        }
    }
    
    func playBeep(soundName: String) {

        guard let url = Bundle.main.url(forResource: soundName, withExtension: "wav") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            beepPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            beepPlayer?.numberOfLoops = -1

            guard let beepPlayer = beepPlayer else { return }

            beepPlayer.play()

        } catch let error {
            print(error.localizedDescription)
        }
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
            if (location.x < self.playerSize / 2) {
                self.horizontalPosition = self.playerSize / 2
            } else if (location.x > (self.screenWidth - self.playerSize / 2)) {
                self.horizontalPosition = self.screenWidth - self.playerSize / 2
            } else {
                self.horizontalPosition = location.x
            }

            playerViewLeftConstraint.constant = self.horizontalPosition
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)

        if self.dead {
            self.endGame()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        if self.dead {
            self.endGame()
        }
    }

    @IBAction func tappedTwoFingers(_ sender: UITapGestureRecognizer) {
        self.pause()
    }
    
    @IBAction func tappedPause(_ sender: UIButton) {
        self.pause()
    }

    func pause() {
        if !self.dead {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "pause") as! PauseViewController
            vc.modalPresentationStyle = .fullScreen
            vc.score = self.score
            self.present(vc, animated: false, completion: nil)
        }
    }
    
}
