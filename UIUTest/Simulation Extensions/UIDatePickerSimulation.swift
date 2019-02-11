//
//  UIDatePickerSimulation.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIDatePicker
{
	/// Determine if the receiver will respond to user touches in the center of the view.
	///
    override var willRespondToUser: Bool {
        let hitView = self.touchWillHitView
        return hitView === self || self.contains(subview: hitView)
    }

	/// Simulate a user swipe in the receiver to a specific date.
    ///
    /// - Parameter date: The date to swipe to.
	///
    func simulateSwipe(toDate date: Date) {
        if self.willRespondToUser {
            self.setDateAndNotify(date, animated: false)
        }
    }

    /// Set the receiver's date and send the appropriate actions.
    ///
    /// - Parameters:
	///   - date: The new date to set.
	///   - animated: Specifies if change animations will be used.
	///
	/// - Note:
	///		This mirrors UIDatePicker.setDate(_ date: Date, animated: Bool)
	///
    func setDateAndNotify(_ date: Date, animated: Bool) {
        if date != self.date {
            self.setDate(date, animated: animated)
            self.sendActions(for: .valueChanged)
        }
    }
}
