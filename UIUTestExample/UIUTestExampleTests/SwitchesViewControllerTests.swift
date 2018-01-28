//
//  SwitchesViewControllerTests.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import XCTest
@testable import UIUTestExample

class SwitchesViewControllerTests: XCTestCase
{
    var viewController: SwitchesViewController!

    override func setUp() {
        super.setUp()

        UIViewController.initializeTestable()
        viewController = UIViewController.loadFromStoryboard(identifier: "SwitchesViewController") as! SwitchesViewController
    }

    func testToggleButton() {
        let view = viewController.view!
        let toggleButton = view.viewWithAccessibilityIdentifier("BulbToggle") as! UIButton
        let bulbLabel = view.viewWithAccessibilityIdentifier("ButtonBulb") as! UILabel

        XCTAssertTrue(bulbLabel.isHidden)
        toggleButton.simulateTouch()
        XCTAssertFalse(bulbLabel.isHidden)
        toggleButton.simulateTouch()
        XCTAssertTrue(bulbLabel.isHidden)
    }

    func testBulbSwitch() {
        let view = viewController.view!
        let bulbSwitch = view.viewWithAccessibilityIdentifier("BulbSwitch") as! UISwitch
        let bulbLabel = view.viewWithAccessibilityIdentifier("SwitchBulb") as! UILabel

        XCTAssertTrue(bulbLabel.isHidden)
        XCTAssertFalse(bulbSwitch.isOn)
        bulbSwitch.simulateTouch()
        XCTAssertFalse(bulbLabel.isHidden)
        XCTAssertTrue(bulbSwitch.isOn)
        bulbSwitch.simulateTouch()
        XCTAssertTrue(bulbLabel.isHidden)
        XCTAssertFalse(bulbSwitch.isOn)
    }

    func testBulbSlider() {
        let view = viewController.view!
        let bulbSlider = view.viewWithAccessibilityIdentifier("BulbSlider") as! UISlider
        let lightBulbLabel = view.viewWithAccessibilityIdentifier("SliderBulb") as! UILabel
        let sliderAlphaLabel = view.viewWithAccessibilityIdentifier("SliderAlphaLabel") as! UILabel

        bulbSlider.simulateSwipe(toValue: 0.5)
        XCTAssertEqual(lightBulbLabel.alpha, 0.5)
        XCTAssertEqual(sliderAlphaLabel.text, "50%")

        bulbSlider.simulateSwipe(toValue: 1.0)
        XCTAssertEqual(lightBulbLabel.alpha, 1.0)
        XCTAssertEqual(sliderAlphaLabel.text, "100%")

        bulbSlider.simulateSwipe(toValue: 0.0)
        XCTAssertEqual(lightBulbLabel.alpha, 0.0)
        XCTAssertEqual(sliderAlphaLabel.text, "0%")
    }
}
