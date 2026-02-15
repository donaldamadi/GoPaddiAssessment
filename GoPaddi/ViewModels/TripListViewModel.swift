//
//  TripListViewModel.swift
//  GoPaddi
//
//  Manages the list of trips, including fetching, adding, updating, and deleting operations.
//

import Foundation

@MainActor
final class TripListViewModel: ObservableObject {

    // MARK: - Published State

    @Published var trips: [Trip] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showDeleteConfirmation = false
    @Published var tripToDelete: Trip?

    // MARK: - Dependencies

    private let tripService: TripServiceProtocol

    init(tripService: TripServiceProtocol = TripService()) {
        self.tripService = tripService
    }

    // MARK: - Actions

    func loadTrips() async {
        isLoading = true
        errorMessage = nil

        do {
            trips = try await tripService.fetchTrips()
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
        }

        isLoading = false
    }

    func deleteTrip(_ trip: Trip) async {
        do {
            try await tripService.deleteTrip(id: trip.id)
            trips.removeAll { $0.id == trip.id }
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription ?? "Failed to delete trip."
        }
    }

    func confirmDelete(_ trip: Trip) {
        tripToDelete = trip
        showDeleteConfirmation = true
    }

    func addTrip(_ trip: Trip) {
        trips.insert(trip, at: 0)
    }

    func updateTrip(_ trip: Trip) {
        if let index = trips.firstIndex(where: { $0.id == trip.id }) {
            trips[index] = trip
        }
    }
}
