//
//  UISegmentedControlSimulation.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UISegmentedControl
{
    public func actualWidthForSegment(at segment: Int) -> CGFloat {
        let width = self.widthForSegment(at: segment)
        return (width != 0.0) ? width : self.frame.size.width/CGFloat(self.numberOfSegments)
    }

    public func boundsForSegment(at segment: Int) -> CGRect {
        var bounds = self.bounds
        bounds.size.width = self.actualWidthForSegment(at: segment)

        var i = segment - 1
        while i >= 0 {
            bounds.origin.x += self.actualWidthForSegment(at: i)
            i -= 1
        }

        return bounds
    }

    public func willRespondToUserInSegment(at segment: Int) -> Bool {
        guard self.isEnabledForSegment(at: segment) else { return false }
        let segmentLocation = self.boundsForSegment(at: segment).midPoint
        let hitView = self.touchWillHitView(at: segmentLocation)
        return hitView === self || self.contains(subview: hitView)
    }

    public func simulateTouchInSegment(at segment: Int, for event: UIControlEvents = .valueChanged) {
        if self.selectedSegmentIndex != segment && self.willRespondToUserInSegment(at: segment) {
            self.selectedSegmentIndex = segment
            self.sendActions(for: event)
        }
    }
}
