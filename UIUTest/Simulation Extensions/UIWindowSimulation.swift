//
//  UIWindowSimulation.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIWindow
{
    public func willHitView(at location: CGPoint) -> UIView? {
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
