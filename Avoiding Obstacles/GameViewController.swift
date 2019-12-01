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

    @IBOutlet weak var barrierViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var playerViewLeftConstraint: NSLayoutConstraint!
    
    var timer: Timer?
    var screenWidth: CGFloat = 0
    var screenHeight: CGFloat = 0
    var horizontalPosition: CGFloat = 128
    var player: AVAudioPlayer?
    var count = 0
    
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
        self.count += 1
        if(self.count >= 25) {
            self.playSound()
            self.count = 0
        }
        
        self.barrierViewTopConstraint.constant += 1
    }

    func playSound() {
        guard let url = Bundle.main.url(forResource: "d4", withExtension: "wav") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

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
