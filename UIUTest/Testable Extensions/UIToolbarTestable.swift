//
//  UIToolbarTestable.swift
//
//  Copyright © 2018-2019 Purgatory Design. Licensed under the MIT License.
//

import UIKit

@nonobjc public extension UIToolbar
{
	/// Returns the receiver's content view (if any).
	///
	/// - Note: This uses private system API so should only be used in test targets.
	///
	var contentView: UIView? {
		return self.subviews.first(where: { String(describing: type(of: $0)) == "_UIToolbarContentView" })
	}

	/// Returns the receiver's bar button stack view (if any).
	///
	/// - Note: This uses private system API so should only be used in test targets.
	///
	var buttonBarStackView: UIStackView? {
		guard let contentView = self.contentView else { return nil }
		return contentView.subview(ofType: UIStackView.self)
	}

	/// Allow the receiver's items to load.
	///
	func loadItems() {
		RunLoop.current.singlePass()
	}

	/// Returns the view for the receiver's indexed toolbar item.
	///
	/// - Parameter index: The toolbar item index.
	/// - Returns: The toolbar item view (if any).
	///
	/// - Note: This uses private system API so should only be used in test targets.
	///
	func viewForItem(at index: Int) -> UIView? {
		guard let buttonBarStackView = self.buttonBarStackView,
			index >= 0, index < buttonBarStackView.arrangedSubviews.count else { return nil }
		return buttonBarStackView.arrangedSubviews[index]
	}

	/// Simulate a user touch in an indexed toolbar item of the receiver.
	///
	/// - Parameter index: The toolbar item index.
	///
	func simulateTouchInItem(at index: Int) {
		guard let itemView = self.viewForItem(at: index) else { return }
		if itemView.willRespondToUser, let item = self.items?[index] {
			item.simulateTouch()
		}
	}
}
