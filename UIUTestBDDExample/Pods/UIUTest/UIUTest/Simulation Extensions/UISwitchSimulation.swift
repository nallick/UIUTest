//
//  UISwitchSimulation.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UISwitch
{
    public override var willRespondToUser: Bool {
        let hitView = self.touchWillHitView
        return hitView === self || self.contains(subview: hitView)
    }

    public override func simulateTouch(for event: UIControlEvents = .valueChanged) {
        if self.willRespondToUser {
            if event == .valueChanged { self.isOn = !self.isOn }
            self.sendActions(for: event)
        }
    }
}
