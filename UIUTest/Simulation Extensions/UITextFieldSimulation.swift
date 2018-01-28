//
//  UITextFieldSimulation.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UITextField
{
    public var clearButtonIsVisible: Bool {
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

    public override func simulateTouch(for event: UIControlEvents = .touchUpInside) {
        if self.willRespondToUser {
            self.sendActions(for: event)

            if event == .touchUpInside {
                self.becomeFirstResponder()
            }
        }
    }

    public func simulateTyping(_ string: String?) {
        if self.isFirstResponder {
            let existingText = self.text ?? ""
            if let string = string, string != "" {
                if self.delegate?.textField?(self, shouldChangeCharactersIn: NSRange(location: existingText.count, length: 0), replacementString: string) ?? true {
                    self.setTextAndNotify(existingText + string)
                }
            }
            else {
                if existingText != "" && self.delegate?.textField?(self, shouldChangeCharactersIn: NSRange(location: 0, length: existingText.count), replacementString: "") ?? true {
                    self.setTextAndNotify(nil)
                }
            }
        }
    }

    public func simulateClearButton() {
        if self.clearButtonIsVisible && self.delegate?.textFieldShouldClear?(self) ?? true {
            self.text = nil
        }
    }

    public func simulateReturnKey() {
        if self.delegate?.textFieldShouldReturn?(self) ?? true {
            self.sendActions(for: .primaryActionTriggered)
        }
    }

    public func setTextAndNotify(_ string: String?) {
        self.text = string
        self.sendActions(for: .editingChanged)
        NotificationCenter.default.post(Notification(name: NSNotification.Name.UITextFieldTextDidChange, object: self))
    }
}

