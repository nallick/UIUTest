//
//  UIGestureRecognizerTestable.swift
//
//  Copyright © 2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit.UIGestureRecognizerSubclass
import XCTest

public extension UIGestureRecognizer
{
	private static var testableExpectationKey = 0

	public private(set) var testableExpectation: XCTestExpectation? {
		get {
			return self.associatedObject(forKey: &UIGestureRecognizer.testableExpectationKey) ?? nil
		}
		set {
			self.setAssociatedObject(newValue, forKey: &UIGestureRecognizer.testableExpectationKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}

	@objc private func _testableGestureRecognized() {
		if self.state == .recognized {
			self.removeTarget(self, action: #selector(_testableGestureRecognized))
			self.testableExpectation?.fulfill()
			self.testableExpectation = nil
		}
	}

	public func expectRecognizedState() -> XCTestExpectation {
		let expectation = XCTestExpectation(description: "UIGestureRecognizer Testable")

		guard self.isEnabled else {
			expectation.fulfill()
			return expectation
		}

		self.addTarget(self, action: #selector(_testableGestureRecognized))
		self.testableExpectation = expectation

		self.state = .changed
		self.state = .recognized

		return expectation
	}
}

public extension XCTestCase
{
	public func waitForRecognizedState(of gestureRecognizer: UIGestureRecognizer, timeout seconds: TimeInterval = 0.1) {
		let expectation = gestureRecognizer.expectRecognizedState()
		self.wait(for: [expectation], timeout: seconds)
	}
}
