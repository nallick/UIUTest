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
        guard let topView = self.topSuperview else { return nil }
        let viewCenter = self.superview!.convert(self.center, to: topView)
		if let window = topView as? UIWindow { return window.willHitView(at: viewCenter) }
		return topView.hitTest(viewCenter, with: nil)
    }

    public func touchWillHitView(at location: CGPoint) -> UIView? {
        guard let topView = self.topSuperview else { return nil }
        let topLocation = self.convert(location, to: topView)
		if let window = topView as? UIWindow { return window.willHitView(at: topLocation) }
		return topView.hitTest(topLocation, with: nil)
    }

	public static func allowAnimation() {
		RunLoop.current.singlePass()     // allow any animations a chance to complete
	}
}
