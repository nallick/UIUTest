//
//  AuthenticationViewController.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

protocol Authenticator
{
    func authenticate(user: String, password: String) -> Bool
}

class AuthenticationViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet private var userNameField: UITextField!
    @IBOutlet private var passwordField: UITextField!
    @IBOutlet private var showPasswordButton: UIButton!
    @IBOutlet private var authenticateButton: UIButton!
    @IBOutlet private var invalidCredentialsLabel: UILabel!
    @IBInspectable var maxUserNameLength = 0
    @IBInspectable var maxPasswordLength = 0

    static var defaultAuthenticator: Authenticator?
    private var authenticator: Authenticator? = defaultAuthenticator

    var passwordIsSecure: Bool {
        get {
            return self.passwordField.isSecureTextEntry
        }
        set {
            self.passwordField.isSecureTextEntry = newValue
        }
    }

    func setAuthenticator(_ authenticator: Authenticator) {
        self.authenticator = authenticator
    }

    @IBAction private func showHidePassword(_ sender: AnyObject?) {
        let newSecureValue = !self.passwordIsSecure
        self.passwordIsSecure = newSecureValue
        self.showPasswordButton.setTitle(newSecureValue ? "SHOW" : "HIDE", for: .normal)
    }

    @IBAction private func authenticate(_ sender: AnyObject?) {
        if let userName = self.userNameField.text, let password = self.passwordField.text {
            let credentialsValid = self.authenticator?.authenticate(user: userName, password: password) ?? false
            if credentialsValid {
                self.dismiss(animated: true, completion: nil)
            }
            else {
                self.invalidCredentialsLabel.isHidden = false
            }
        }
    }

    @IBAction private func textFieldDidChange(_ sender: UITextField) {
        self.authenticateButton.isEnabled = !(self.userNameField.isEmpty || self.passwordField.isEmpty)
        self.invalidCredentialsLabel.isHidden = true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let maxLength = (textField === self.userNameField) ? self.maxUserNameLength : (textField === self.passwordField) ? self.maxPasswordLength : 0;
        let currentLength = textField.count
        let newLength = currentLength - range.length + string.count
        return newLength <= maxLength
    }
}
