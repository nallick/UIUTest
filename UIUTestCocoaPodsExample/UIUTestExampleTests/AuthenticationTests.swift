//
//  AuthenticationTests.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import XCTest
import UIUTestExample
import UIUTest

struct TestAuthenticator: Authenticator
{
    static let validUser = "Test User"
    static let invalidUser = "Invalid User"
    static let validPassword = "Test Password"
    static let invalidPassword = "Invalid Password"

    func authenticate(user: String, password: String) -> Bool {
        return (user == TestAuthenticator.validUser && password == TestAuthenticator.validPassword)
    }
}

class AuthenticationTests: XCTestCase
{
    var viewController: AuthenticationViewController!
    var userNameField: UITextField!
    var passwordField: UITextField!
    var showPasswordButton: UIButton!
    var authenticateButton: UIButton!
    var invalidCredentialsLabel: UILabel!

    override func setUp() {
        super.setUp()

        UIViewController.initializeTestable()
		initializeTest()
	}

	override func tearDown() {
		super.tearDown()
		UIViewController.flushPendingTestArtifacts()
	}

	private func initializeTest() {
		viewController = (UIViewController.loadFromStoryboard(identifier: "Authentication") as! AuthenticationViewController)
		let view = viewController.view!
		userNameField = (view.viewWithAccessibilityIdentifier("userName") as! UITextField)
		passwordField = (view.viewWithAccessibilityIdentifier("password") as! UITextField)
		showPasswordButton = (view.viewWithAccessibilityIdentifier("showPassword") as! UIButton)
		authenticateButton = (view.viewWithAccessibilityIdentifier("authenticate") as! UIButton)
		invalidCredentialsLabel = (view.viewWithAccessibilityIdentifier("invalidCredentials") as! UILabel)
	}

    func testAuthenticateEnabled() {
        XCTAssertFalse(authenticateButton.isEnabled)

        userNameField.simulateTouch()
        userNameField.simulateTyping("Test User")
        XCTAssertFalse(authenticateButton.isEnabled)

        passwordField.simulateTouch()
        passwordField.simulateTyping("Test Password")
        XCTAssertTrue(authenticateButton.isEnabled)

        userNameField.simulateTouch()
        userNameField.simulateTyping(nil)
        XCTAssertFalse(authenticateButton.isEnabled)
    }
    
    func testSecurePasswordField() {
        XCTAssertTrue(viewController.passwordIsSecure)
        XCTAssertTrue(passwordField.isSecureTextEntry)
        XCTAssertEqual(showPasswordButton.currentTitle!, "SHOW")

        showPasswordButton.simulateTouch()

        XCTAssertFalse(viewController.passwordIsSecure)
        XCTAssertFalse(passwordField.isSecureTextEntry)
        XCTAssertEqual(showPasswordButton.currentTitle!, "HIDE")

        showPasswordButton.simulateTouch()

        XCTAssertTrue(viewController.passwordIsSecure)
        XCTAssertTrue(passwordField.isSecureTextEntry)
        XCTAssertEqual(showPasswordButton.currentTitle!, "SHOW")
    }

    func testValidCredentials() {
        viewController.setAuthenticator(TestAuthenticator())
        userNameField.text = TestAuthenticator.validUser
        passwordField.setTextAndNotify(TestAuthenticator.validPassword)

        authenticateButton.simulateTouch()

        XCTAssertTrue(viewController.hasBeenDismissed)
    }

    func testInvalidCredentials() {
        viewController.setAuthenticator(TestAuthenticator())
        userNameField.text = TestAuthenticator.invalidUser
        passwordField.setTextAndNotify(TestAuthenticator.validPassword)

        authenticateButton.simulateTouch()

        XCTAssertNil(viewController.mostRecentlyPerformedSegue)
        XCTAssertFalse(invalidCredentialsLabel.isHidden)

        userNameField.text = TestAuthenticator.validUser
        passwordField.setTextAndNotify(TestAuthenticator.invalidPassword)

        authenticateButton.simulateTouch()

        XCTAssertNil(viewController.mostRecentlyPerformedSegue)
        XCTAssertFalse(invalidCredentialsLabel.isHidden)
    }

	func testMissingAuthenticator() {
		let savedDefaultAuthenticator = AuthenticationViewController.defaultAuthenticator
		AuthenticationViewController.defaultAuthenticator = nil
		initializeTest()
		AuthenticationViewController.defaultAuthenticator = savedDefaultAuthenticator
		userNameField.text = TestAuthenticator.validUser
		passwordField.setTextAndNotify(TestAuthenticator.validPassword)

		authenticateButton.simulateTouch()

		XCTAssertFalse(viewController.hasBeenDismissed)
	}

    func testInvalidCredentialsLabelHidden() {
        viewController.setAuthenticator(TestAuthenticator())
        userNameField.text = TestAuthenticator.invalidUser
        passwordField.setTextAndNotify(TestAuthenticator.invalidPassword)

        authenticateButton.simulateTouch()
        XCTAssertFalse(invalidCredentialsLabel.isHidden)

        userNameField.simulateTouch()
        userNameField.simulateTyping(" ")
        XCTAssertTrue(invalidCredentialsLabel.isHidden)

        authenticateButton.simulateTouch()
        XCTAssertFalse(invalidCredentialsLabel.isHidden)

        passwordField.simulateTouch()
        passwordField.simulateTyping(" ")
        XCTAssertTrue(invalidCredentialsLabel.isHidden)
    }

    func testTextFieldsLimitInputLength() {
        let maxString = "123456789012345678901234"
        let maxLength = maxString.count

        userNameField.simulateTouch()
        userNameField.simulateTyping(maxString)
        XCTAssertEqual((userNameField.text?.count)!, maxLength)

        userNameField.simulateTyping("5")
        XCTAssertLessThanOrEqual((userNameField.text?.count)!, maxLength)

        passwordField.simulateTouch()
        passwordField.simulateTyping(maxString)
        XCTAssertEqual((passwordField.text?.count)!, maxLength)

        passwordField.simulateTyping("5")
        XCTAssertLessThanOrEqual((passwordField.text?.count)!, maxLength)
    }
}
