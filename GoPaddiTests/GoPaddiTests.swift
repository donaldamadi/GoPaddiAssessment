//
//  GoPaddiTests.swift
//  GoPaddiTests
//
//  Created by Obinna Amadi on 15/02/2026.
//

import Testing
import XCTest

@testable import GoPaddi

final class GoPaddiTests: XCTestCase {

    // MARK: - Model Tests

    func testTripDurationCalculation() {
        let trip = Trip(
            id: "1",
            name: "Test Trip",
            destination: "Lagos",
            startDate: "2024-01-01",
            endDate: "2024-01-05",
            travelStyle: "Solo",
            description: "Desc",
            imageURL: nil,
            location: nil,
            price: nil
        )

        // 1st to 5th is 4 days difference
        XCTAssertEqual(trip.durationDisplay, "4 Days")
    }

    func testTripDateRangeDisplay() {
        let trip = Trip(
            id: "1",
            name: "Test Trip",
            destination: "Lagos",
            startDate: "2024-01-01",
            endDate: "2024-01-05",
            travelStyle: "Solo",
            description: "Desc",
            imageURL: nil,
            location: nil,
            price: nil
        )
        let range = trip.dateRangeDisplay
        XCTAssertTrue(range.contains("January 2024"))
        XCTAssertTrue(range.contains("→"))
    }

    // MARK: - ViewModel Tests

    @MainActor
    func testTripListViewModel_LoadTrips_Success() async {
        // Given
        let mockService = MockTripService()
        mockService.mockTrips = [Trip.sample]
        let viewModel = TripListViewModel(tripService: mockService)

        // When
        await viewModel.loadTrips()

        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.trips.count, 1)
        XCTAssertEqual(viewModel.trips.first?.id, Trip.sample.id)
    }

    @MainActor
    func testTripListViewModel_LoadTrips_Failure() async {
        // Given
        let mockService = MockTripService()
        mockService.shouldFail = true
        let viewModel = TripListViewModel(tripService: mockService)

        // When
        await viewModel.loadTrips()

        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.trips.isEmpty)
    }

    @MainActor
    func testTripListViewModel_DeleteTrip() async {
        // Given
        let mockService = MockTripService()
        let trip = Trip.sample
        mockService.mockTrips = [trip]
        let viewModel = TripListViewModel(tripService: mockService)
        await viewModel.loadTrips()  // Load initial data

        // When
        await viewModel.deleteTrip(trip)

        // Then
        XCTAssertTrue(viewModel.trips.isEmpty)
    }
}

// MARK: - Mock Service
class MockTripService: TripServiceProtocol {
    var mockTrips: [Trip] = []
    var shouldFail = false

    func fetchTrips() async throws -> [GoPaddi.Trip] {
        if shouldFail { throw NetworkError.unknown }
        return mockTrips
    }

    func fetchTrip(id: String) async throws -> GoPaddi.Trip {
        if shouldFail { throw NetworkError.unknown }
        return mockTrips.first { $0.id == id } ?? .sample
    }

    func createTrip(_ request: GoPaddi.CreateTripRequest) async throws -> GoPaddi.Trip {
        if shouldFail { throw NetworkError.unknown }
        return .sample
    }

    func updateTrip(id: String, _ request: GoPaddi.CreateTripRequest) async throws -> GoPaddi.Trip {
        if shouldFail { throw NetworkError.unknown }
        return .sample
    }

    func deleteTrip(id: String) async throws {
        if shouldFail { throw NetworkError.unknown }
        mockTrips.removeAll { $0.id == id }
    }
}
