//
//  UIViewControllerExtensions.swift
//
//  Copyright © 2017 Purgatory Design. Licensed under the MIT License.
//

import UIKit

extension UIViewController
{
    var isActiveInNavigationController: Bool {
       return self === self.navigationController?.topViewController
    }

    func pushSiblingViewController(withIdentifier identifier: String, storyBoardName: String? = nil, storyboardBundle: Bundle? = nil, animated: Bool) {
        if let navigationController = self.navigationController {
            let storyboard = (storyBoardName != nil) ? UIStoryboard(name: storyBoardName!, bundle: storyboardBundle) : self.storyboard
            if let viewController = storyboard?.instantiateViewController(withIdentifier: identifier) {
                navigationController.pushViewController(viewController, animated: animated)
            }
        }
    }
}
