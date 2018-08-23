//
//  UIViewExtensions.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIView
{
    public var viewController: UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            responder = responder!.next
            if let result = responder as? UIViewController {
                return result
            }
        }
        return nil
    }

    public func contains(subview: UIView?) -> Bool {
        var testView = subview?.superview
        while testView != nil {
            if testView! === self { return true }
            testView = testView!.superview
        }

        return false
    }

    public func subview(ofType type: UIView.Type) -> UIView? {
        return self.subviews.first(where: { $0.isKind(of: type) })
    }

    public func superview<T>(ofType type: T.Type) -> T? {
        return self.superview as? T ?? self.superview.flatMap { $0.superview(ofType: type) }
    }
}
