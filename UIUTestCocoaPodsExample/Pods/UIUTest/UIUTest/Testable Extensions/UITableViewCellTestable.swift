//
//  UITableViewCellTestable.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UITableViewCell
{
    public var accessoryActionSegueIdentifier: String? {
        let template = self.value(forKey: "accessoryActionSegueTemplate") as AnyObject?
        return template?.value(forKey: "identifier") as? String
    }

    public var selectionSegueIdentifier: String? {
        let template = self.value(forKey: "selectionSegueTemplate") as AnyObject?
        return template?.value(forKey: "identifier") as? String
    }

    public var actualAccessoryView: UIView? {
        if let accessoryView = self.accessoryView { return accessoryView }
        if let defaultAccessoryView = self.value(forKey: "_defaultAccessoryView") as? UIView { return defaultAccessoryView }
        return nil
    }
}
