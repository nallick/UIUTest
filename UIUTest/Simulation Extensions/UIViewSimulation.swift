//
//  UIViewSimulation.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIView
{
    @objc public var willRespondToUser: Bool {
        let hitView = self.touchWillHitView
        return hitView === self
    }

    public var touchWillHitView: UIView? {
        guard let window = self.window else { return nil }
        let viewCenter = self.superview!.convert(self.center, to: window)
        return window.willHitView(at: viewCenter)
    }

    public func touchWillHitView(at location: CGPoint) -> UIView? {
        guard let window = self.window else { return nil }
        let windowLocation = self.convert(location, to: window)
        return window.willHitView(at: windowLocation)
    }

	public static func allowAnimation() {
		RunLoop.current.singlePass()     // allow any animations a chance to complete
	}
}
