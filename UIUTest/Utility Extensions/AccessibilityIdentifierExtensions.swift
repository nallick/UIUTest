//
//  AccessibilityIdentifierExtensions.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIBarButtonItemGroup
{
    public func itemWithAccessibilityIdentifier(_ identifier: String, where inclusionTest: ((UIBarButtonItem) -> Bool)? = nil) -> UIBarButtonItem? {
        for item in self.barButtonItems {
            if item.accessibilityIdentifier == identifier && (inclusionTest?(item) ?? true) {
                return item
            }
        }

        return nil
    }

	public func itemWithAccessibilityLabel(_ label: String, where inclusionTest: ((UIBarButtonItem) -> Bool)? = nil) -> UIBarButtonItem? {
		for item in self.barButtonItems {
			if item.accessibilityLabel == label && (inclusionTest?(item) ?? true) {
				return item
			}
		}

		return nil
	}
}

public extension UITabBar
{
	public func itemWithAccessibilityIdentifier(_ identifier: String, where inclusionTest: ((UITabBarItem) -> Bool)? = nil) -> UITabBarItem? {
		if let items = self.items {
			for item in items {
				if item.accessibilityIdentifier == identifier && (inclusionTest?(item) ?? true) {
					return item
				}
			}
		}

		return nil
	}

	public func itemWithAccessibilityLabel(_ label: String, where inclusionTest: ((UITabBarItem) -> Bool)? = nil) -> UITabBarItem? {
		if let items = self.items {
			for item in items {
				if item.accessibilityLabel == label && (inclusionTest?(item) ?? true) {
					return item
				}
			}
		}

		return nil
	}
}

public extension UIToolbar
{
    public func itemWithAccessibilityIdentifier(_ identifier: String, where inclusionTest: ((UIBarButtonItem) -> Bool)? = nil) -> UIBarButtonItem? {
        if let items = self.items {
            for item in items {
                if item.accessibilityIdentifier == identifier && (inclusionTest?(item) ?? true) {
                    return item
                }
            }
        }

        return nil
    }

	public func itemWithAccessibilityLabel(_ label: String, where inclusionTest: ((UIBarButtonItem) -> Bool)? = nil) -> UIBarButtonItem? {
		if let items = self.items {
			for item in items {
				if item.accessibilityLabel == label && (inclusionTest?(item) ?? true) {
					return item
				}
			}
		}

		return nil
	}
}

public extension UIView
{
    public func viewWithAccessibilityIdentifier(_ identifier: String, where inclusionTest: ((UIView) -> Bool)? = nil) -> UIView? {
        if self.accessibilityIdentifier == identifier && (inclusionTest?(self) ?? true) {
            return self
        }

        for subview in self.subviews {
			if let foundSubview = subview.viewWithAccessibilityIdentifier(identifier, where: inclusionTest) {
                return foundSubview
            }
        }

        return nil
    }

	public func viewWithAccessibilityLabel(_ label: String, where inclusionTest: ((UIView) -> Bool)? = nil) -> UIView? {
		if self.accessibilityLabel == label && (inclusionTest?(self) ?? true) {
			return self
		}

		for subview in self.subviews {
			if let foundSubview = subview.viewWithAccessibilityLabel(label, where: inclusionTest) {
				return foundSubview
			}
		}

		return nil
	}
}
