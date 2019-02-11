//
//  UIViewSimulation.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIView
{
	/// Determine if the receiver will respond to user touches in the center of the view.
	///
    @objc var willRespondToUser: Bool {
        let hitView = self.touchWillHitView
        return hitView === self
    }

    /// Returns the view a user touch in the center of the receiver will be sent to (if any).
	///
    var touchWillHitView: UIView? {
        guard let topView = self.topSuperview else { return nil }
        let viewCenter = self.superview!.convert(self.center, to: topView)
		if let window = topView as? UIWindow { return window.willHitView(at: viewCenter) }
		return topView.hitTest(viewCenter, with: nil)
    }

	/// Returns the view a user touch at a point in the receiver will be sent to (if any).
    ///
    /// - Parameter location: The touch location in the receiver's local coordinates.
    /// - Returns: The hit view.
	///
    func touchWillHitView(at location: CGPoint) -> UIView? {
        guard let topView = self.topSuperview else { return nil }
        let topLocation = self.convert(location, to: topView)
		if let window = topView as? UIWindow { return window.willHitView(at: topLocation) }
		return topView.hitTest(topLocation, with: nil)
    }


	/// Allow any pending animations a chance to complete.
	///
	static func allowAnimation() {
		RunLoop.current.singlePass()
	}
}
