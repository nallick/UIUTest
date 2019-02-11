//
//  UIViewExtensions.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIView
{
	/// Returns the view controller that owns the receiver (if any).
	///
    var viewController: UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            responder = responder!.next
            if let result = responder as? UIViewController {
                return result
            }
        }
        return nil
    }

	/// Returns the topmost superview of the receiver in it's view hierarchy (if any).
	///
	/// - Note:	Normally this is a window.
	///
	var topSuperview: UIView? {
		guard var result = self.superview else { return nil }
		while let nextSuperview = result.superview {
			result = nextSuperview
		}

		return result
	}

    /// Specifies if a view is a subview in the receiver's view hierarchy.
    ///
    /// - Parameter subview: The view to test.
	/// - Returns: true if the specified view is in the receiver's view hierarchy; false otherwise.
	///
    func contains(subview: UIView?) -> Bool {
        var testView = subview?.superview
        while testView != nil {
            if testView! === self { return true }
            testView = testView!.superview
        }

        return false
    }

    /// Returns the first view in the receiver's subview hierarchy which is a kind of a specific type.
    ///
    /// - Parameter type: The type of the subview to find.
    /// - Returns: The first subview of the specified type (of any).
	///
    func subview(ofType type: UIView.Type) -> UIView? {
        return self.subviews.first(where: { $0.isKind(of: type) })
    }

	/// Returns the first view in the receiver's superview hierarchy which is a kind of a specific type.
	///
	/// - Parameter type: The type of the subview to find.
	/// - Returns: The first superview of the specified type (of any).
	///
    func superview<T>(ofType type: T.Type) -> T? {
        return self.superview as? T ?? self.superview.flatMap { $0.superview(ofType: type) }
    }
}
