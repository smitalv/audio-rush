//
//  VisibilityViewController.swift
//  Avoiding Obstacles
//
//  Created by Václav Smítal on 30/12/2019.
//  Copyright © 2019 Václav Smítal. All rights reserved.
//

import UIKit

class VisibilityViewController: UIViewController {
    var pageViewController: GetStartedPageViewController?

    @IBOutlet weak var textView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIAccessibility.post(notification: .screenChanged, argument: self.textView)
    }

    @IBAction func tapedYesButton(_ sender: UIButton) {
        let vc = self.pageViewController?.presentingViewController as! ViewController
        vc.visibility = false
        vc.visibilityButton.setImage(UIImage(named: "ion-eye-disabled"), for: .normal)
        vc.visibilityButton.accessibilityLabel = "Visibility disabled. Tap to enable."
        vc.defaults.set(false, forKey: "visibility")

        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func tappedNoButton(_ sender: UIButton) {
        let vc = self.pageViewController?.presentingViewController as! ViewController
        vc.visibility = true
        vc.visibilityButton.setImage(UIImage(named: "ion-eye"), for: .normal)
        vc.visibilityButton.accessibilityLabel = "Visibility enabled. Tap to disable."
        vc.defaults.set(true, forKey: "visibility")

        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func tappedSkipButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
