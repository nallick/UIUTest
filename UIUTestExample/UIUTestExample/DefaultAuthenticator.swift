//
//  DefaultAuthenticator.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public struct DefaultAuthenticator: Authenticator
{
	public static let validUser = "admin"
	public static let validPassword = "admin"

	public init() {
	}

	public func authenticate(user: String, password: String) -> Bool {
		return (user == DefaultAuthenticator.validUser && password == DefaultAuthenticator.validPassword)
	}
}
