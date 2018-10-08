//
//  UIPickerViewSimulation.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIPickerView
{
	/// Determine if the receiver will respond to user touches in the center of the view.
	///
    public override var willRespondToUser: Bool {
        let hitView = self.touchWillHitView
        return hitView === self || self.contains(subview: hitView)
    }

	/// Simulate a user swipe in the receiver to a specific row.
    ///
    /// - Parameters:
    ///   - row: The row to swipe to.
    ///   - component: The component to swipe to.
	///
    public func simulateSwipe(toRow row: Int, inComponent component: Int) {
        if self.willRespondToUser {
            self.selectRowAndNotify(row, inComponent: component, animated: false)
        }
    }

	/// Select a spacific row and send the appropriate delegate notifications.
	///
	/// - Parameters:
	///   - row: The row to select.
	///   - component: The component to select.
	///   - animated: Specifies if selection animations will be used.
	///
	/// - Note:
	///		This mirrors UIPickerView.selectRow(_ row: Int, inComponent component: Int, animated: Bool)
	///
    public func selectRowAndNotify(_ row: Int, inComponent component: Int, animated: Bool) {
        if row != self.selectedRow(inComponent: component) {
            self.selectRow(row, inComponent: component, animated: animated)
            self.delegate?.pickerView?(self, didSelectRow: row, inComponent: component)
        }
    }
}
