//
//  UICollectionViewSimulation.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UICollectionView
{
    public static func loadDataForTesting() {
        RunLoop.current.singlePass()    // allow initialization
    }

    public override var willRespondToUser: Bool {
        let hitView = self.touchWillHitView
        return hitView === self || self.contains(subview: hitView)
    }

    public func willRespondToUser(at indexPath: IndexPath) -> Bool {
        guard self.allowsSelection else { return false }
        guard let cell = self.cellForItem(at: indexPath) else { return false }
        guard let layoutAttributes = self.layoutAttributesForItem(at: indexPath) else { return false }
        guard let hitView = self.touchWillHitView(at: layoutAttributes.center) else { return false }
        return hitView === cell.contentView || cell.contentView.contains(subview: hitView)
    }

    public func willRespondToUserInContentView(at indexPath: IndexPath) -> UIView? {
        guard let cell = self.cellForItem(at: indexPath) else { return nil }
        guard let layoutAttributes = self.layoutAttributesForItem(at: indexPath) else { return nil }
        guard let hitView = self.touchWillHitView(at: layoutAttributes.center) else { return nil }
        return cell.contentView.contains(subview: hitView) ? hitView : nil
    }

    public func toggleItemHighlightAndNotify(at indexPath: IndexPath) {
        let delegate = self.delegate
        if delegate?.collectionView?(self, shouldHighlightItemAt: indexPath) ?? true {
            let cell = self.cellForItem(at: indexPath)
            cell?.isHighlighted = true
            delegate?.collectionView?(self, didHighlightItemAt: indexPath)
            cell?.isHighlighted = false
            delegate?.collectionView?(self, didUnhighlightItemAt: indexPath)
        }
    }

    public func itemIsSelected(at indexPath: IndexPath) -> Bool {
        return self.indexPathsForSelectedItems?.contains(indexPath) ?? false
    }

    public func selectItemAndNotify(at indexPath: IndexPath, animated: Bool, scrollPosition: UICollectionViewScrollPosition) {
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

    public func deselectItemAndNotify(at indexPath: IndexPath, animated: Bool) {
        let delegate = self.delegate
        if delegate?.collectionView?(self, shouldDeselectItemAt: indexPath) ?? true {
            self.deselectItem(at: indexPath, animated: animated)
            if !self.itemIsSelected(at: indexPath) {
                delegate?.collectionView?(self, didDeselectItemAt: indexPath)
            }
        }
    }

    @discardableResult public func simulateTouch(at indexPath: IndexPath, animated: Bool = true) -> Bool {
        if self.willRespondToUser(at: indexPath) {
            self.toggleItemHighlightAndNotify(at: indexPath)
            if self.allowsMultipleSelection && self.itemIsSelected(at: indexPath) {
                self.deselectItemAndNotify(at: indexPath, animated: animated)
            }
            else {
                self.selectItemAndNotify(at: indexPath, animated: animated, scrollPosition: UICollectionViewScrollPosition(rawValue: 0))
            }

            return true
        }

        return false
    }
}
