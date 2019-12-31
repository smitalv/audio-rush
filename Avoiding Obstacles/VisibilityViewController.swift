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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tapedYesButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func tappedNoButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func tappedSkipButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
