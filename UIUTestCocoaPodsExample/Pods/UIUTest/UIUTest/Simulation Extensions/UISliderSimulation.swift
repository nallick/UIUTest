//
//  UISliderSimulation.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UISlider
{
    public func simulateSwipe(toValue value: Float) {
        if self.willRespondToUser {
            self.setValueAndNotify(value)
        }
    }

    public func setValueAndNotify(_ value: Float) {
        let oldValue = self.value
        self.value = value
        if self.value != oldValue {
            self.sendActions(for: .valueChanged)
        }
    }
}
