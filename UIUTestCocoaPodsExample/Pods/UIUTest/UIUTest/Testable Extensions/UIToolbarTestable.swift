//
//  UIToolbarTestable.swift
//
//  Copyright © 2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIToolbar
{
	public var contentView: UIView? {
		return self.subviews.first(where: { String(describing: type(of: $0)) == "_UIToolbarContentView" })
	}

	public var buttonBarStackView: UIStackView? {
		guard let contentView = self.contentView else { return nil }
		return contentView.subview(ofType: UIStackView.self) as? UIStackView
	}

	public func loadItems() {
		RunLoop.current.singlePass()	// allow the toolbar items to load
	}

	public func viewForItem(at index: Int) -> UIView? {
		guard let buttonBarStackView = self.buttonBarStackView,
			index >= 0, index < buttonBarStackView.arrangedSubviews.count else { return nil }
		return buttonBarStackView.arrangedSubviews[index]
	}

	public func simulateTouchInItem(at index: Int) {
		guard let itemView = self.viewForItem(at: index) else { return }
		if itemView.willRespondToUser, let item = self.items?[index] {
			item.simulateTouch()
		}
	}
}
