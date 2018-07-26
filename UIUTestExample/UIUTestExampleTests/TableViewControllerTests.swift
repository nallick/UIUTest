//
//  TableViewControllerTests.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import XCTest
import UIUTestExample

class TableViewControllerTests: XCTestCase
{
    var viewController: TableViewController!
    var tableView: UITableView!

    override func setUp() {
        super.setUp()

        UIViewController.initializeTestable()
		viewController = (UIViewController.loadFromStoryboard(identifier: "TableViewController") as! TableViewController)
        tableView = viewController.tableView!
    }

	override func tearDown() {
		super.tearDown()
		UIViewController.flushPendingTestArtifacts()
	}

    func testSegueFromInfoButtonToInfoViewController() {
        tableView.simulateAccessoryTouch(at: IndexPath(row: 1, section: 0))

        let segue = viewController.mostRecentlyPerformedSegue!
        XCTAssertEqual(segue.identifier, "Info")
        XCTAssertNotNil(segue.destination as? InfoViewController)
    }

    func testSegueFromTableToNextViewController() {
        tableView.simulateTouch(at: IndexPath(row: 2, section: 0))

        let segue = viewController.mostRecentlyPerformedSegue!
        XCTAssertEqual(segue.identifier, "Next")
        XCTAssertNotNil(segue.destination as? ButtonsViewController)
    }
 }
