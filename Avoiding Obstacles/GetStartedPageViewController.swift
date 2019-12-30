//
//  GetStartedPageViewController.swift
//  Avoiding Obstacles
//
//  Created by Václav Smítal on 29/12/2019.
//  Copyright © 2019 Václav Smítal. All rights reserved.
//

import UIKit

class GetStartedPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newViewController(text: "Avoiding Obstacles is an arcade game focused on accessibility", imageName: "ion-android-hand"),
                self.newViewController(text: "Move your finger left or right on the bottom of the screen", imageName: "fa-arrows-h"),
                self.newViewController(text: "Try to fit into the gap. Distance can be determined by the music volume.", imageName: "obstacle-demo"),
                self.newViewController(text: "Using headphones is recommended. It will let you know the desired direction.", imageName: "oi-headphones"),
                self.newVisibilityViewController()]
    }()

    private func newViewController(text: String, imageName: String) -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "getStartedPage") as! FirstViewController
        vc.text = text
        vc.image = UIImage(named: imageName)
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
