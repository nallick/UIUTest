//
//  UIStepperSimulation.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIStepper
{
    public var boundsForDecrement: CGRect {
        var bounds = self.bounds
        bounds.size.width *= 0.5

        return bounds
    }

    public var boundsForIncrement: CGRect {
        var bounds = self.bounds
        bounds.size.width *= 0.5
        bounds.origin.x += bounds.size.width

        return bounds
    }

    public var willRespondToUserInDecrement: Bool {
        let hitView = self.touchWillHitView(at: boundsForDecrement.midPoint)
        return hitView === self
    }

    public var willRespondToUserInIncrement: Bool {
        let hitView = self.touchWillHitView(at: boundsForIncrement.midPoint)
        return hitView === self
    }

    public func decrementAndNotify() {
        self.setValueAndNotify(self.value - self.stepValue)
    }

    public func incrementAndNotify() {
        self.setValueAndNotify(self.value + self.stepValue)
    }

    public func setValueAndNotify(_ value: Double) {
        let oldValue = self.value
        self.value = value
        if self.value != oldValue {
            self.sendActions(for: .valueChanged)
        }
    }

    public func simulateTouchInDecrement() {
        if self.willRespondToUserInDecrement {
            self.decrementAndNotify()
        }
    }

    public func simulateTouchInIncrement() {
        if self.willRespondToUserInIncrement {
            self.incrementAndNotify()
        }
    }
}
