//
//  DefaultAuthenticator.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

struct DefaultAuthenticator: Authenticator
{
	static let validUser = "admin"
	static let validPassword = "admin"

	func authenticate(user: String, password: String) -> Bool {
		return (user == DefaultAuthenticator.validUser && password == DefaultAuthenticator.validPassword)
	}
}
