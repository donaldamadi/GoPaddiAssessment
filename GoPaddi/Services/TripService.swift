//
//  TripService.swift
//  GoPaddi
//
//  Handles business logic for Trip data operations, interacting with the API client.
//

import Foundation

/// Defines the contract for trip-related data operations, supporting dependency injection and testing.
protocol TripServiceProtocol {
    func fetchTrips() async throws -> [Trip]
    func fetchTrip(id: String) async throws -> Trip
    func createTrip(_ request: CreateTripRequest) async throws -> Trip
    func updateTrip(id: String, _ request: CreateTripRequest) async throws -> Trip
    func deleteTrip(id: String) async throws
}

/// A concrete implementation of TripServiceProtocol that utilizes the shared APIClient.
final class TripService: TripServiceProtocol {

    private let client: APIClientProtocol

    init(client: APIClientProtocol = APIClient.shared) {
        self.client = client
    }

    func fetchTrips() async throws -> [Trip] {
        let endpoint = APIEndpoint(path: "/trips")
        return try await client.request(endpoint)
    }

    func fetchTrip(id: String) async throws -> Trip {
        let endpoint = APIEndpoint(path: "/trips/\(id)")
        return try await client.request(endpoint)
    }

    func createTrip(_ request: CreateTripRequest) async throws -> Trip {
        let endpoint = APIEndpoint(path: "/trips", method: .post, body: request)
        return try await client.request(endpoint)
    }

    func updateTrip(id: String, _ request: CreateTripRequest) async throws -> Trip {
        let endpoint = APIEndpoint(path: "/trips/\(id)", method: .put, body: request)
        return try await client.request(endpoint)
    }

    func deleteTrip(id: String) async throws {
        let endpoint = APIEndpoint(path: "/trips/\(id)", method: .delete)
        try await client.requestVoid(endpoint)
    }
}
