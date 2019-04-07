//
//  UINavigationControllerTestable.swift
//
//  Copyright © 2019 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UINavigationController
{
	/// Returns the current back button of the navigation bar (if any).
	///
	var backButton: UIControl? {
		let backButtonView = self.navigationBar.subview(deep: true) {
			guard class_respondsToSelector(type(of: $0), Selector(("isBackButton"))) else { return false }
			let isBack = $0.value(forKey: "isBackButton") as? Bool
			return isBack == true
		}

		return backButtonView as? UIControl
	}
}
