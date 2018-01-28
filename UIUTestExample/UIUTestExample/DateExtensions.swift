//
//  DateExtensions.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import Foundation

extension Date
{
    static var yesterday: Date {
        return Date(timeIntervalSinceNow: -60.0*60.0*24.0)
    }

    static var today: Date {
        return Date()
    }

    static var tomorrow: Date {
        return Date(timeIntervalSinceNow: 60.0*60.0*24.0)
    }

    var dayOfWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
