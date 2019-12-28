//
// Created by Václav Smítal on 28/12/2019.
// Copyright (c) 2019 Václav Smítal. All rights reserved.
//

import UIKit

class GetStartedViewController: UIViewController {

    @IBAction func tappedContinueButton(_ sender: UIButton) {
    }

    @IBAction func tappedSkipButton(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}
