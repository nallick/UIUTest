//
//  UIBarButtonItemTestable.swift
//
//  Copyright © 2018-2019 Purgatory Design. Licensed under the MIT License.
//

import UIKit

@nonobjc public extension UIBarButtonItem
{
	/// Returns the system item style of the receiver (if any).
	///
	/// - Note: This uses private system API so should only be used in test targets.
	///
	var systemItemStyle: UIBarButtonItem.SystemItem? {
		guard (self.value(forKey: "isSystemItem") as? Bool) == true else { return nil }
		guard let result = self.value(forKey: "systemItem") as? Int else { return nil }
		return UIBarButtonItem.SystemItem(rawValue: result)
	}
}
