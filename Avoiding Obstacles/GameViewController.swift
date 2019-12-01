//
//  GameViewController.swift
//  Avoiding Obstacles
//
//  Created by Václav Smítal on 01/12/2019.
//  Copyright © 2019 Václav Smítal. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        if let touch = touches.first {
            let location = touch.location(in: self.view)
            print(location.x)
        }
    }

}
