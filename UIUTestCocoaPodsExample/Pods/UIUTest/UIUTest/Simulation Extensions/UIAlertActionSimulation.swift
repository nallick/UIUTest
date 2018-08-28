//
//  UIAlertActionSimulation.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIAlertAction
{
    public func simulateTouch() {
        if self.isEnabled {
            guard let handlerBlock = self.value(forKey: "handler") else { return }
            let handlerPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(handlerBlock as AnyObject).toOpaque())
            let handler = unsafeBitCast(handlerPtr, to: (@convention(block) (UIAlertAction) -> Void).self)
            handler(self)
        }
    }
}
