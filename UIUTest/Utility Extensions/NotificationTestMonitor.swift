//
//  NotificationTestMonitor.swift
//
//  Copyright © 2018 Purgatory Design. Licensed under the MIT License.
//

import XCTest

public class NotificationTestMonitor: NSObject
{
    /// The expectation for each notification name.
	///
    private var expectations: [NSNotification.Name: XCTestExpectation] = [:]

    /// All notifications received.
	///
    public private(set) var notificationsReceived: [NSNotification] = []

    /// Create an XCTest expectation which will be fulfilled by a notification.
    ///
    /// - Parameters:
    ///   - name: The name of the notification to expect.
    ///   - notificationCenter: The notification center to monitor.
    ///   - object: The object to expect on the notification (if any).
    ///   - description: The description of the expectation.
    /// - Returns: An expectation for the specified notification.
	///
    public func expectNotification(_ name: NSNotification.Name, on notificationCenter: NotificationCenter = .default, for object: Any? = nil, description: String = "") -> XCTestExpectation {
        if let existingExpectation = self.expectations[name] {
            existingExpectation.fulfill()
        }

        notificationCenter.addObserver(self, selector: #selector(notificationReceived), name: name, object: object)

        let expectation = XCTestExpectation(description: description)
        self.expectations[name] = expectation
        return expectation
    }

    /// Wait for any as of yet unfulfilled expectations.
    ///
    /// - Parameters:
    ///   - testCase: The test case to wait
    ///   - expectations: The to wait for (if not already fulfilled).
    ///   - timeout: The wait timeout (in seconds).
	///
    public func waitIfNeeded(in testCase: XCTestCase, for expectations: [XCTestExpectation], timeout: TimeInterval) {
        if self.notificationsReceived.count > 0 {
            let expectedNotifications = expectations.compactMap { expectation in return self.expectations.first(where: { $1 === expectation })?.key }
            let notificationsNotReceived = expectedNotifications.filter { notificationName in !self.notificationsReceived.contains(where: { notification in return notification.name == notificationName }) }
            if notificationsNotReceived.count > 0 {
                let unfulfilledExpectations = notificationsNotReceived.compactMap { self.expectations[$0] }
                testCase.wait(for: unfulfilledExpectations, timeout: timeout)
            }
        } else {
            testCase.wait(for: expectations, timeout: timeout)
        }
    }

    /// A notification has been received.
    ///
    /// - Parameter notification: The received notification.
	///
    @objc private func notificationReceived(notification: NSNotification) {
        let notificationName = notification.name
        self.notificationsReceived.append(notification)
        if let expectation = self.expectations[notificationName] {
            self.expectations[notificationName] = nil
            expectation.fulfill()
        }
    }
}
