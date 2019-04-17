//
//  AppDelegateTest.swift
//
//  Copyright © 2019 Purgatory Design. Licensed under the MIT License.
//

import UIKit
import UIUTestExample

class AppDelegateTest: AppDelegate
{
	override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
		self.window?.layer.speed = 100.0
		return result
	}
}
