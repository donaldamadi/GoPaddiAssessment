//
//  DateFormatters.swift
//  GoPaddi
//
//  Provides reusable DateFormatter instances and helper methods for date manipulation.
//

import Foundation

enum AppDateFormatter {

    // MARK: - Shared formatters (cached for performance)

    /// "21 March 2024"
    static let fullDate: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d MMMM yyyy"
        return f
    }()

    /// "19th April 2024"
    static let ordinalDate: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d MMMM yyyy"
        return f
    }()

    /// "Sat, Feb 2"
    static let shortDate: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "EEE, MMM d"
        return f
    }()

    /// "yyyy-MM-dd" for API
    static let apiDate: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()

    /// ISO 8601 for API communication
    static let iso8601: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()

    // MARK: - Helpers

    static func formatDateRange(start: Date, end: Date) -> String {
        "\(fullDate.string(from: start)) → \(fullDate.string(from: end))"
    }

    static func tripDuration(start: Date, end: Date) -> String {
        let days = Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0
        return "\(days) Day\(days == 1 ? "" : "s")"
    }

    static func formatOrdinalDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let suffix: String
        switch day {
        case 1, 21, 31: suffix = "st"
        case 2, 22: suffix = "nd"
        case 3, 23: suffix = "rd"
        default: suffix = "th"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return "\(day)\(suffix) \(formatter.string(from: date))"
    }
}
