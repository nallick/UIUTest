//
//  main.swift
//
//  Copyright © 2017-2019 Purgatory Design. Licensed under the MIT License.
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

_ = UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    NSStringFromClass(Application.self),
    NSStringFromClass(AppDelegate.self)
)
