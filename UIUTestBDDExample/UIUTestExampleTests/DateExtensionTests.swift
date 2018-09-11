//
//  DateExtensionTests.swift
//
//  Copyright © 2018 Purgatory Design. Licensed under the MIT License.
//

import XCTest
import UIUTestExample
import UIUTest

class DateExtensionTests: XCTestCase
{
	func testToday() {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MM/dd/yyyy"
		let now = Date()

		let today = Date.today

		XCTAssertEqual(dateFormatter.string(from: today), dateFormatter.string(from: now))
	}

	func testTomorrow() {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MM/dd/yyyy"
		let nowPlus24Hours = Date(timeIntervalSinceNow: 60.0*60.0*24.0)

		let tomorrow = Date.tomorrow

		XCTAssertEqual(dateFormatter.string(from: tomorrow), dateFormatter.string(from: nowPlus24Hours))
	}

	func testYesterday() {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MM/dd/yyyy"
		let nowLess24Hours = Date(timeIntervalSinceNow: -60.0*60.0*24.0)

		let yesterday = Date.yesterday

		XCTAssertEqual(dateFormatter.string(from: yesterday), dateFormatter.string(from: nowLess24Hours))
	}

	func testDayOfWeek() {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "EEEE"
		let now = Date()

		let dayOfWeek = now.dayOfWeek

		XCTAssertEqual(dateFormatter.string(from: now), dayOfWeek)
	}
}

