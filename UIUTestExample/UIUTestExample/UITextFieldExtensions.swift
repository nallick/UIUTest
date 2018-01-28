//
//  UITextFieldExtensions.swift
//
//  Copyright © 2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

extension UITextField
{
	var count: String.IndexDistance {
//		return self.text?.count ?? 0
		return self.text!.count		// text is never nil and the test above dings our code coverage
	}

	var isEmpty: Bool {
//		return self.text?.isEmpty ?? true
		return self.text!.isEmpty	// text is never nil and the test above dings our code coverage
	}
}
