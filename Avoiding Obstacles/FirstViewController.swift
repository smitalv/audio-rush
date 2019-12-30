//
// Created by Václav Smítal on 28/12/2019.
// Copyright (c) 2019 Václav Smítal. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UILabel!
    var image: UIImage?
    var text: String?
    var pageViewController: GetStartedPageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = self.image
        self.textView.text = self.text
    }

    @IBAction func tappedContinueButton(_ sender: UIButton) {
        self.pageViewController!.goToNextPage(animated: true, completion: nil)
    }

    @IBAction func tappedSkipButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
