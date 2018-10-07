//
//  UIBarButtonItemTestable.swift
//
//  Copyright © 2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIBarButtonItem
{
	/// Returns the system item style of the receiver (if any).
	///
	/// - Note: This uses private system API so should only be used in test targets.
	///
	public var systemItemStyle: UIBarButtonSystemItem? {
		guard (self.value(forKey: "isSystemItem") as? Bool) == true else { return nil }
		guard let result = self.value(forKey: "systemItem") as? Int else { return nil }
		return UIBarButtonSystemItem(rawValue: result)
	}
}
