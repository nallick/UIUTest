//
//  Authentication.swift
//  UIUTestExampleTests
//
//  Created by Tyler Thompson on 8/26/18.
//  Copyright © 2018 Purgatory Design. All rights reserved.
//

import Foundation
import CucumberSwift
import UIUTest
import XCTest
import UIUTestExample

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

extension Cucumber {
    func setupAuthenticationTests() {
        var viewController: AuthenticationViewController!
        var userNameField: UITextField!
        var passwordField: UITextField!
        var showPasswordButton: UIButton!
        var authenticateButton: UIButton!
        var invalidCredentialsLabel: UILabel!

		UIViewController.initializeTestable()

        MatchAll("^I am not logged in$") { _, _ in
            viewController = (UIViewController.loadFromStoryboard(identifier: "Authentication") as! AuthenticationViewController)
            let view = viewController.view!
            userNameField = (view.viewWithAccessibilityIdentifier("userName") as! UITextField)
            passwordField = (view.viewWithAccessibilityIdentifier("password") as! UITextField)
            showPasswordButton = (view.viewWithAccessibilityIdentifier("showPassword") as! UIButton)
            authenticateButton = (view.viewWithAccessibilityIdentifier("authenticate") as! UIButton)
            invalidCredentialsLabel = (view.viewWithAccessibilityIdentifier("invalidCredentials") as! UILabel)
            XCTAssertFalse(authenticateButton.isEnabled)
        }
        When("^I enter a valid username$") { _, _ in
            userNameField.simulateTouch()
            userNameField.simulateTyping("Test User")
        }
        When("^I have not entered a valid username$") { _, _ in
            userNameField.simulateTouch()
            userNameField.simulateTyping(nil)
        }
        MatchAll("^I enter a valid password$") { _, _ in
            passwordField.simulateTouch()
            passwordField.simulateTyping("Test Password")
        }
        When("^I enter valid credentials$") { _, _ in
            viewController.setAuthenticator(TestAuthenticator())
            userNameField.text = TestAuthenticator.validUser
            passwordField.setTextAndNotify(TestAuthenticator.validPassword)
        }
        Then("^I can sign in$") { _, _ in
            XCTAssertTrue(authenticateButton.isEnabled)
        }
        Then("^I can't sign in$") { _, _ in
            XCTAssertFalse(authenticateButton.isEnabled)
        }
        Then("^My password is not obscured$") { _, _ in
            XCTAssertFalse(viewController.passwordIsSecure)
            XCTAssertFalse(passwordField.isSecureTextEntry)
            XCTAssertEqual(showPasswordButton.currentTitle!, "HIDE")
        }
        Then("^I see the next screen$") { _, _ in
            XCTAssertTrue(viewController.hasBeenDismissed)
        }
        And("^I want to see what I typed$") { _, _ in
            XCTAssertTrue(viewController.passwordIsSecure)
            XCTAssertTrue(passwordField.isSecureTextEntry)
            XCTAssertEqual(showPasswordButton.currentTitle!, "SHOW")
            showPasswordButton.simulateTouch()
        }
        And("^I sign in$") { _, _ in
            authenticateButton.simulateTouch()
        }
        But("^I enter an invalid password$") { _, _ in
            passwordField.setTextAndNotify(TestAuthenticator.invalidPassword)
        }
    }
}
