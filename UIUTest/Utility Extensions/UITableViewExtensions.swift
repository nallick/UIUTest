//
//  UITableViewExtension.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UITableView
{
    /// Specifies if the receiver currently allows selection.
	///
    var currentlyAllowsSelection: Bool {
        return self.isEditing ? self.allowsSelectionDuringEditing : self.allowsSelection
    }

	/// Specifies if the receiver currently allows multiiple selection.
	///
    var currentlyAllowsMultipleSelection: Bool {
        return self.isEditing ? self.allowsMultipleSelectionDuringEditing : self.allowsMultipleSelection
    }

    /// Determine if the specified cell is currently selected.
    ///
    /// - Parameter indexPath: The index path of the cell to test.
	/// - Returns: true if the specified cell is selected; false otherwise.
	///
    func cellIsSelected(at indexPath: IndexPath) -> Bool {
        return self.indexPathsForSelectedRows?.contains(indexPath) == true
    }

    /// Select a row and perform the notifications as if the selection was performed interactively rather than programatically.
    ///
    /// - Parameters:
    ///   - indexPath: The index path of the row to select.
    ///   - animated: Specifies if selection animations will be used.
    ///   - scrollPosition: The position to scroll to after selection.
	///
	/// - Note:
	///		This mirrors UITableView.selectRow(at indexPath: IndexPath?, animated: Bool, scrollPosition: UITableView.ScrollPosition)
	///
	func selectRowAndNotify(at indexPath: IndexPath?, animated: Bool, scrollPosition: UITableView.ScrollPosition) {
        if (indexPath == nil || !self.currentlyAllowsMultipleSelection), let indexPathsForSelectedRows = self.indexPathsForSelectedRows {
            var changed = false
            for selectedIndexPath in indexPathsForSelectedRows {
                if selectedIndexPath != indexPath {
                    self.deselectRow(at: selectedIndexPath, animated: animated)
                    if let delegate = self.delegate {
                        delegate.tableView?(self, didDeselectRowAt: selectedIndexPath)
                    }
                    changed = true
                }
            }
            if changed {
				NotificationCenter.default.post(Notification(name: UITableView.selectionDidChangeNotification, object: self))
            }
        }

        self.selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
        if let indexPath = indexPath {
            if let delegate = self.delegate {
                delegate.tableView?(self, didSelectRowAt: indexPath)
            }
            NotificationCenter.default.post(Notification(name: UITableView.selectionDidChangeNotification, object: self))
        }
    }

	/// Deselect a row and perform the notifications as if the deselection was performed interactively rather than programatically.
	///
	/// - Parameters:
	///   - indexPath: The index path of the row to deselect.
	///   - animated: Specifies if deselection animations will be used.
	///
	/// - Note:
	///		This mirrors UITableView.deselectRow(at indexPath: IndexPath, animated: Bool)
	///
    func deselectRowAndNotify(at indexPath: IndexPath, animated: Bool) {
        if self.cellIsSelected(at: indexPath) {
            self.deselectRow(at: indexPath, animated: animated)
            if let delegate = self.delegate {
                delegate.tableView?(self, didDeselectRowAt: indexPath)
            }
			NotificationCenter.default.post(Notification(name: UITableView.selectionDidChangeNotification, object: self))
        }
    }
}
