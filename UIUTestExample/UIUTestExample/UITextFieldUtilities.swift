//
//  UITextFieldUtilities.swift
//
//  Copyright © 2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

extension UITextField
{
	var count: Int {
		return self.text?.count ?? 0
	}

	var isEmpty: Bool {
		return self.text?.isEmpty ?? true
	}
}
