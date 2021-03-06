//
//  UIResponderExtensions.swift
//
//  Copyright © 2019 Purgatory Design. Licensed under the MIT License.
//

import UIKit

@nonobjc public extension UIResponder
{
	/// Returns the next responder in the receiver's responder chain which is a kind of a specific type.
	///
	/// - Parameter type: The type of the responder to find.
	/// - Returns: The first responder of the specified type (if any).
	///
	func nextResponder<T>(ofType type: T.Type) -> T? {
		return self.next as? T ?? self.next.flatMap { $0.nextResponder(ofType: type) }
	}

	/// Returns the next responder in the receiver's responder chain which matches the supplied predicate.
	///
	/// - Parameter predicate: The function to specify matches.
	/// - Returns: The first responder which matches the predicate (if any).
	///
	func nextResponder(where predicate: @escaping (UIResponder) -> Bool) -> UIResponder? {
		guard let nextResponder = self.next else { return nil }
		return predicate(nextResponder) ? nextResponder : self.next.flatMap { $0.nextResponder(where: predicate) }
	}
}
