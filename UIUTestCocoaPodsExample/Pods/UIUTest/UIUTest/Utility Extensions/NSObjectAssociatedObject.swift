//
//  NSObjectAssociatedObject.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//
//  Based on Stack Overflow post from HepaKKes: http://stackoverflow.com/a/29662565/8047
//

import Foundation

/// A wrapper to make a value into a class object.
///
final class LiftedValue<T>
{
	let value: T
	init(_ value: T) {
		self.value = value
	}
}

public extension NSObject
{
	/// Get an associated object from this object.
	///
	/// - Parameter key: the associated object key
	/// - Returns: the associated object
    ///
	public func associatedObject<T>(forKey key: UnsafeRawPointer) -> T? {
		if let value = objc_getAssociatedObject(self, key) as? T {
			return value
		}
		else if let liftedValue = objc_getAssociatedObject(self, key) as? LiftedValue<T> {
			return liftedValue.value
		}
		return nil
	}

    /// Set an associated object of this object.
    ///
    /// - Parameters:
    ///   - value: the associated object value
    ///   - key: the associated object key
    ///   - policy: the object's Obj-C runtime policy
    ///
    public func setAssociatedObject<T>(_ value: T, forKey key: UnsafeRawPointer, policy: objc_AssociationPolicy) {
        if let objectValue = value as? NSObject {
            objc_setAssociatedObject(self, key, objectValue, policy)
        }
        else {
            objc_setAssociatedObject(self, key, lift(value: value), policy)
        }
    }

    /// Remove an associated object from this object.
    ///
    /// - Parameters:
    ///   - key: the associated object key
    ///
    public func removeAssociatedObject(forKey key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, nil, .OBJC_ASSOCIATION_ASSIGN)
    }

	private func lift<T>(value: T) -> LiftedValue<T> {
		return LiftedValue(value)
	}
}
