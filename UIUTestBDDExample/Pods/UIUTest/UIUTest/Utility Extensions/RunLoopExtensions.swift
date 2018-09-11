//
//  RunLoopExtensions.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import Foundation

public extension RunLoop
{
    public func singlePass(forMode mode: RunLoopMode = .defaultRunLoopMode) {
        let _ = self.limitDate(forMode: mode)
    }
}
