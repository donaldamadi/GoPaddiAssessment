//
//  City.swift
//  GoPaddi
//
//  Represents a city destination with country details and flag emoji generation.
//

import Foundation

struct City: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let country: String
    let countryCode: String

    var displayName: String { name }
    var subtitle: String { country.isEmpty ? name : country }
    var fullName: String { "\(name), \(country)" }

    /// Returns the flag emoji from a country code
    var flagEmoji: String {
        let base: UInt32 = 127397
        return countryCode.uppercased().unicodeScalars
            .compactMap { UnicodeScalar(base + $0.value) }
            .map { String($0) }
            .joined()
    }
}

// MARK: - Static City Data

extension City {
    static let allCities: [City] = [
        City(name: "Laghouat", country: "Algeria", countryCode: "DZ"),
        City(name: "Lagos", country: "Nigeria", countryCode: "NG"),
        City(name: "Doha", country: "Qatar", countryCode: "QA"),
        City(name: "Dubai", country: "United Arab Emirates", countryCode: "AE"),
        City(name: "Paris", country: "France", countryCode: "FR"),
        City(name: "London", country: "United Kingdom", countryCode: "GB"),
        City(name: "New York", country: "United States", countryCode: "US"),
        City(name: "Tokyo", country: "Japan", countryCode: "JP"),
        City(name: "Sydney", country: "Australia", countryCode: "AU"),
        City(name: "Cairo", country: "Egypt", countryCode: "EG"),
        City(name: "Nairobi", country: "Kenya", countryCode: "KE"),
        City(name: "Cape Town", country: "South Africa", countryCode: "ZA"),
        City(name: "Accra", country: "Ghana", countryCode: "GH"),
        City(name: "Abuja", country: "Nigeria", countryCode: "NG"),
        City(name: "Mumbai", country: "India", countryCode: "IN"),
        City(name: "Singapore", country: "Singapore", countryCode: "SG"),
        City(name: "Barcelona", country: "Spain", countryCode: "ES"),
        City(name: "Rome", country: "Italy", countryCode: "IT"),
        City(name: "Berlin", country: "Germany", countryCode: "DE"),
        City(name: "Istanbul", country: "Turkey", countryCode: "TR"),
        City(name: "Bangkok", country: "Thailand", countryCode: "TH"),
        City(name: "Bahamas", country: "The Bahamas", countryCode: "BS"),
        City(name: "Melbourne", country: "Australia", countryCode: "AU"),
    ]

    static func search(query: String) -> [City] {
        guard query.isNotEmpty else { return allCities }
        let lowered = query.lowercased()
        return allCities.filter {
            $0.name.lowercased().contains(lowered) || $0.country.lowercased().contains(lowered)
                || $0.countryCode.lowercased().contains(lowered)
        }
    }
}
