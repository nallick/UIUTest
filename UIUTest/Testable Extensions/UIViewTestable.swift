//
//  UIViewTestable.swift
//
//  Copyright © 2019 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIView
{
    /// A description of this view and all of its subviews.
    ///
    var recursiveDescription: String {
        return self.value(forKey: "recursiveDescription") as? String ?? ""
    }
}
