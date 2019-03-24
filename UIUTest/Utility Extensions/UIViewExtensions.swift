//
//  UIViewExtensions.swift
//
//  Copyright © 2017-2019 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIView
{
	/// Returns true if the receiver isn't hidden.
	///
	var isNotHidden: Bool {
		return !self.isHidden
	}

	/// Returns true if the receiver and all its superviews are not hidden or fully transparent.
	///
	/// - Note:	This doesn't cover the case where the receiver is clipped by a superview (e.g., it is scrolled out of view).
	///
	var isVisible: Bool {
		return (self.isHidden || self.alpha == 0.0) ? false : self.superview?.isVisible ?? true
	}

	/// Returns the view controller that owns the receiver (if any).
	///
    var viewController: UIViewController? {
		return self.firstResponder(where: { ($0 as? UIViewController)?.view.contains(self) ?? false }) as? UIViewController
    }

	/// Returns the topmost superview of the receiver in it's view hierarchy (if any).
	///
	/// - Note:	Normally this is a window.
	///
	var topSuperview: UIView? {
		return self.superview { $0.superview == nil }
	}

    /// Specifies if a view is a subview in the receiver's view hierarchy.
    ///
    /// - Parameter subview: The view to test.
	/// - Returns: true if the specified view is in the receiver's view hierarchy; false otherwise.
	///
    func contains(subview: UIView?) -> Bool {
		return subview?.superview(where: { $0 === self }) != nil
    }

	/// Returns the first view in the receiver's superview hierarchy which is a kind of a specific type.
	///
	/// - Parameter type: The type of the subview to find.
	/// - Returns: The first superview of the specified type (if any).
	///
    func superview<T>(ofType type: T.Type) -> T? {
        return self.superview as? T ?? self.superview.flatMap { $0.superview(ofType: type) }
    }

	/// Returns the first view in the receiver's subview hierarchy which is a kind of a specific type.
	///
	/// - Parameters:
	///   - deep: If true, find a subview anywhere in the full subview hierarchy, otherwise only find immediate subviews.
	///   - type: The type of the subview to find.
	/// - Returns: The first superview of the specified type (if any).
	///
	func subview<T>(deep: Bool = false, ofType type: T.Type) -> T? where T: UIView {
		return self.subview(deep: deep, where: { $0.isKind(of: type) }) as? T
	}

	/// Returns the first view in the receiver's superview hierarchy which matches the supplied predicate.
	///
	/// - Parameter predicate: The function to specify matches.
	/// - Returns: The first superview which matches the predicate (if any).
	///
	func superview(where predicate: @escaping (UIView) -> Bool) -> UIView? {
		guard let superview = self.superview else { return nil }
		return predicate(superview) ? superview : self.superview.flatMap { $0.superview(where: predicate) }
	}

	/// Returns the first view in the receiver's subview hierarchy which matches the supplied predicate.
	///
	/// - Parameters:
	///   - deep: If true, find a subview anywhere in the full subview hierarchy, otherwise only find immediate subviews.
	///   - predicate: The function to specify matches.
	/// - Returns: The first subview which matches the predicate (if any).
	///
	func subview(deep: Bool = false, where predicate: @escaping (UIView) -> Bool) -> UIView? {
		if deep { return self.subviews.compactMap({ predicate($0) ? $0 : $0.subview(deep: true, where: predicate) }).first }
		return self.subviews.first { predicate($0) }
	}
}
