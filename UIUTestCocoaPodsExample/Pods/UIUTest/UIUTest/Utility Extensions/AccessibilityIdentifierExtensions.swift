//
//  AccessibilityIdentifierExtensions.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIBarButtonItemGroup
{
    public func itemWithAccessibilityIdentifier(_ identifier: String) -> UIBarButtonItem? {
        for item in self.barButtonItems {
            if item.accessibilityIdentifier == identifier {
                return item
            }
        }

        return nil
    }
}

public extension UITabBar
{
    public func itemWithAccessibilityIdentifier(_ identifier: String) -> UITabBarItem? {
        if let items = self.items {
            for item in items {
                if item.accessibilityIdentifier == identifier {
                    return item
                }
            }
        }

        return nil
    }
}

public extension UIToolbar
{
    public func itemWithAccessibilityIdentifier(_ identifier: String) -> UIBarButtonItem? {
        if let items = self.items {
            for item in items {
                if item.accessibilityIdentifier == identifier {
                    return item
                }
            }
        }

        return nil
    }
}

public extension UIView
{
    public func viewWithAccessibilityIdentifier(_ identifier: String) -> UIView? {
        if self.accessibilityIdentifier == identifier {
            return self
        }

        for subview in self.subviews {
            if let foundSubview = subview.viewWithAccessibilityIdentifier(identifier) {
                return foundSubview
            }
        }

        return nil
    }
}
