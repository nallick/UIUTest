//
//  UISliderSimulation.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UISlider
{
	/// Simulate a user swipe in the receiver to a specific value.
    ///
    /// - Parameter value: The value to swipe to.
	///
    public func simulateSwipe(toValue value: Float) {
        if self.willRespondToUser {
            self.setValueAndNotify(value)
        }
    }

	/// Set the slider value and send the appropriate delegate notifications.
	///
	/// - Parameter value: The new slider value.
	///
    public func setValueAndNotify(_ value: Float) {
        let oldValue = self.value
        self.value = value
        if self.value != oldValue {
            self.sendActions(for: .valueChanged)
        }
    }
}
