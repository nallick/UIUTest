//
//  UIControlSimulation.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIControl
{
    @objc public func simulateTouch(for event: UIControlEvents = .touchUpInside) {
        if self.willRespondToUser {
            self.sendActions(for: event)
        }
    }
}
