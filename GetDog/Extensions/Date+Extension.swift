//
//  Date+Extension.swift
//  GetDog
//
//  Created by Roman Rakhlin on 11/11/23.
//

import Foundation

// MARK: - Get Start Of Week Date

extension Date {    
    var startOfWeek: Date? {
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar.date(
            from: calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: Date())
        )
    }
    
    var endOfWeek: Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear, .weekday], from: self)

        guard let currentWeekStartDate = calendar.date(from: components) else {
            return nil
        }

        let daysToSunday = 8 - (components.weekday ?? 1)

        if let endOfWeek = calendar.date(byAdding: .day, value: daysToSunday, to: currentWeekStartDate) {
            return endOfWeek
        } else {
            return nil
        }
    }
}

// MARK: - Raw Representable

extension Date: RawRepresentable {
    public var rawValue: String {
        self.timeIntervalSinceReferenceDate.description
    }
    
    public init?(rawValue: String) {
        self = Date(timeIntervalSinceReferenceDate: Double(rawValue) ?? 0.0)
    }
}
