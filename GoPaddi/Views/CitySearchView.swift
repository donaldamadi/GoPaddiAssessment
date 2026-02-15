//
//  CitySearchView.swift
//  GoPaddi
//
//  A full-screen view for searching and selecting cities, featuring a debounced search field and a list of results.
//

import SwiftUI

struct CitySearchView: View {
    @StateObject private var viewModel = CitySearchViewModel()
    @Environment(\.dismiss) private var dismiss
    let onSelect: (City) -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Header
            header

            Divider()

            // Search Field
            searchField

            // City List
            cityList
        }
        .background(Color.white)
        .navigationBarHidden(true)
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
                    .frame(width: 40, height: 40)
            }
            .accessibilityLabel("Close")

            Spacer()

            Text("Where")
                .font(AppTypography.headline(.semibold))
                .foregroundColor(AppColors.textPrimary)

            Spacer()

            // Invisible placeholder for alignment
            Color.clear
                .frame(width: 40, height: 40)
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.sm)
    }

    // MARK: - Search Field

    private var searchField: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Please select a city")
                .font(AppTypography.callout())
                .foregroundColor(AppColors.textSecondary)

            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.textTertiary)

                TextField("Search cities...", text: $viewModel.searchQuery)
                    .font(AppTypography.body())
                    .autocorrectionDisabled()
                    .accessibilityLabel("Search for a city")

                if viewModel.searchQuery.isNotEmpty {
                    Button {
                        viewModel.searchQuery = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.textTertiary)
                    }
                    .accessibilityLabel("Clear search")
                }
            }
            .padding(AppSpacing.md)
            .background(Color.white)
            .roundedBorder()
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.lg)
    }

    // MARK: - City List

    private var cityList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.filteredCities) { city in
                    Button {
                        onSelect(city)
                    } label: {
                        cityRow(city)
                    }
                    .accessibilityLabel("\(city.name), \(city.country)")

                    Divider()
                        .padding(.leading, 60)
                }
            }
        }
    }

    private func cityRow(_ city: City) -> some View {
        HStack(spacing: AppSpacing.md) {
            // Flag
            Text(city.flagEmoji)
                .font(.system(size: 28))
                .frame(width: 36)

            // City details
            VStack(alignment: .leading, spacing: 2) {
                Text(city.name)
                    .font(AppTypography.body(.medium))
                    .foregroundColor(AppColors.textPrimary)

                Text(city.subtitle)
                    .font(AppTypography.caption())
                    .foregroundColor(AppColors.textSecondary)
            }

            Spacer()

            // Country code
            Text(city.countryCode)
                .font(AppTypography.caption(.medium))
                .foregroundColor(AppColors.textTertiary)
                .padding(.horizontal, AppSpacing.sm)
                .padding(.vertical, AppSpacing.xs)
                .background(AppColors.inputBackground)
                .cornerRadius(AppCornerRadius.small)
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
        .contentShape(Rectangle())
    }
}

#Preview {
    NavigationStack {
        CitySearchView { city in
            print("Selected: \(city.fullName)")
        }
    }
}
