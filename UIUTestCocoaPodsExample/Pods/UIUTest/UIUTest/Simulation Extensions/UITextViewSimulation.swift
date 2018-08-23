//
//  UITextViewSimulation.swift
//
//  Copyright © 2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UITextView
{
    public func simulateTouch() {
        if self.willRespondToUser && self.isEditable && self.delegate?.textViewShouldBeginEditing?(self) ?? true {
            self.becomeFirstResponder()
			self.selectedRange = NSRange(location: self.text.count, length: 0)
        }
    }

    public func simulateTyping(_ string: String?) {
        if self.isFirstResponder {
            let existingText = self.text ?? ""
            if let string = string, string != "" {
                if self.delegate?.textView?(self, shouldChangeTextIn: self.selectedRange, replacementText: string) ?? true {
                    self.insertTextAndNotify(string)
                }
            }
            else {
                if existingText != "" && self.delegate?.textView?(self, shouldChangeTextIn: NSRange(location: 0, length: existingText.count), replacementText: "") ?? true {
					self.setTextAndNotify(nil, selection: NSRange(location: 0, length: 0))
                }
            }
        }
    }

	public func setTextAndNotify(_ string: String?, selection: NSRange? = nil) {
		if string != self.text {
			self.text = string
			self.delegate?.textViewDidChange?(self)
		}
		if let selection = selection {
			self.selectedRange = selection
		}
	}

	public func insertTextAndNotify(_ string: String) {
		if !string.isEmpty {
			let newText = NSMutableString(string: self.text ?? "")
			newText.replaceCharacters(in: self.selectedRange, with: string)
			self.setTextAndNotify(newText as String, selection: NSRange(location: self.selectedRange.location + newText.length, length: 0))
		}
	}
}
