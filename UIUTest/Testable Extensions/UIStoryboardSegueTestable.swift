//
//  UIStoryboardSegueTestable.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIStoryboardSegue
{
    public func simulateCompletion() -> UIViewController {
        let result = self.destination
        UIApplication.shared.keyWindow?.rootViewController = result
        result.loadViewIfNeeded()
        return result
    }
}
