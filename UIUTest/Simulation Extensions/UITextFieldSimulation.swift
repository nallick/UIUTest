//
//  UITextFieldSimulation.swift
//
//  Copyright © 2017-2019 Purgatory Design. Licensed under the MIT License.
//

import UIKit

@nonobjc public extension UITextField
{
	/// Returns true if the receiver's clear button is currently visible; false otherwise.
	///
    var clearButtonIsVisible: Bool {
        switch self.clearButtonMode {
            case .never:
                return false
            case .whileEditing:
                return self.isFirstResponder
            case .unlessEditing:
                return !self.isFirstResponder
            case .always:
                return true
        }
    }

	/// Simulate a user touch in the receiver.
	///
	/// - Parameter event: The event to simulate if the field responds to user touches.
	///
    override func simulateTouch(for event: UIControl.Event = .touchUpInside) {
        if self.willRespondToUser {
            self.sendActions(for: event)

            if event == .touchUpInside {
                self.becomeFirstResponder()
				RunLoop.current.singlePass()	// allow left and/or right button to appear
            }
        }
    }

    /// Simulate user typing into the receiver.
    ///
    /// - Parameter string: The text to enter into the field (or nil to clear the field's text).
	///
    func simulateTyping(_ string: String?) {
        if self.isFirstResponder {
            let existingText = self.text ?? ""
            if let string = string, string != "" {
                if self.delegate?.textField?(self, shouldChangeCharactersIn: NSRange(location: existingText.count, length: 0), replacementString: string) != false {
                    self.setTextAndNotify(existingText + string)
                }
            }
            else {
                if existingText != "" && self.delegate?.textField?(self, shouldChangeCharactersIn: NSRange(location: 0, length: existingText.count), replacementString: "") != false {
                    self.setTextAndNotify(nil)
                }
            }
        }
    }

    /// Simulate a user tap on the receiver's clear button.
	///
    func simulateClearButton() {
        if self.clearButtonIsVisible && self.delegate?.textFieldShouldClear?(self) != false {
            self.text = nil
        }
    }

	/// Simulate a user tap on the keyboard's return key.
	///
    func simulateReturnKey() {
        if self.delegate?.textFieldShouldReturn?(self) != false {
            self.sendActions(for: .primaryActionTriggered)
        }
    }

	/// Simulate a user tap on the keyboard's return key asynchronously.
	///
    func simulateReturnKeyAsync() {
        DispatchQueue.main.async {
            self.simulateReturnKey()
        }
    }

	/// Set the field text and send the appropriate notifications.
    ///
	/// - Parameter string: The text to set (or nil to clear the field's text).
	///
    func setTextAndNotify(_ string: String?) {
		if string != self.text {
			self.text = string
			self.sendActions(for: .editingChanged)
			NotificationCenter.default.post(Notification(name: UITextField.textDidChangeNotification, object: self))
		}
    }
}
