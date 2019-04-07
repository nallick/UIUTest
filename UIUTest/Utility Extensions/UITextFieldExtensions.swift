//
//  UITextFieldExtensions.swift
//
//  Copyright © 2019 Purgatory Design. Licensed under the MIT License.
//

import UIKit

@nonobjc public extension UITextField
{
	/// Insert text after setting the selection of the text to replace.
	///
	/// - Parameters:
	///   - string: The text to enter into the field.
	///   - location: The location of the existing text to replace (or a negative value to append text).
	///   - length: The length of the existing text to replace.
	///
	func insertOrReplaceText(_ string: String, at location: Int = -1, length: Int = 0) {
		let startPosition = (location >= 0) ? self.position(from: self.beginningOfDocument, offset: location)! : self.endOfDocument
		let endPosition = self.position(from: startPosition, offset: length)!
		self.selectedTextRange = self.textRange(from: startPosition, to: endPosition)
		self.insertText(string)
	}

	/// Insert text after setting the selection of the text to replace.
	///
	/// - Parameters:
	///   - string: The text to enter into the field.
	///   - range: The range of the text to replace, or the insertion point.
	///
	func insertOrReplaceText(_ string: String, in range: Range<Int>) {
		self.insertOrReplaceText(string, at: range.lowerBound, length: range.count)
	}
}
