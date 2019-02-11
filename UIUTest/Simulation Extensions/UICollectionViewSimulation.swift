//
//  UICollectionViewSimulation.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UICollectionView
{
    /// Allow any pending cells to load.
	///
    static func loadDataForTesting() {
        RunLoop.current.singlePass()
    }

    /// Determine if the receiver will respond to user touches in the center of the view.
	///
    override var willRespondToUser: Bool {
        let hitView = self.touchWillHitView
        return hitView === self || self.contains(subview: hitView)
    }

    /// Determine if the receiver will respond to user touches in the center of a specified item.
    ///
    /// - Parameter indexPath: The index path of the item to test.
	/// - Returns: true if the receiver will respond to user touches; false otherwise.
	///
    func willRespondToUser(at indexPath: IndexPath) -> Bool {
        guard self.allowsSelection else { return false }
        guard let cell = self.cellForItem(at: indexPath) else { return false }
        guard let layoutAttributes = self.layoutAttributesForItem(at: indexPath) else { return false }
        guard let hitView = self.touchWillHitView(at: layoutAttributes.center) else { return false }
        return hitView === cell.contentView || cell.contentView.contains(subview: hitView)
    }

	/// Returns the view that will respond to user touches in the center of a specified item (if any).
	///
	/// - Parameter indexPath: The index path of the item.
	/// - Returns: The view that will respond to user touches.
	///
    func willRespondToUserInContentView(at indexPath: IndexPath) -> UIView? {
        guard let cell = self.cellForItem(at: indexPath) else { return nil }
        guard let layoutAttributes = self.layoutAttributesForItem(at: indexPath) else { return nil }
        guard let hitView = self.touchWillHitView(at: layoutAttributes.center) else { return nil }
        return cell.contentView.contains(subview: hitView) ? hitView : nil
    }

    /// Toggle the highlight state of a spacific item on and off and send the appropriate delegate notifications.
    ///
	/// - Parameter indexPath: The index path of the item.
	///
    func toggleItemHighlightAndNotify(at indexPath: IndexPath) {
        let delegate = self.delegate
        if delegate?.collectionView?(self, shouldHighlightItemAt: indexPath) ?? true {
            let cell = self.cellForItem(at: indexPath)
            cell?.isHighlighted = true
            delegate?.collectionView?(self, didHighlightItemAt: indexPath)
            cell?.isHighlighted = false
            delegate?.collectionView?(self, didUnhighlightItemAt: indexPath)
        }
    }

	/// Determine if a specified item is selected.
	///
	/// - Parameter indexPath: The index path of the item to test.
	/// - Returns: true if the item is selected; false otherwise.
	///
    func itemIsSelected(at indexPath: IndexPath) -> Bool {
        return self.indexPathsForSelectedItems?.contains(indexPath) ?? false
    }

 	/// Select a spacific item and send the appropriate delegate notifications.
	///
	/// - Parameters:
	///   - indexPath: The index path of the item.
	///   - animated: Specifies if selection animations will be used.
	///   - scrollPosition: The position to scroll to after selection.
	///
	/// - Note:
	///		This mirrors UICollectionView.selectItem(at indexPath: IndexPath?, animated: Bool, scrollPosition: UICollectionView.ScrollPosition)
	///
	func selectItemAndNotify(at indexPath: IndexPath, animated: Bool, scrollPosition: UICollectionView.ScrollPosition) {
        let delegate = self.delegate
        if delegate?.collectionView?(self, shouldSelectItemAt: indexPath) ?? true {
			if !self.allowsMultipleSelection, let originalSelection = self.indexPathsForSelectedItems?.first {
				self.deselectItem(at: originalSelection, animated: animated)
				delegate?.collectionView?(self, didDeselectItemAt: originalSelection)
			}
            self.selectItem(at: indexPath, animated: animated, scrollPosition: scrollPosition)
            if self.itemIsSelected(at: indexPath) {
                delegate?.collectionView?(self, didSelectItemAt: indexPath)
            }
        }
    }

	/// Deselect a spacific item and send the appropriate delegate notifications.
	///
	/// - Parameters:
	///   - indexPath: The index path of the item.
	///   - animated: Specifies if deselection animations will be used.
	///
	/// - Note:
	///		This mirrors UICollectionView.deselectItem(at indexPath: IndexPath?, animated: Bool)
	///
    func deselectItemAndNotify(at indexPath: IndexPath, animated: Bool) {
        let delegate = self.delegate
        if delegate?.collectionView?(self, shouldDeselectItemAt: indexPath) ?? true {
            self.deselectItem(at: indexPath, animated: animated)
            if !self.itemIsSelected(at: indexPath) {
                delegate?.collectionView?(self, didDeselectItemAt: indexPath)
            }
        }
    }

	/// Simulate a user touch an item in the receiver.
	///
	/// - Parameters:
	///   - indexPath: The index path of the item.
	///   - animated: Specifies if selection animations will be used.
	/// - Returns: true if a touch was simulated; false if the item doesn't currently respond to user touches.
	///
    @discardableResult func simulateTouch(at indexPath: IndexPath, animated: Bool = true) -> Bool {
        if self.willRespondToUser(at: indexPath) {
            self.toggleItemHighlightAndNotify(at: indexPath)
            if self.allowsMultipleSelection && self.itemIsSelected(at: indexPath) {
                self.deselectItemAndNotify(at: indexPath, animated: animated)
            }
            else {
				self.selectItemAndNotify(at: indexPath, animated: animated, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
            }

            return true
        }

        return false
    }
}
