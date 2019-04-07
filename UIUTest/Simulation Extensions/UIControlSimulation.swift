//
//  UIControlSimulation.swift
//
//  Copyright © 2017-2019 Purgatory Design. Licensed under the MIT License.
//

import UIKit

@nonobjc public extension UIControl
{
	/// Simulate a user touch in the receiver.
    ///
    /// - Parameter event: The event to simulate if the control responds to user touches.
	///
	@objc func simulateTouch(for event: UIControl.Event = .touchUpInside) {
        if self.willRespondToUser {
            self.sendActions(for: event)
        }
    }
}
