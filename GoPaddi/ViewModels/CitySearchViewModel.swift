//
//  CitySearchViewModel.swift
//  GoPaddi
//
//  Manages the state and logic for city searching, including debounced user input handling.
//

import Combine
import Foundation

@MainActor
final class CitySearchViewModel: ObservableObject {

    @Published var searchQuery: String = ""
    @Published var filteredCities: [City] = City.allCities

    private var cancellables = Set<AnyCancellable>()

    init() {
        // Debounced search for smooth UX
        $searchQuery
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.filteredCities = City.search(query: query)
            }
            .store(in: &cancellables)
    }
}
