//
//  UITableViewCellTestable.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UITableViewCell
{
    /// Returns the identifier of the receiver's accessory action segue.
	///
	/// - Note: This uses private system API so should only be used in test targets.
	///
    public var accessoryActionSegueIdentifier: String? {
        let template = self.value(forKey: "accessoryActionSegueTemplate") as AnyObject?
        return template?.value(forKey: "identifier") as? String
    }

	/// Returns the identifier of the receiver's selection segue.
	///
	/// - Note: This uses private system API so should only be used in test targets.
	///
    public var selectionSegueIdentifier: String? {
        let template = self.value(forKey: "selectionSegueTemplate") as AnyObject?
        return template?.value(forKey: "identifier") as? String
    }

	/// Returns the receiver's accessory view or the default accessory view if none is defined.
	///
	/// - Note: This uses private system API so should only be used in test targets.
	///
    public var actualAccessoryView: UIView? {
        if let accessoryView = self.accessoryView { return accessoryView }
        if let defaultAccessoryView = self.value(forKey: "_defaultAccessoryView") as? UIView { return defaultAccessoryView }
        return nil
    }
}
