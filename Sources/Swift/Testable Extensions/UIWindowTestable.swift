//
//  UIWindowTestable.swift
//
//  Copyright © 2018-2019 Purgatory Design. Licensed under the MIT License.
//

import UIKit

@nonobjc public extension UIWindow
{
    /// Remove all views from the receiver's root view controller.
	///
    func removeViewsFromRootViewController() {
        if let rootViewController = self.rootViewController {
            if let presentedViewController = rootViewController.presentingViewController, !presentedViewController.isBeingDismissed {
                rootViewController.dismiss(animated: false, completion: nil)
            }
            rootViewController.view.removeFromSuperview()
            if let navigationController = rootViewController.navigationController {
                navigationController.view.removeFromSuperview()
                navigationController.viewControllers = []
            }
        }
    }
}
