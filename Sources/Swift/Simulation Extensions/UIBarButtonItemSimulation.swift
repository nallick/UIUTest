//
//  UIBarButtonItemSimulation.swift
//
//  Copyright © 2017-2019 Purgatory Design. Licensed under the MIT License.
//

import UIKit

@nonobjc public extension UIBarButtonItem
{
	/// Simulate a user touch in the receiver.
	///
    func simulateTouch() {
        if let target = self.target, let action = self.action, self.isEnabled {
            let _ = target.perform(action, with: self)
        }
    }
}
