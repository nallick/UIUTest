//
//  UIDatePickerSimulation.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIDatePicker
{
    public override var willRespondToUser: Bool {
        let hitView = self.touchWillHitView
        return hitView === self || self.contains(subview: hitView)
    }

    public func simulateSwipe(toDate date: Date) {
        if self.willRespondToUser {
            self.setDateAndNotify(date, animated: false)
        }
    }

    public func setDateAndNotify(_ date: Date, animated: Bool) {
        if date != self.date {
            self.setDate(date, animated: animated)
            self.sendActions(for: .valueChanged)
        }
    }
}
