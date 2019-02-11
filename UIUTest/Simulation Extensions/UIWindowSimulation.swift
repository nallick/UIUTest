//
//  UIWindowSimulation.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIWindow
{
	/// Returns the view a user touch at a point in the receiver will be sent to (if any).
    ///
	/// - Parameter location: The touch location in the receiver's local coordinates.
	/// - Returns: The hit view.
	///
	/// - Note:
	///		Windows with levels above the receiver will block touches within them.
	///
    func willHitView(at location: CGPoint) -> UIView? {
        guard let result = self.hitTest(location, with: nil) else { return nil }

        let windowList = UIApplication.shared.windows
        if windowList.count > 1 {
            let screen = self.screen
            let coordinateSpace = screen.coordinateSpace
            let globalLocation = self.convert(location, to: coordinateSpace)
            let windowLevel = self.windowLevel
            for window in UIApplication.shared.windows {
                if window !== self && window.screen === screen {
                    if window.windowLevel > windowLevel && window.hitTest(window.convert(globalLocation, from: coordinateSpace), with: nil) != nil {
                        return nil
                    }
                }
            }
        }

        return result
    }
}
