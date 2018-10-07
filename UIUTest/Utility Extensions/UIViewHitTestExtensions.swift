//
//  UIViewHitTestExtensions.swift
//
//  Copyright © 2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIView
{
	/// Returns a string containing the value of the hex pointer to the receiver.
	///
	public var pointerDescription: String {
		return "\(Unmanaged.passUnretained(self).toOpaque())"
	}

	/// Returns a string containing a description of the receiver as a hit test result.
	///
	/// - Parameter point: A point specified in the receiver's local coordinate system.
	/// - Returns: The description string.
	///
	public func hitTestDescription(at point: CGPoint) -> String {
		let pointInside = self.point(inside: point, with: nil)
		let hitTest = self.hitTest(point, with: nil)
		return "<\(type(of: self)): \(self.pointerDescription); point = \(point.debugDescription); frame = \(self.frame.debugDescription); tag = \(self.tag); pointInside = \(pointInside); hitTest = \(hitTest?.pointerDescription ?? "nil")>"
	}

	/// Returns a string containing a description of walking the receiver's view hierarchy as a hit test would.
	///
	/// - Parameter point: A point specified in the receiver's local coordinate system.
	/// - Returns: The description string.
	///
	public func recursiveHitTestDescription(at point: CGPoint) -> String {
		var result = ""
		self.recursiveHitTestDescription(&result, at: point, level: 0)
		return result
	}

	/// Prints the text returned from recursiveHitTestDescription().
	///
	/// - Parameter point: A point specified in the receiver's local coordinate system.
	///
	public func printRecursiveHitTestDescription(at point: CGPoint) {
		self.recursiveHitTestDescription(at: point)
			.split(separator: "\n")
			.forEach({ print($0) })
	}

	/// Updates a string containing a description of walking the receiver's view hierarchy as a hit test would.
	///
	/// - Parameters:
	///   - result: The description string (inout).
	///   - point: A point specified in the receiver's local coordinate system.
	///   - level: The level of the receiver within it's enclosing view hierarchy.
	///
	private func recursiveHitTestDescription(_ result: inout String, at point: CGPoint, level: Int) {
		for _ in 0 ..< level { result += "   | " }
		result += self.hitTestDescription(at: point) + "\n"

		if self.point(inside: point, with: nil) {
			let nextLevel = level + 1
			for subview in self.subviews.reversed() {
				let localPoint = self.convert(point, to: subview)
				subview.recursiveHitTestDescription(&result, at: localPoint, level: nextLevel)
			}
		}
	}
}
