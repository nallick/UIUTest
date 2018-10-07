//
//  UIWindowTestable.swift
//
//  Copyright © 2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIWindow
{
    /// Remove all views from the receiver's root view controller.
	///
    public func removeViewsFromRootViewController() {
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
