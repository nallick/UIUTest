//
//  UIAlertActionSimulation.swift
//
//  Copyright © 2017-2019 Purgatory Design. Licensed under the MIT License.
//

import UIKit

@nonobjc public extension UIAlertAction
{
	/// Simulate a user touch in the receiver.
	///
	/// - Note: This uses private system API so should only be used in test targets.
	///
    func simulateTouch() {
        if self.isEnabled {
            guard let handlerBlock = self.value(forKey: "handler") else { return }
            let handlerPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(handlerBlock as AnyObject).toOpaque())
            let handler = unsafeBitCast(handlerPtr, to: (@convention(block) (UIAlertAction) -> Void).self)
            handler(self)

            guard let alertController = self.value(forKey: "_alertController") as? UIAlertController else { return }

            if !alertController.isBeingDismissed,
               !alertController.hasBeenDismissed {
                alertController.dismiss(animated: true)
            }
        }
    }
}
