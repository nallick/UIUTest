//
//  GeometryExtensions.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import CoreGraphics

public extension CGRect
{
    public var midPoint: CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }
}
