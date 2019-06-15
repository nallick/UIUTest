//
//  UISliderSimulation.swift
//
//  Copyright © 2017-2019 Purgatory Design. Licensed under the MIT License.
//

import UIKit

@nonobjc public extension UISlider
{
	/// Simulate a user swipe in the receiver to a specific value.
    ///
    /// - Parameter value: The value to swipe to.
	///
    func simulateSwipe(toValue value: Float) {
        if self.willRespondToUser {
            self.setValueAndNotify(value)
        }
    }

	/// Set the slider value and send the appropriate delegate notifications.
	///
	/// - Parameter value: The new slider value.
	///
    func setValueAndNotify(_ value: Float) {
        let oldValue = self.value
        self.value = value
        if self.value != oldValue {
            self.sendActions(for: .valueChanged)
        }
    }
}
