//
//  XCTestCaseExtensions.swift
//
//  Copyright © 2018 Purgatory Design. Licensed under the MIT License.
//

import XCTest

public extension XCTestCase
{
	/// Wait for all closures on a DispatchQueue to be dispatched.
	///
	/// - Parameters:
	///   - dispatchQueue: the queue to wait for
	///   - seconds: the wait timeout
	///   - description: the expectation description
	///
	func flushDispatchQueue(_ dispatchQueue: DispatchQueue = DispatchQueue.main, timeout seconds: TimeInterval = 0.1, description: String = "Wait for DispatchQueue") {
		let expectation = self.expectation(description: description)
		dispatchQueue.async { expectation.fulfill() }
		self.wait(for: [expectation], timeout: seconds)
	}
}
