//
//  AppDelegate.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AuthenticationViewController.defaultAuthenticator = DefaultAuthenticator()
        return true
    }
}
