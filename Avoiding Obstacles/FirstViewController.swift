//
// Created by Václav Smítal on 28/12/2019.
// Copyright (c) 2019 Václav Smítal. All rights reserved.
//

import UIKit
import AVFoundation

class FirstViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UILabel!
    var image: UIImage?
    var text: String?
    var soundRate: Float?
    var pageViewController: GetStartedPageViewController?
    var player: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = self.image
        self.textView.text = self.text
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if soundRate != nil {
            guard let url = Bundle.main.url(forResource: "loop", withExtension: "wav") else {
                return
            }

            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)

                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
                player?.numberOfLoops = -1
                player?.enableRate = true
                player?.rate = soundRate!

                guard let beepPlayer = player else {
                    return
                }

                beepPlayer.play()

            } catch let error {
                print(error.localizedDescription)
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if soundRate != nil {
            player?.stop()
            player = nil
        }
    }

    @IBAction func tappedContinueButton(_ sender: UIButton) {
        self.pageViewController!.goToNextPage(animated: true, completion: nil)
    }

    @IBAction func tappedSkipButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
