//
//  UITableViewSimulation.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UITableView
{
    public func willRespondToUser(at indexPath: IndexPath) -> IndexPath? {
        guard self.currentlyAllowsSelection else { return nil }

        guard let window = self.window else { return nil }
        let rowBounds = self.rectForRow(at: indexPath)
        guard !rowBounds.isEmpty else { return nil }
        let rowCenter = self.superview!.convert(rowBounds.midPoint, to: window)
        let hitView = window.hitTest(rowCenter, with: nil)
        guard hitView === self else { return nil }

        guard let delegate = self.delegate else { return nil }
        guard delegate.responds(to: #selector(UITableViewDelegate.tableView(_:willSelectRowAt:))) else { return indexPath }
        return delegate.tableView!(self, willSelectRowAt: indexPath)
    }

    public func willRespondToUserInAccessory(at indexPath: IndexPath) -> UITableViewCell? {
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

    public func simulateTouch(at indexPath: IndexPath) {
        if let indexPath = self.willRespondToUser(at: indexPath), let cell = self.cellForRow(at: indexPath) {
            self.selectRowAndNotify(at: indexPath, animated: false, scrollPosition: .none)
            if let segueIdentifer = cell.selectionSegueIdentifier, let viewController = self.viewController {
                viewController.performSegue(withIdentifier: segueIdentifer, sender: cell)
            }
        }
    }

    public func simulateAccessoryTouch(at indexPath: IndexPath) {
        if let cell = self.willRespondToUserInAccessory(at: indexPath) {
            if cell.accessoryView == nil, let delegate = self.delegate, delegate.responds(to: #selector(UITableViewDelegate.tableView(_:accessoryButtonTappedForRowWith:))) {
                delegate.tableView!(self, accessoryButtonTappedForRowWith: indexPath)
            }

            if let segueIdentifer = cell.accessoryActionSegueIdentifier, let viewController = self.viewController {
                viewController.performSegue(withIdentifier: segueIdentifer, sender: cell)
            }
        }
    }
}
