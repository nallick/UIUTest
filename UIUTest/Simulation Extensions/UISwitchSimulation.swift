//
//  UISwitchSimulation.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UISwitch
{
	/// Determine if the receiver will respond to user touches in the center of the view.
	///
    public override var willRespondToUser: Bool {
        let hitView = self.touchWillHitView
        return hitView === self || self.contains(subview: hitView)
    }

	/// Simulate a user touch in the receiver.
	///
	/// - Parameter event: The event to simulate if the switch responds to user touches.
	///
   public override func simulateTouch(for event: UIControlEvents = .valueChanged) {
        if self.willRespondToUser {
            if event == .valueChanged { self.isOn = !self.isOn }
            self.sendActions(for: event)
        }
    }
}
