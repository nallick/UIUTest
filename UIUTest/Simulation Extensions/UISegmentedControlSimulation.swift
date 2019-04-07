//
//  UISegmentedControlSimulation.swift
//
//  Copyright © 2017-2019 Purgatory Design. Licensed under the MIT License.
//

import UIKit

@nonobjc public extension UISegmentedControl
{
    /// Returns the width of a specified segment of the receiver, calculating the value if necessary.
    ///
    /// - Parameter segment: The segment index.
    /// - Returns: The segment width.
	///
    func actualWidthForSegment(at segment: Int) -> CGFloat {
        let width = self.widthForSegment(at: segment)
        return (width != 0.0) ? width : self.frame.size.width/CGFloat(self.numberOfSegments)
    }

	/// Returns the bounds of a specified segment of the receiver.
    ///
    /// - Parameter segment: The segment index.
    /// - Returns: The segment bounds.
	///
    func boundsForSegment(at segment: Int) -> CGRect {
        var bounds = self.bounds
        bounds.size.width = self.actualWidthForSegment(at: segment)

        var i = segment - 1
        while i >= 0 {
            bounds.origin.x += self.actualWidthForSegment(at: i)
            i -= 1
        }

        return bounds
    }

	/// Determine if the receiver will respond to user touches in the center of a specified segment.
	///
	/// - Parameter segment: The segment index.
	/// - Returns: true if the receiver will respond to user touches in the segment; false othewise.
	///
    func willRespondToUserInSegment(at segment: Int) -> Bool {
        guard self.isEnabledForSegment(at: segment) else { return false }
        let segmentLocation = self.boundsForSegment(at: segment).midPoint
        let hitView = self.touchWillHitView(at: segmentLocation)
        return hitView === self || self.contains(subview: hitView)
    }

	/// Simulate a user touch in a specified segment of the receiver.
	///
    /// - Parameters:
    ///   - segment: The segment index.
    ///   - event: The event to simulate if the control responds to user touches.
	///
	func simulateTouchInSegment(at segment: Int, for event: UIControl.Event = .valueChanged) {
        if self.selectedSegmentIndex != segment && self.willRespondToUserInSegment(at: segment) {
            self.selectedSegmentIndex = segment
            self.sendActions(for: event)
        }
    }
}
