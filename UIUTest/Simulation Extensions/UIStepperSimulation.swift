//
//  UIStepperSimulation.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIStepper
{
	/// Returns the bounds of the receiver's decrement segment.
	///
    var boundsForDecrement: CGRect {
        var bounds = self.bounds
        bounds.size.width *= 0.5

        return bounds
    }

    /// Returns the bounds of the receiver's increment segment.
	///
    var boundsForIncrement: CGRect {
        var bounds = self.bounds
        bounds.size.width *= 0.5
        bounds.origin.x += bounds.size.width

        return bounds
    }

	/// Determine if the receiver will respond to user touches in the center of the decrement segment.
	///
    var willRespondToUserInDecrement: Bool {
        let hitView = self.touchWillHitView(at: boundsForDecrement.midPoint)
        return hitView === self
    }

	/// Determine if the receiver will respond to user touches in the center of the increment segment.
	///
    var willRespondToUserInIncrement: Bool {
        let hitView = self.touchWillHitView(at: boundsForIncrement.midPoint)
        return hitView === self
    }

	/// Decrement the stepper value by one step and send the appropriate actions.
	///
    func decrementAndNotify() {
        self.setValueAndNotify(self.value - self.stepValue)
    }

	/// Increment the stepper value by one step and send the appropriate actions.
	///
    func incrementAndNotify() {
        self.setValueAndNotify(self.value + self.stepValue)
    }

	/// Set the stepper value and send the appropriate actions.
	///
	/// - Parameter value: The new stepper value.
	///
    func setValueAndNotify(_ value: Double) {
        let oldValue = self.value
        self.value = value
        if self.value != oldValue {
            self.sendActions(for: .valueChanged)
        }
    }

	/// Simulate a user touch in the decrement segment of the receiver.
	///
    func simulateTouchInDecrement() {
        if self.willRespondToUserInDecrement {
            self.decrementAndNotify()
        }
    }

	/// Simulate a user touch in the decrement segment of the receiver.
	///
    func simulateTouchInIncrement() {
        if self.willRespondToUserInIncrement {
            self.incrementAndNotify()
        }
    }
}
