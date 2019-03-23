//
//  UIGestureRecognizerTestable.swift
//
//  Copyright © 2018-2019 Purgatory Design. Licensed under the MIT License.
//

import UIKit.UIGestureRecognizerSubclass
import XCTest

public extension UIGestureRecognizer
{
	private typealias TargetActionPair = (target: AnyObject, action: Selector)

	/// The associated object keys for testable extensions.
	///
	private static var testableExpectationKey = 0
	private static var testableSimulatedStateKey = 0

	/// The expectation currently being tested (if any).
	///
	private(set) var testableExpectation: XCTestExpectation? {
		get {
			return self.associatedObject(forKey: &UIGestureRecognizer.testableExpectationKey) ?? nil
		}
		set {
			self.setAssociatedObject(newValue, forKey: &UIGestureRecognizer.testableExpectationKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}

	/// A state to override the native state (if any).
	///
	private(set) var simulatedState: UIGestureRecognizer.State? {
		get {
			guard let boxedState: NSNumber = self.associatedObject(forKey: &UIGestureRecognizer.testableSimulatedStateKey) else { return nil }
			return UIGestureRecognizer.State(rawValue: boxedState.intValue)
		}
		set {
			if let state = newValue?.rawValue {
				let boxedState = NSNumber(value: state)
				self.setAssociatedObject(boxedState, forKey: &UIGestureRecognizer.testableSimulatedStateKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			} else {
				self.removeAssociatedObject(forKey: &UIGestureRecognizer.testableSimulatedStateKey)
			}
		}
	}

	/// Returns the target/action pairs for the receiver.
	///
	private var targetActionPairs: [TargetActionPair] {
		guard let targets = self.value(forKey: "_targets") as? [NSObject] else { return [] }
		return targets.reduce(into: []) { result, target in
			guard let wrappedTarget = target.value(forKey: "target") as? NSObject else { return }
			let wrappedAction = target.selector(forKey: "action")
			result.append((target: wrappedTarget, action: wrappedAction))
		}
	}

	///	A gesture has been recognized. Fulfill any pending expectation.
	///
	@objc private func _testableGestureRecognized() {
		if self.state == .recognized {
			self.removeTarget(self, action: #selector(_testableGestureRecognized))
			self.testableExpectation?.fulfill()
			self.testableExpectation = nil
		}
	}

	/// An alternate method to be swizzled with the UIGestureRecognizer.state getter.
	///
	@objc func substitute_state_getter() -> Int {
		return self.simulatedState?.rawValue ?? self.substitute_state_getter()
	}

	/// Create an XCTest expectation which will be fulfilled by a gesture recognition.
	///
	/// - Returns: An expectation for recognition.
	///
	func expectRecognizedState() -> XCTestExpectation {
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

	/// Send all actions associated with the receiver.
	///
	/// - Parameter waitUntilDone: Specifies if this method will wait to return until all actions have been performed.
	///
	func sendActions(waitUntilDone: Bool = true) {
		for targetAction in self.targetActionPairs {
			if targetAction.target.responds(to: targetAction.action) {
				targetAction.target.performSelector(onMainThread: targetAction.action, with: self, waitUntilDone: waitUntilDone)
			}
		}
	}

	/// Simulate moving to recognized state in the receiver.
	///
	/// - Parameter state: The simulated state of the receiver during recognition.
	///
	func simulateRecognition(state: UIGestureRecognizer.State = .recognized) {
		guard self.isEnabled && self.state == .possible else { return }
		UIGestureRecognizer.classInitialized   // reference the singleton to ensure initialization is called once and only once

		self.simulatedState = state
		self.sendActions()
		self.simulatedState = nil
	}

	/// Initialize the testable extensions of UIGestureRecognizer. This singleton is only executed once.
	///
	private static let classInitialized: Void = {
		UIGestureRecognizer.self.exchangeMethods(#selector(getter: state), #selector(substitute_state_getter))
	}()
}

public extension XCTestCase
{
	/// Wait for the recognized state of a gesture recognizer.
	///
	/// - Parameters:
	///   - gestureRecognizer: The gesture recognizer to wait for.
	///   - seconds: The wait timeout (in seconds).
	///
	func waitForRecognizedState(of gestureRecognizer: UIGestureRecognizer, timeout seconds: TimeInterval = 0.1) {
		let expectation = gestureRecognizer.expectRecognizedState()
		self.wait(for: [expectation], timeout: seconds)
	}
}
