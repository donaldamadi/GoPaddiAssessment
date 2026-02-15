//
//  LocalData.swift
//  GoPaddi
//
//  Static data for offline fallback when API is unavailable.
//

import Foundation

enum LocalData {
    static let backupTrips: [Trip] = [
        Trip(
            id: "1",
            name: "Paris Getaway",
            destination: "Paris, France",
            startDate: "2025-05-10",
            endDate: "2025-05-17",
            travelStyle: "Couple",
            description: "Romantic week exploring Paris cafes and landmarks.",
            imageURL: "https://images.unsplash.com/photo-1502602898657-3e91760cbb34",
            location: nil,
            price: nil
        ),
        Trip(
            id: "2",
            name: "Dubai Adventure",
            destination: "Dubai, UAE",
            startDate: "2025-06-02",
            endDate: "2025-06-09",
            travelStyle: "Solo",
            description: "Luxury shopping, desert safari, and city exploration.",
            imageURL: "https://images.unsplash.com/photo-1512453979798-5ea266f8880c",
            location: nil,
            price: nil
        ),
        Trip(
            id: "3",
            name: "New York Business Trip",
            destination: "New York, USA",
            startDate: "2025-07-15",
            endDate: "2025-07-20",
            travelStyle: "Business",
            description: "Meetings, networking, and quick sightseeing.",
            imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9",
            location: nil,
            price: nil
        ),
        Trip(
            id: "4",
            name: "Bali Retreat",
            destination: "Bali, Indonesia",
            startDate: "2025-08-01",
            endDate: "2025-08-12",
            travelStyle: "Family",
            description: "Relaxation, beaches, temples, and cultural tours.",
            imageURL: "https://images.unsplash.com/photo-1537996194471-e657df975ab4",
            location: nil,
            price: nil
        ),
        Trip(
            id: "5",
            name: "Tokyo Exploration",
            destination: "Tokyo, Japan",
            startDate: "2025-09-05",
            endDate: "2025-09-14",
            travelStyle: "Solo",
            description: "Tech culture, sushi spots, and city nightlife.",
            imageURL: "https://images.unsplash.com/photo-1503899036084-c55cdd92da26",
            location: nil,
            price: nil
        ),
        Trip(
            id: "6",
            name: "Cape Town Escape",
            destination: "Cape Town, South Africa",
            startDate: "2025-10-10",
            endDate: "2025-10-18",
            travelStyle: "Couple",
            description: "Table Mountain, beaches, and wine tasting.",
            imageURL: "https://images.unsplash.com/photo-1518546305927-5a555bb7020d",
            location: nil,
            price: nil
        ),
        Trip(
            id: "7",
            name: "London Cultural Tour",
            destination: "London, UK",
            startDate: "2025-11-03",
            endDate: "2025-11-10",
            travelStyle: "Family",
            description: "Museums, theatre shows, and historic sites.",
            imageURL: "https://images.unsplash.com/photo-1513635269975-59663e0ac1ad",
            location: nil,
            price: nil
        ),
        Trip(
            id: "8",
            name: "Sydney Summer Trip",
            destination: "Sydney, Australia",
            startDate: "2025-12-05",
            endDate: "2025-12-15",
            travelStyle: "Group",
            description: "Beach fun, city tours, and nightlife.",
            imageURL: "https://images.unsplash.com/photo-1506973035872-a4ec16b8e8d9",
            location: nil,
            price: nil
        ),
        Trip(
            id: "9",
            name: "Rome History Tour",
            destination: "Rome, Italy",
            startDate: "2026-01-12",
            endDate: "2026-01-20",
            travelStyle: "Couple",
            description: "Ancient ruins, Vatican tours, and Italian cuisine.",
            imageURL: "https://images.unsplash.com/photo-1529156069898-49953e39b3ac",
            location: nil,
            price: nil
        ),
        Trip(
            id: "10",
            name: "Lagos Staycation",
            destination: "Lagos, Nigeria",
            startDate: "2026-02-08",
            endDate: "2026-02-14",
            travelStyle: "Solo",
            description: "Local relaxation, beaches, and city experiences.",
            imageURL: "https://images.unsplash.com/photo-1576485290814-1c72aa4bbb8e",
            location: nil,
            price: nil
        ),
    ]
}
