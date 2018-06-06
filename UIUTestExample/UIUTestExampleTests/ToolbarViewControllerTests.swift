//
//  ToolbarViewControllerTests.swift
//
//  Copyright © 2018 Purgatory Design. Licensed under the MIT License.
//

import XCTest
import UIUTestExample

class ToolbarViewControllerTests: XCTestCase
{
	let expectedToolbarItemTitles = ["🐲", "🐉", "🦎", "🦖", "🐍", "🐢", "🦋"]
	var viewController: ToolbarViewController!
	var view: UIView!

	override func setUp() {
		super.setUp()

		UIViewController.initializeTestable()
		viewController = (UIViewController.loadFromStoryboard(identifier: "ToolbarViewController") as! ToolbarViewController)
		view = viewController.view!
	}

	func testToolbarInitializedWithExpectedItemCount() {
		let toolbar = view.viewWithAccessibilityIdentifier("Toolbar") as! UIToolbar

		XCTAssertEqual(toolbar.items?.count, 2*expectedToolbarItemTitles.count + 1)
	}

	func testToolbarPaddedWithFlexibleSpace() {
		let toolbar = view.viewWithAccessibilityIdentifier("Toolbar") as! UIToolbar
		let toolbarItems = toolbar.items!

		for index in stride(from: 0, to: toolbarItems.count, by: 2) {
			XCTAssertEqual(toolbarItems[index].systemItemStyle, .flexibleSpace)
		}
	}

	func testToolbarInitializedWithExpectedItemTitles() {
		let toolbar = view.viewWithAccessibilityIdentifier("Toolbar") as! UIToolbar
		let toolbarItems = toolbar.items!

		var itemIndex = 1
		for titleIndex in 0 ..< expectedToolbarItemTitles.count {
			XCTAssertEqual(toolbarItems[itemIndex].title, expectedToolbarItemTitles[titleIndex])
			itemIndex += 2
		}
	}

	func testLabelHasCorrectDropShadow() {
		let toolLabel = view.viewWithAccessibilityIdentifier("ToolLabel") as! UILabel
		let labelLayer = toolLabel.layer

		XCTAssertEqual(labelLayer.shadowColor, UIColor.black.cgColor)
		XCTAssertEqual(labelLayer.shadowOffset, CGSize(width: 6.0, height: 6.0))
		XCTAssertEqual(labelLayer.shadowOpacity, 0.5)
		XCTAssertEqual(labelLayer.shadowRadius, 18.0)
	}

	func testLabelStartsWithExpectedText() {
		let toolLabel = view.viewWithAccessibilityIdentifier("ToolLabel") as! UILabel

		XCTAssertEqual(toolLabel.text, expectedToolbarItemTitles[0])
	}

	func testToolbarItemsSetExpectedLabelText() {
		let toolbar = view.viewWithAccessibilityIdentifier("Toolbar") as! UIToolbar
		let toolLabel = view.viewWithAccessibilityIdentifier("ToolLabel") as! UILabel
		let toolbarItems = toolbar.items!
//		toolbar.loadItems()

		for index in stride(from: 1, to: toolbarItems.count, by: 2) {
			let toolbarItem = toolbarItems[index]
			toolbarItem.simulateTouch()
//			toolbar.simulateTouchInItem(at: index)

			XCTAssertEqual(toolLabel.text, toolbarItem.title)
		}
	}
}
