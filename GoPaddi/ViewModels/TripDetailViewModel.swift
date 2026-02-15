//
//  TripDetailViewModel.swift
//  GoPaddi
//
//  Manages the state for the Trip Detail screen, including fetching and deleting trip data.
//

import Foundation

@MainActor
final class TripDetailViewModel: ObservableObject {

    // MARK: - Published State

    @Published var trip: Trip
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showDeleteConfirmation = false
    @Published var isDeleted = false

    // MARK: - Dependencies

    private let tripService: TripServiceProtocol

    init(trip: Trip, tripService: TripServiceProtocol = TripService()) {
        self.trip = trip
        self.tripService = tripService
    }

    // MARK: - Actions

    func refreshTrip() async {
        isLoading = true
        do {
            trip = try await tripService.fetchTrip(id: trip.id)
        } catch {
            // Keep existing trip data on refresh failure
            errorMessage = "Could not refresh trip data."
        }
        isLoading = false
    }

    func deleteTrip() async -> Bool {
        isLoading = true
        do {
            try await tripService.deleteTrip(id: trip.id)
            isDeleted = true
            isLoading = false
            return true
        } catch {
            errorMessage =
                (error as? NetworkError)?.errorDescription
                ?? "Failed to delete trip. Please try again."
            isLoading = false
            return false
        }
    }
}
