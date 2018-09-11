//
//  UIPickerViewSimulation.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIPickerView
{
    public override var willRespondToUser: Bool {
        let hitView = self.touchWillHitView
        return hitView === self || self.contains(subview: hitView)
    }

    public func simulateSwipe(toRow row: Int, inComponent component: Int) {
        if self.willRespondToUser {
            self.selectRowAndNotify(row, inComponent: component, animated: false)
        }
    }

    public func selectRowAndNotify(_ row: Int, inComponent component: Int, animated: Bool) {
        if row != self.selectedRow(inComponent: component) {
            self.selectRow(row, inComponent: component, animated: animated)
            self.delegate?.pickerView?(self, didSelectRow: row, inComponent: component)
        }
    }
}
