//
//  UIStoryboardSegueTestable.swift
//
//  Copyright © 2017-2019 Purgatory Design. Licensed under the MIT License.
//

import UIKit

@nonobjc public extension UIStoryboardSegue
{
    /// Simulate the completion of the receiver.
    ///
    /// - Returns: The destination view controller.
	///
    func simulateCompletion() -> UIViewController {
        let result = self.destination
        UIApplication.shared.keyWindow?.rootViewController = result
        result.loadViewIfNeeded()
        return result
    }
}
