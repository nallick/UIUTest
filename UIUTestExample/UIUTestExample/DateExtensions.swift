//
//  DateExtensions.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import Foundation

public extension Date
{
    public static var yesterday: Date {
        return Date(timeIntervalSinceNow: -60.0*60.0*24.0)
    }

    public static var today: Date {
        return Date()
    }

    public static var tomorrow: Date {
        return Date(timeIntervalSinceNow: 60.0*60.0*24.0)
    }

    public var dayOfWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
