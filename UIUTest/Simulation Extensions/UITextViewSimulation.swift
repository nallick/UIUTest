//
//  UITextViewSimulation.swift
//
//  Copyright © 2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UITextView
{
	/// Simulate a user touch in the receiver.
	///
    func simulateTouch() {
        if self.willRespondToUser && self.isEditable && self.delegate?.textViewShouldBeginEditing?(self) != false {
            self.becomeFirstResponder()
			self.selectedRange = NSRange(location: self.text.count, length: 0)
        }
    }

	/// Simulate user typing into the receiver.
	///
	/// - Parameter string: The text to enter into the view (or nil to clear the view's text).
	///
    func simulateTyping(_ string: String?) {
        if self.isFirstResponder {
            let existingText = self.text ?? ""
            if let string = string, string != "" {
                if self.delegate?.textView?(self, shouldChangeTextIn: self.selectedRange, replacementText: string) != false {
                    self.insertText(string)
                }
            }
            else {
                if existingText != "" && self.delegate?.textView?(self, shouldChangeTextIn: NSRange(location: 0, length: existingText.count), replacementText: "") != false {
					self.setTextAndNotify(nil, selection: NSRange(location: 0, length: 0))
                }
            }
        }
    }

	/// Set the view text, send the appropriate delegate notifications and optionally update the selection.
	///
	/// - Parameters:
	///   - string: The text to set (or nil to clear the field's text).
	///   - selection: The new selection (or nil).
	///
	func setTextAndNotify(_ string: String?, selection: NSRange? = nil) {
		if string != self.text {
			self.text = string
			self.delegate?.textViewDidChange?(self)
		}
		if let selection = selection {
			self.selectedRange = selection
		}
	}

	/// Insert text the view at the current selection, send the appropriate delegate notifications and update the selection.
	///
	/// - Parameter string: The text to insert.
	///
	func insertTextAndNotify(_ string: String) {
		if !string.isEmpty {
			let newText = NSMutableString(string: self.text ?? "")
			newText.replaceCharacters(in: self.selectedRange, with: string)
			self.setTextAndNotify(newText as String, selection: NSRange(location: self.selectedRange.location + newText.length, length: 0))
		}
	}
}
