//
//  UITableViewSimulation.swift
//
//  Copyright © 2017-2019 Purgatory Design. Licensed under the MIT License.
//

import UIKit

@nonobjc public extension UITableView
{
	/// Allow any pending cells to load.
	///
    static func loadDataForTesting() {
        RunLoop.current.singlePass()
    }

	/// Determine if the receiver will respond to user touches in the center of the view.
	///
    @objc override var willRespondToUser: Bool {
        let hitView = self.touchWillHitView
        return hitView === self || self.contains(subview: hitView)
    }

	/// Determine if the receiver will respond to user touches in the center of a specified cell.
	///
	/// - Parameter indexPath: The index path of the cell to test.
	/// - Returns: The index path of the cell that will respond to user touches (if any).
	///
    func willRespondToUser(at indexPath: IndexPath) -> IndexPath? {
        guard self.currentlyAllowsSelection else { return nil }

        guard let topView = self.topSuperview else { return nil }
        let rowBounds = self.rectForRow(at: indexPath)
        guard !rowBounds.isEmpty else { return nil }
        let rowCenter = self.convert(rowBounds.midPoint, to: topView)
        let hitView = topView.hitTest(rowCenter, with: nil)
        guard hitView === self || self.contains(subview: hitView) else { return nil }

        guard let delegate = self.delegate else { return nil }
        guard delegate.responds(to: #selector(UITableViewDelegate.tableView(_:willSelectRowAt:))) else { return indexPath }
        return delegate.tableView!(self, willSelectRowAt: indexPath)
    }

	/// Determine if the receiver will respond to user touches in the center of the accessory view of a specified cell.
	///
	/// - Parameter indexPath: The index path of the cell to test.
	/// - Returns: The cell that will respond to user touches (if any).
	///
	/// - Note: This uses private system API so should only be used in test targets.
	///
    func willRespondToUserInAccessory(at indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = self.cellForRow(at: indexPath) else { return nil }
        guard var accessoryView = cell.actualAccessoryView else { return nil }
        switch cell.accessoryType {
            case .detailButton:
                break
            case .detailDisclosureButton:
                guard let button = accessoryView.subview(ofType: UIButton.self) else { return nil }
                accessoryView = button
            default:
                return nil
        }

        return accessoryView.willRespondToUser ? cell : nil
    }

	/// Simulate a user touch a cell in the receiver.
	///
	/// - Parameter indexPath: The index path of the cell.
	///
	/// - Note: This uses private system API so should only be used in test targets.
	///
	func simulateTouch(at indexPath: IndexPath) {
        if let indexPath = self.willRespondToUser(at: indexPath), let cell = self.cellForRow(at: indexPath) {
            let willSelectRow = !self.currentlyAllowsMultipleSelection || !self.cellIsSelected(at: indexPath)
            if willSelectRow {
                self.selectRowAndNotify(at: indexPath, animated: false, scrollPosition: .none)
                if let segueIdentifer = cell.selectionSegueIdentifier, let viewController = self.viewController {
                    viewController.performSegue(withIdentifier: segueIdentifer, sender: cell)
                }
            }
            else {
                self.deselectRowAndNotify(at: indexPath, animated: false)
            }
        }
    }

	/// Simulate a user touch the center of the accessory view of a cell in the receiver.
	///
	/// - Parameter indexPath: The index path of the cell.
	///
	/// - Note: This uses private system API so should only be used in test targets.
	///
    func simulateAccessoryTouch(at indexPath: IndexPath) {
        if let cell = self.willRespondToUserInAccessory(at: indexPath) {
            if cell.accessoryView == nil, let delegate = self.delegate, delegate.responds(to: #selector(UITableViewDelegate.tableView(_:accessoryButtonTappedForRowWith:))) {
                delegate.tableView!(self, accessoryButtonTappedForRowWith: indexPath)
            }

            if let segueIdentifer = cell.accessoryActionSegueIdentifier, let viewController = self.viewController {
                viewController.performSegue(withIdentifier: segueIdentifer, sender: cell)
            }
        }
    }

	/// Simulate a user invoking an edit operation on a cell in the receiver.
	///
	/// - Parameters:
	///   - style: The edit operation style.
	///   - indexPath: The index path of the cell.
	///
	func simulateEdit(_ style: UITableViewCell.EditingStyle, rowAt indexPath: IndexPath) {
        guard let cell = self.cellForRow(at: indexPath),
              style == self.delegate?.tableView?(self, editingStyleForRowAt: indexPath) ?? .delete,
              style == .delete || (self.isEditing && cell.isEditing),
              let dataSource = self.dataSource, dataSource.tableView?(self, canEditRowAt: indexPath) != false
            else { return }
		dataSource.tableView?(self, commit: style, forRowAt: indexPath)
	}

	/// Simulate a user dragging a cell in the receiver to invoke an edit move operation.
	///
	/// - Parameters:
	///   - sourceIndexPath: The index path of the cell to move.
	///   - destinationIndexPath: The index path of the cell after the move.
	///
	func simulateEdit(moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard self.isEditing, let cell = self.cellForRow(at: sourceIndexPath), cell.isEditing,
              let dataSource = self.dataSource, dataSource.responds(to: #selector(UITableViewDataSource.tableView(_:moveRowAt:to:))),
              dataSource.tableView?(self, canEditRowAt: sourceIndexPath) != false, dataSource.tableView?(self, canMoveRowAt: sourceIndexPath) != false
            else { return }
		dataSource.tableView?(self, moveRowAt: sourceIndexPath, to: destinationIndexPath)
		self.moveRow(at: sourceIndexPath, to: destinationIndexPath)
	}
}
