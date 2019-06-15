//
//  UISwitchSimulation.swift
//
//  Copyright © 2017-2019 Purgatory Design. Licensed under the MIT License.
//

import UIKit

@nonobjc public extension UISwitch
{
	/// Determine if the receiver will respond to user touches in the center of the view.
	///
    @objc override var willRespondToUser: Bool {
        let hitView = self.touchWillHitView
        return hitView === self || self.contains(subview: hitView)
    }

	/// Simulate a user touch in the receiver.
	///
	/// - Parameter event: The event to simulate if the switch responds to user touches.
	///
	@objc override func simulateTouch(for event: UIControl.Event = .valueChanged) {
        if self.willRespondToUser {
            if event == .valueChanged { self.isOn = !self.isOn }
            self.sendActions(for: event)
        }
    }
}
