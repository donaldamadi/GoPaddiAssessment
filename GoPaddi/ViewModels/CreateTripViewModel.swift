//
//  CreateTripViewModel.swift
//  GoPaddi
//
//  Manages form state, validation, and API interactions for creating and editing trips.
//

import Foundation

@MainActor
final class CreateTripViewModel: ObservableObject {

    // MARK: - Form Fields

    @Published var tripName: String = ""
    @Published var destination: String = ""
    @Published var selectedCity: City?
    @Published var startDate: Date?
    @Published var endDate: Date?
    @Published var travelStyle: TravelStyle?
    @Published var tripDescription: String = ""

    // MARK: - State

    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var createdTrip: Trip?
    @Published var isSuccess = false

    // MARK: - Validation

    @Published var tripNameError: String?
    @Published var destinationError: String?
    @Published var dateError: String?
    @Published var travelStyleError: String?

    // MARK: - Navigation

    @Published var showCitySearch = false
    @Published var showDatePicker = false
    @Published var isSelectingStartDate = true

    // MARK: - Dependencies

    private let tripService: TripServiceProtocol
    private var editingTrip: Trip?

    var isEditing: Bool { editingTrip != nil }

    init(tripService: TripServiceProtocol = TripService(), trip: Trip? = nil) {
        self.tripService = tripService
        if let trip = trip {
            self.editingTrip = trip
            self.tripName = trip.name
            self.destination = trip.destination
            self.travelStyle = TravelStyle(rawValue: trip.travelStyle)
            self.tripDescription = trip.description
            self.startDate = AppDateFormatter.apiDate.date(from: trip.startDate)
            self.endDate = AppDateFormatter.apiDate.date(from: trip.endDate)
        }
    }

    // MARK: - Validation

    var isFormValid: Bool {
        validateForm()
        return tripNameError == nil && destinationError == nil && dateError == nil
            && travelStyleError == nil
    }

    @discardableResult
    func validateForm() -> Bool {
        tripNameError = tripName.isNotEmpty ? nil : "Trip name is required"
        destinationError = destination.isNotEmpty ? nil : "Please select a destination"

        if startDate == nil || endDate == nil {
            dateError = "Please select start and end dates"
        } else if let start = startDate, let end = endDate, end < start {
            dateError = "End date must be after start date"
        } else {
            dateError = nil
        }

        travelStyleError = travelStyle != nil ? nil : "Please select a travel style"

        return tripNameError == nil && destinationError == nil && dateError == nil
            && travelStyleError == nil
    }

    // MARK: - Date Validation

    /// Returns the minimum allowed date for the end date picker
    var minimumEndDate: Date {
        startDate ?? Date()
    }

    /// Validates that end date >= start date when either changes
    func validateDateSelection() {
        guard let start = startDate, let end = endDate else { return }
        if end < start {
            endDate = start
        }
    }

    // MARK: - City Selection

    func selectCity(_ city: City) {
        selectedCity = city
        destination = city.fullName
        showCitySearch = false
    }

    // MARK: - API Actions

    func createTrip() async -> Trip? {
        guard validateForm() else { return nil }

        isLoading = true
        errorMessage = nil

        let request = CreateTripRequest(
            name: tripName,
            destination: destination,
            startDate: AppDateFormatter.apiDate.string(from: startDate!),
            endDate: AppDateFormatter.apiDate.string(from: endDate!),
            travelStyle: travelStyle!.rawValue,
            description: tripDescription,
            location: selectedCity?.fullName,
            imageURL: nil
        )

        do {
            if let existingTrip = editingTrip {
                let updated = try await tripService.updateTrip(id: existingTrip.id, request)
                createdTrip = updated
                isSuccess = true
                isLoading = false
                return updated
            } else {
                let trip = try await tripService.createTrip(request)
                createdTrip = trip
                isSuccess = true
                isLoading = false
                return trip
            }
        } catch {
            errorMessage =
                (error as? NetworkError)?.errorDescription
                ?? "Failed to save trip. Please try again."
            isLoading = false
            return nil
        }
    }

    func reset() {
        tripName = ""
        destination = ""
        selectedCity = nil
        startDate = nil
        endDate = nil
        travelStyle = nil
        tripDescription = ""
        tripNameError = nil
        destinationError = nil
        dateError = nil
        travelStyleError = nil
        errorMessage = nil
        createdTrip = nil
        isSuccess = false
        editingTrip = nil
    }
}
