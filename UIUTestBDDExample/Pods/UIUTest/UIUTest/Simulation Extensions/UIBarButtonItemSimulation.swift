//
//  UIBarButtonItemSimulation.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIBarButtonItem
{
    public func simulateTouch() {
        if let target = self.target, let action = self.action, self.isEnabled {
            let _ = target.perform(action, with: self)
        }
    }
}
