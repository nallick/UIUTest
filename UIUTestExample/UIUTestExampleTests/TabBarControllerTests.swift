//
//  TabBarControllerTests.swift
//
//  Copyright © 2018 Purgatory Design. Licensed under the MIT License.
//

import XCTest
import UIUTestExample

class TabBarControllerTests: XCTestCase
{
	var viewController: UITabBarController!

	override func setUp() {
		super.setUp()

		UIViewController.initializeTestable()
		viewController = (UIViewController.loadFromStoryboard() as! UITabBarController)
	}

	override func tearDown() {
		super.tearDown()
		UIViewController.flushPendingTestArtifacts()
	}

	func testTabsInitializedWithExpectedTypes() {
		XCTAssertEqual(viewController.viewControllers?.count, 2)
		XCTAssertNotNil(viewController.viewControllers?[0] as? ToolbarViewController)
		XCTAssertNotNil(viewController.viewControllers?[1] as? UINavigationController)
	}

	func testNavigationTabConnectsToTableView() {
		let navigationController = viewController.viewControllers?[1] as! UINavigationController

		XCTAssertNotNil(navigationController.topViewController as? TableViewController)
	}
}
