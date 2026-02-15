//
//  Trip.swift
//  GoPaddi
//
//  Represents a Trip entity with associated travel details and computed display properties.
//

import Foundation

/// Represents a travel style option for trip planning
enum TravelStyle: String, Codable, CaseIterable, Identifiable {
    case solo = "Solo"
    case couple = "Couple"
    case family = "Family"
    case group = "Group"
    case business = "Business"

    var id: String { rawValue }

    var displayName: String { rawValue }

    var icon: String {
        switch self {
        case .solo: return "person.fill"
        case .couple: return "person.2.fill"
        case .family: return "figure.2.and.child.holdinghands"
        case .group: return "person.3.fill"
        case .business: return "briefcase.fill"
        }
    }
}

/// Main trip model used across the app
struct Trip: Codable, Identifiable, Hashable {
    let id: String
    var name: String
    var destination: String
    var startDate: String  // "yyyy-MM-dd"
    var endDate: String  // "yyyy-MM-dd"
    var travelStyle: String
    var description: String
    var imageURL: String?
    var location: String?
    var price: Double?

    enum CodingKeys: String, CodingKey {
        case id, destination, startDate, endDate, travelStyle, description, location, price
        case name = "tripName"
        case imageURL = "imageUrl"
    }

    // Identity-based equality and hashing for reliable NavigationPath behavior
    static func == (lhs: Trip, rhs: Trip) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // MARK: - Computed Properties

    var startDateFormatted: Date? {
        AppDateFormatter.apiDate.date(from: startDate)
    }

    var endDateFormatted: Date? {
        AppDateFormatter.apiDate.date(from: endDate)
    }

    var dateRangeDisplay: String {
        guard let start = startDateFormatted, let end = endDateFormatted else {
            return "\(startDate) → \(endDate)"
        }
        return AppDateFormatter.formatDateRange(start: start, end: end)
    }

    var durationDisplay: String {
        guard let start = startDateFormatted, let end = endDateFormatted else {
            return ""
        }
        return AppDateFormatter.tripDuration(start: start, end: end)
    }

    var formattedStartDate: String {
        guard let date = startDateFormatted else { return startDate }
        return AppDateFormatter.formatOrdinalDate(date)
    }

    var travelStyleEnum: TravelStyle? {
        TravelStyle(rawValue: travelStyle)
    }

    var locationDisplay: String {
        if let location = location, !location.isEmpty {
            return "\(location) | \(travelStyle) Trip"
        }
        return "\(destination) | \(travelStyle) Trip"
    }
}

// MARK: - Trip Creation DTO

struct CreateTripRequest: Codable {
    let name: String
    let destination: String
    let startDate: String
    let endDate: String
    let travelStyle: String
    let description: String
    let location: String?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case destination, startDate, endDate, travelStyle, description, location
        case name = "tripName"
        case imageURL = "imageUrl"
    }
}

// MARK: - Preview Data

extension Trip {
    /// For SwiftUI previews and unit tests only
    static let sample = Trip(
        id: "preview-1",
        name: "Bahamas Family Trip",
        destination: "Lagos, Nigeria",
        startDate: "2024-03-21",
        endDate: "2024-04-21",
        travelStyle: "Solo",
        description: "A wonderful family vacation to the Bahamas",
        imageURL: nil,
        location: "New York, United States of America",
        price: 123450.00
    )
}
