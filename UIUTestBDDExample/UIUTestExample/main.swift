//
//  main.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import Foundation
import UIKit

class Application: UIApplication
{
//    override func sendEvent(_ event: UIEvent) {
//        super.sendEvent(event)
//        print("Event sent: \(event)");
//    }
}

UIApplicationMain(
    CommandLine.argc,
    UnsafeMutableRawPointer(CommandLine.unsafeArgv)
        .bindMemory(
            to: UnsafeMutablePointer<Int8>.self,
            capacity: Int(CommandLine.argc)),
    NSStringFromClass(Application.self),
    NSStringFromClass(AppDelegate.self)
)
