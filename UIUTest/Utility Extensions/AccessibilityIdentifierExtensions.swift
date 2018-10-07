//
//  AccessibilityIdentifierExtensions.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIBarButtonItemGroup
{
    /// Returns one of the receiver's items with the specified accessibiliity identifier.
    ///
    /// - Parameters:
    ///   - identifier: The accessibiliity identifier to match.
    ///   - inclusionTest: An optional test to exclude individual items.
    /// - Returns: The matching bar button item (if any).
	///
    public func itemWithAccessibilityIdentifier(_ identifier: String, where inclusionTest: ((UIBarButtonItem) -> Bool)? = nil) -> UIBarButtonItem? {
        for item in self.barButtonItems {
            if item.accessibilityIdentifier == identifier && (inclusionTest?(item) ?? true) {
                return item
            }
        }

        return nil
    }

	/// Returns one of the receiver's items with the specified accessibiliity label.
	///
	/// - Parameters:
	///   - label: The accessibiliity label to match.
	///   - inclusionTest: An optional test to exclude individual items.
	/// - Returns: The matching bar button item (if any).
	///
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
	/// Returns one of the receiver's items with the specified accessibiliity identifier.
	///
	/// - Parameters:
	///   - identifier: The accessibiliity identifier to match.
	///   - inclusionTest: An optional test to exclude individual items.
	/// - Returns: The matching tab bar item (if any).
	///
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

	/// Returns one of the receiver's items with the specified accessibiliity label.
	///
	/// - Parameters:
	///   - label: The accessibiliity label to match.
	///   - inclusionTest: An optional test to exclude individual items.
	/// - Returns: The matching tab bar item (if any).
	///
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
	/// Returns one of the receiver's items with the specified accessibiliity identifier.
	///
	/// - Parameters:
	///   - identifier: The accessibiliity identifier to match.
	///   - inclusionTest: An optional test to exclude individual items.
	/// - Returns: The matching bar button item (if any).
	///
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

	/// Returns one of the receiver's items with the specified accessibiliity label.
	///
	/// - Parameters:
	///   - label: The accessibiliity label to match.
	///   - inclusionTest: An optional test to exclude individual items.
	/// - Returns: The matching bar button item (if any).
	///
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
	/// Returns the receiver or one of its subviews with the specified accessibiliity identifier.
	///
	/// - Parameters:
	///   - identifier: The accessibiliity identifier to match.
	///   - inclusionTest: An optional test to exclude individual views.
	/// - Returns: The receiver or matching subview (if any).
	///
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

	/// Returns the receiver or one of its subviews with the specified accessibiliity label.
	///
	/// - Parameters:
	///   - label: The accessibiliity label to match.
	///   - inclusionTest: An optional test to exclude individual views.
	/// - Returns: The receiver or matching subview (if any).
	///
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
