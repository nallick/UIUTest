//
//  UIViewExtensions.swift
//
//  Copyright © 2017-2019 Purgatory Design. Licensed under the MIT License.
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
	/// - Parameters:
	///   - deep: If true, find a subview anywhere in the full subview hierarchy, otherwise only find immediate subviews.
	///   - type: The type of the subview to find.
	/// - Returns: The first superview of the specified type (if any).
	///
	func subview(deep: Bool = false, ofType type: UIView.Type) -> UIView? {
		return self.subview(deep: deep, where: { $0.isKind(of: type) })
	}

	/// Returns the first view in the receiver's superview hierarchy which is a kind of a specific type.
	///
	/// - Parameter type: The type of the subview to find.
	/// - Returns: The first superview of the specified type (if any).
	///
    func superview<T>(ofType type: T.Type) -> T? {
        return self.superview as? T ?? self.superview.flatMap { $0.superview(ofType: type) }
    }

	/// Returns the first view in the receiver's superview hierarchy which matches the supplied predicate.
	///
	/// - Parameter predicate: The function to specify matches.
	/// - Returns: The first superview which matches the predicate (if any).
	///
	func superview(where predicate: @escaping (UIView) -> Bool) -> UIView? {
		guard let superview = self.superview else { return nil }
		if predicate(superview) { return superview }
		return self.superview.flatMap { $0.superview(where: predicate) }
	}

	/// Returns the first view in the receiver's subview hierarchy which matches the supplied predicate.
	///
	/// - Parameters:
	///   - deep: If true, find a subview anywhere in the full subview hierarchy, otherwise only find immediate subviews.
	///   - predicate: The function to specify matches.
	/// - Returns: The first subview which matches the predicate (if any).
	///
	func subview(deep: Bool = false, where predicate: @escaping (UIView) -> Bool) -> UIView? {
		if deep {
			for subview in self.subviews {
				if predicate(subview) { return subview }
				let result = subview.subview(deep: true, where: predicate)
				if let _ = result { return result }
			}

			return nil
		}

		return self.subviews.first(where: { predicate($0) })
	}
}
