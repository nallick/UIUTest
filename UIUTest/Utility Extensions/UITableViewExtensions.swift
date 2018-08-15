//
//  UITableViewExtension.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UITableView
{
    public var currentlyAllowsSelection: Bool {
        return self.isEditing ? self.allowsSelectionDuringEditing : self.allowsSelection
    }

    public var currentlyAllowsMultipleSelection: Bool {
        return self.isEditing ? self.allowsMultipleSelectionDuringEditing : self.allowsMultipleSelection
    }

    public func cellIsSelected(at indexPath: IndexPath) -> Bool {
        return self.indexPathsForSelectedRows?.contains(indexPath) ?? false
    }

    public func selectRowAndNotify(at indexPath: IndexPath?, animated: Bool, scrollPosition: UITableViewScrollPosition) {
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
                NotificationCenter.default.post(Notification(name: NSNotification.Name.UITableViewSelectionDidChange, object: self))
            }
        }

        self.selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
        if let indexPath = indexPath {
            if let delegate = self.delegate {
                delegate.tableView?(self, didSelectRowAt: indexPath)
            }
            NotificationCenter.default.post(Notification(name: NSNotification.Name.UITableViewSelectionDidChange, object: self))
        }
    }

    public func deselectRowAndNotify(at indexPath: IndexPath, animated: Bool) {
        if self.cellIsSelected(at: indexPath) {
            self.deselectRow(at: indexPath, animated: animated)
            if let delegate = self.delegate {
                delegate.tableView?(self, didDeselectRowAt: indexPath)
            }
            NotificationCenter.default.post(Notification(name: NSNotification.Name.UITableViewSelectionDidChange, object: self))
        }
    }
}
