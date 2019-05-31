//
//  AppDelegate.swift
//
//  Copyright © 2017-2019 Purgatory Design. Licensed under the MIT License.
//

import UIKit

open class AppDelegate: UIResponder, UIApplicationDelegate
{
    public var window: UIWindow?

	open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AuthenticationViewController.defaultAuthenticator = DefaultAuthenticator()
        return true
    }
}
