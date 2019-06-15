//
//  RunLoopExtensions.swift
//
//  Copyright © 2017-2019 Purgatory Design. Licensed under the MIT License.
//

import Foundation

@nonobjc public extension RunLoop
{
    /// Make a single pass through the run loop.
    ///
    /// - Parameter mode: The run loop mode.
	///
	func singlePass(forMode mode: RunLoop.Mode = .default) {
        let _ = self.limitDate(forMode: mode)
    }
}
