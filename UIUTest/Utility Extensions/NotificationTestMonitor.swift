//
//  NotificationTestMonitor.swift
//
//  Copyright © 2018 Purgatory Design. Licensed under the MIT License.
//

import XCTest

class NotificationTestMonitor: NSObject {
    private var expectations: [NSNotification.Name: XCTestExpectation] = [:]

    func expectNotification(_ name: NSNotification.Name, on notificationCenter: NotificationCenter = .default, for object: Any? = nil, description: String = "") -> XCTestExpectation {
        if let existingExpectation = self.expectations[name] {
            existingExpectation.fulfill()
        }

        notificationCenter.addObserver(self, selector: #selector(notificationReceived), name: name, object: object)

        let expectation = XCTestExpectation(description: description)
        self.expectations[name] = expectation
        return expectation
    }

    @objc private func notificationReceived(notification: NSNotification) {
        let notificationName = notification.name
        if let expectation = self.expectations[notificationName] {
            self.expectations[notificationName] = nil
            expectation.fulfill()
        }
    }
}
