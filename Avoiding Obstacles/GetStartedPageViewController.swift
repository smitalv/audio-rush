//
//  GetStartedPageViewController.swift
//  Avoiding Obstacles
//
//  Created by Václav Smítal on 29/12/2019.
//  Copyright © 2019 Václav Smítal. All rights reserved.
//

import UIKit

class GetStartedPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    override var prefersStatusBarHidden: Bool {
        return true
    }

    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newViewController(text: "Avoiding Obstacles is an arcade game focused on accessibility", imageName: "ion-android-hand"),
                self.newViewController(text: "Move finger left or right to avoid moving obstacles", imageName: "fa-arrows-h"),
                self.newViewController(text: "Quieter tones means you need to move longer distance. Continue to hear them", imageName: "oi-headphones"),
                self.newViewController(text: "Slow tone means move right", imageName: "oi-headphones", soundRate: 0.75),
                self.newViewController(text: "Fast tone means move left", imageName: "oi-headphones", soundRate: 1.5),
                self.newViewController(text: "Tap with two fingers to pause. Good luck!", imageName: "tap-two-finger"),
                self.newVisibilityViewController()]
    }()

    private func newViewController(text: String, imageName: String, soundRate: Float? = nil) -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "getStartedPage") as! FirstViewController
        vc.text = text
        vc.image = UIImage(named: imageName)
        if soundRate != nil {
            vc.soundRate = soundRate
        }
        vc.pageViewController = self
        return vc
    }

    private func newVisibilityViewController() -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "visibilityPage") as! VisibilityViewController
        vc.pageViewController = self
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        self.isModalInPresentation = true

        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                    direction: .forward,
                    animated: true,
                    completion: nil)
        }
    }

    func setVisibility(visible: Bool) {

    }

    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        if let currentViewController = viewControllers?[0] {
            if let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) {
                setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return nil
        }

        guard orderedViewControllers.count > previousIndex else {
            return nil
        }

        return orderedViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }

        guard orderedViewControllersCount > nextIndex else {
            return nil
        }

        return orderedViewControllers[nextIndex]
    }
}
