//
//  ButtonsViewControllerTests.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import XCTest
import UIUTestExample

class ButtonsViewControllerTests: XCTestCase
{
    override func setUp() {
        super.setUp()
        UIViewController.initializeTestable()
    }

	override func tearDown() {
		super.tearDown()
		UIViewController.flushPendingTestArtifacts()
	}

    func testSegueFromNextButtonToNextViewController() {
        let viewController = UIViewController.loadFromStoryboard(identifier: "ButtonsViewController") as! ButtonsViewController
        let nextButton = viewController.view!.viewWithAccessibilityIdentifier("Next") as! UIButton

        nextButton.simulateTouch()

        let segue = viewController.mostRecentlyPerformedSegue!
        XCTAssertEqual(segue.identifier, "Next")
        XCTAssertNotNil(segue.destination as? SwitchesViewController)
    }

    func testAlternateButtonToNextViewController() {
        let viewController = UIViewController.loadFromStoryboard(identifier: "ButtonsViewController", forNavigation: true) as! ButtonsViewController
        let navigationController = viewController.navigationController!
        let alternateButton = viewController.view!.viewWithAccessibilityIdentifier("Alternate") as! UIButton

        alternateButton.simulateTouch()
		UIView.allowAnimation()

        XCTAssertNotNil(navigationController.topViewController as? SwitchesViewController)
    }

	func testAlternateButtonFailsIfNotViewController() {
		let viewController = UIViewController.loadFromStoryboard(identifier: "ButtonsViewController", forNavigation: true) as! ButtonsViewController
		let navigationController = viewController.navigationController!
		navigationController.pushViewController(UIViewController(), animated: false)
		let alternateButton = viewController.view!.viewWithAccessibilityIdentifier("Alternate") as! UIButton

		alternateButton.simulateTouch()
		UIView.allowAnimation()

		XCTAssertNil(navigationController.topViewController as? SwitchesViewController)
	}

    func testCountMethodSelection() {
        let viewController = UIViewController.loadFromStoryboard(identifier: "ButtonsViewController") as! ButtonsViewController
        let view = viewController.view!
        let segmentedControl = view.viewWithAccessibilityIdentifier("CountMethodSegment") as! UISegmentedControl
        let countStepper = view.viewWithAccessibilityIdentifier("CountStepper") as! UIStepper
        let collectionView = view.viewWithAccessibilityIdentifier("ButtonCollection") as! UICollectionView

        XCTAssertFalse(collectionView.isHidden)
        XCTAssertTrue(countStepper.isHidden)

        segmentedControl.simulateTouchInSegment(at: 1)
        XCTAssertFalse(countStepper.isHidden)
        XCTAssertTrue(collectionView.isHidden)

        segmentedControl.simulateTouchInSegment(at: 0)
        XCTAssertFalse(collectionView.isHidden)
        XCTAssertTrue(countStepper.isHidden)
    }

    func testButtonCollectionChangesLabel() {
        let viewController = UIViewController.loadFromStoryboard(identifier: "ButtonsViewController") as! ButtonsViewController
        let view = viewController.view!
        let label = view.viewWithAccessibilityIdentifier("Label") as! UILabel
        let collectionView = view.viewWithAccessibilityIdentifier("ButtonCollection") as! UICollectionView
        UICollectionView.loadDataForTesting()

        let testIndex1 = IndexPath(item: 0, section: 0)
        collectionView.simulateTouch(at: testIndex1)
        XCTAssertTrue(collectionView.itemIsSelected(at: testIndex1))
        XCTAssertEqual(label.text!, "1")

        let testIndex8 = IndexPath(item: 7, section: 0)
        collectionView.simulateTouch(at: testIndex8)
        XCTAssertTrue(collectionView.itemIsSelected(at: testIndex8))
        XCTAssertEqual(label.text!, "8")
    }

	func testButtonCollectionResetsLabel() {
		let viewController = UIViewController.loadFromStoryboard(identifier: "ButtonsViewController") as! ButtonsViewController
		let view = viewController.view!
		let label = view.viewWithAccessibilityIdentifier("Label") as! UILabel
		let collectionView = view.viewWithAccessibilityIdentifier("ButtonCollection") as! UICollectionView
		UICollectionView.loadDataForTesting()

		let testIndex1 = IndexPath(item: 0, section: 0)
		collectionView.simulateTouch(at: testIndex1)
		XCTAssertTrue(collectionView.itemIsSelected(at: testIndex1))
		XCTAssertEqual(label.text!, "1")

		collectionView.simulateTouch(at: testIndex1)
		XCTAssertFalse(collectionView.itemIsSelected(at: testIndex1))
		XCTAssertEqual(label.text!, "0")
	}

	func testStepperChangesLabel() {
		let viewController = UIViewController.loadFromStoryboard(identifier: "ButtonsViewController") as! ButtonsViewController
		let view = viewController.view!
		let label = view.viewWithAccessibilityIdentifier("Label") as! UILabel
		let segmentedControl = view.viewWithAccessibilityIdentifier("CountMethodSegment") as! UISegmentedControl
		let countStepper = view.viewWithAccessibilityIdentifier("CountStepper") as! UIStepper

		XCTAssertEqual(countStepper.value, 1.0)

		segmentedControl.simulateTouchInSegment(at: 1)
		countStepper.simulateTouchInIncrement()

		XCTAssertEqual(countStepper.value, 2.0)
		XCTAssertEqual(label.text!, "2")


		countStepper.simulateTouchInDecrement()
		XCTAssertEqual(countStepper.value, 1.0)
		XCTAssertEqual(label.text!, "1")
	}

	func testReselectingCollectionChangesLabel() {
		let viewController = UIViewController.loadFromStoryboard(identifier: "ButtonsViewController") as! ButtonsViewController
		let view = viewController.view!
		let label = view.viewWithAccessibilityIdentifier("Label") as! UILabel
		let segmentedControl = view.viewWithAccessibilityIdentifier("CountMethodSegment") as! UISegmentedControl
		let collectionView = view.viewWithAccessibilityIdentifier("ButtonCollection") as! UICollectionView
		UICollectionView.loadDataForTesting()

		let testIndex10 = IndexPath(item: 9, section: 0)
		collectionView.simulateTouch(at: testIndex10)
		XCTAssertEqual(label.text!, "10")

		segmentedControl.simulateTouchInSegment(at: 1)
		XCTAssertEqual(label.text!, "1")

		segmentedControl.simulateTouchInSegment(at: 0)
		XCTAssertEqual(label.text!, "10")
	}
}
