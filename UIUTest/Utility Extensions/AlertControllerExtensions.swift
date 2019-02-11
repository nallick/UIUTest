//
//  AlertControllerExtensions.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIAlertController
{
    /// Returns an action of the receiver with the specified title.
    ///
    /// - Parameter title: The title to match.
    /// - Returns: The matching alert action (if any).
	///
    func action(withTitle title: String) -> UIAlertAction? {
		return self.actions.first(where: {$0.title == title})
    }

	/// Returns an action of the receiver with the specified style.
	///
	/// - Parameter style: The style to match.
	/// - Returns: The matching alert action (if any).
	///
	func action(withStyle style: UIAlertAction.Style) -> UIAlertAction? {
        return self.actions.first(where: {$0.style == style})
    }
}
