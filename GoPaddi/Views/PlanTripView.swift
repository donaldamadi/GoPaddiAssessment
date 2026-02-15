//
//  PlanTripView.swift
//  GoPaddi
//
//  The main landing screen for planning trips, featuring a hero section, trip creation form, and a list of existing trips.
//

import SwiftUI

struct PlanTripView: View {
    @StateObject private var listViewModel = TripListViewModel()
    @StateObject private var createViewModel = CreateTripViewModel()

    @State private var showCitySearch = false
    @State private var showDatePicker = false
    @State private var showCreateSheet = false
    @State private var showAbout = false
    @State private var isSelectingStartDate = true
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xxl) {
                    // Hero section
                    heroSection

                    // Trip form card
                    tripFormCard

                    // Your Trips section
                    yourTripsSection

                    // Trip list
                    tripListSection
                }
                .padding(.bottom, AppSpacing.xxxl)
            }
            .background(AppColors.lightGrayBackground)
            .navigationTitle("Plan a Trip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        // Back action
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(AppColors.textPrimary)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAbout = true
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundColor(AppColors.primaryBlue)
                    }
                    .accessibilityLabel("About App")
                }
            }
            .sheet(isPresented: $showAbout) {
                AboutViewRepresentable()
            }

            .task {
                await listViewModel.loadTrips()
            }
            .refreshable {
                await listViewModel.loadTrips()
            }
            .fullScreenCover(isPresented: $showCitySearch) {
                CitySearchView { city in
                    createViewModel.selectCity(city)
                    showCitySearch = false
                }
            }
            .fullScreenCover(isPresented: $showDatePicker) {
                DatePickerView(
                    startDate: $createViewModel.startDate,
                    endDate: $createViewModel.endDate,
                    isSelectingStart: isSelectingStartDate
                ) {
                    // Date confirmed
                }
            }
            .sheet(isPresented: $showCreateSheet) {
                CreateTripSheet(viewModel: createViewModel) { trip in
                    listViewModel.addTrip(trip)
                    createViewModel.reset()
                }
                .presentationDetents([.large])
            }
            .navigationDestination(for: Trip.self) { trip in
                TripDetailRepresentable(
                    trip: trip,
                    onDelete: {
                        Task {
                            await listViewModel.deleteTrip(trip)
                        }
                        navigationPath.removeLast()
                    }
                )
                .ignoresSafeArea()
                .navigationBarHidden(true)
            }
            .alert("Delete Trip", isPresented: $listViewModel.showDeleteConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    if let trip = listViewModel.tripToDelete {
                        Task { await listViewModel.deleteTrip(trip) }
                    }
                }
            } message: {
                Text("Are you sure you want to delete this trip? This action cannot be undone.")
            }
        }
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        ZStack(alignment: .topLeading) {
            // Background image covering the entire hero section
            Image("hotel_hero")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity)
                .frame(height: 350)
                .clipped()

            // Subtle overlay for text readability
            LinearGradient(
                colors: [
                    Color(red: 0.85, green: 0.93, blue: 0.98).opacity(0.85),
                    Color(red: 0.85, green: 0.93, blue: 0.98).opacity(0.3),
                    Color.clear,
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            // Text content overlaid on the image
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Plan Your Dream Trip in Minutes")
                    .font(AppTypography.title(.bold))
                    .foregroundColor(AppColors.textPrimary)

                Text(
                    "Build, personalize, and optimize your itineraries with our trip planner. Perfect for getaways, remote workations, and any spontaneous escapade."
                )
                .font(AppTypography.callout())
                .foregroundColor(AppColors.textSecondary)
                .lineSpacing(4)
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.top, AppSpacing.lg)
        }
        .frame(height: 350)
        .clipped()
    }

    // MARK: - Trip Form Card

    private var tripFormCard: some View {
        VStack(spacing: AppSpacing.md) {
            // Where to
            Button {
                showCitySearch = true
            } label: {
                HStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(AppColors.textTertiary)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Where to?")
                            .font(AppTypography.caption())
                            .foregroundColor(AppColors.textSecondary)

                        Text(
                            createViewModel.destination.isNotEmpty
                                ? createViewModel.destination : "Select City"
                        )
                        .font(AppTypography.callout(.medium))
                        .foregroundColor(
                            createViewModel.destination.isNotEmpty
                                ? AppColors.textPrimary
                                : AppColors.textTertiary
                        )
                    }

                    Spacer()
                }
                .padding(AppSpacing.md)
                .background(Color.white)
                .roundedBorder()
            }
            .accessibilityLabel(
                "Select destination. Currently: \(createViewModel.destination.isNotEmpty ? createViewModel.destination : "none selected")"
            )

            // Date row
            HStack(spacing: AppSpacing.md) {
                // Start Date
                Button {
                    isSelectingStartDate = true
                    showDatePicker = true
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Start Date")
                            .font(AppTypography.caption())
                            .foregroundColor(AppColors.textSecondary)

                        Text(
                            createViewModel.startDate != nil
                                ? AppDateFormatter.shortDate.string(
                                    from: createViewModel.startDate!)
                                : "Enter Date"
                        )
                        .font(AppTypography.callout(.medium))
                        .foregroundColor(
                            createViewModel.startDate != nil
                                ? AppColors.textPrimary
                                : AppColors.textTertiary
                        )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(AppSpacing.md)
                    .background(Color.white)
                    .roundedBorder()
                }
                .accessibilityLabel("Start date")

                // End Date
                Button {
                    isSelectingStartDate = false
                    showDatePicker = true
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("End Date")
                            .font(AppTypography.caption())
                            .foregroundColor(AppColors.textSecondary)

                        Text(
                            createViewModel.endDate != nil
                                ? AppDateFormatter.shortDate.string(from: createViewModel.endDate!)
                                : "Enter Date"
                        )
                        .font(AppTypography.callout(.medium))
                        .foregroundColor(
                            createViewModel.endDate != nil
                                ? AppColors.textPrimary
                                : AppColors.textTertiary
                        )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(AppSpacing.md)
                    .background(Color.white)
                    .roundedBorder()
                }
                .accessibilityLabel("End date")
            }

            // Create Trip button
            Button {
                if createViewModel.destination.isEmpty || createViewModel.startDate == nil
                    || createViewModel.endDate == nil
                {
                    // Show validation hints
                    if createViewModel.destination.isEmpty {
                        showCitySearch = true
                    } else if createViewModel.startDate == nil {
                        isSelectingStartDate = true
                        showDatePicker = true
                    } else {
                        isSelectingStartDate = false
                        showDatePicker = true
                    }
                } else {
                    showCreateSheet = true
                }
            } label: {
                Text("Create a Trip")
                    .font(AppTypography.body(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(AppColors.primaryBlue)
                    .cornerRadius(AppCornerRadius.small)
            }
            .accessibilityLabel("Create a new trip")
        }
        .padding(AppSpacing.lg)
        .background(Color.white)
        .cornerRadius(AppCornerRadius.large)
        .cardShadow()
        .padding(.horizontal, AppSpacing.lg)
    }

    // MARK: - Your Trips Section

    private var yourTripsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("Your Trips")
                .font(AppTypography.headline(.bold))
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal, AppSpacing.lg)

            Text("Your trip itineraries and planned trips are placed here")
                .font(AppTypography.caption())
                .foregroundColor(AppColors.textSecondary)
                .padding(.horizontal, AppSpacing.lg)

            // Filter dropdown
            HStack {
                Menu {
                    Button("Planned Trips") {}
                    Button("Past Trips") {}
                    Button("All Trips") {}
                } label: {
                    HStack(spacing: AppSpacing.sm) {
                        Text("Planned Trips")
                            .font(AppTypography.callout(.medium))
                            .foregroundColor(AppColors.textPrimary)

                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.vertical, AppSpacing.sm)
                    .background(Color.white)
                    .roundedBorder()
                }

                Spacer()
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.top, AppSpacing.sm)
        }
    }

    // MARK: - Trip List

    private var tripListSection: some View {
        Group {
            if listViewModel.isLoading && listViewModel.trips.isEmpty {
                LoadingView(message: "Loading your trips...")
                    .frame(height: 200)
            } else if listViewModel.trips.isEmpty {
                EmptyStateView(
                    icon: "airplane.departure",
                    title: "No Trips Yet",
                    message: "Start planning your next adventure by creating a trip above!"
                )
                .frame(height: 250)
            } else {
                VStack(spacing: AppSpacing.lg) {
                    ForEach(listViewModel.trips) { trip in
                        TripCardView(trip: trip)
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
            }

            if let error = listViewModel.errorMessage {
                Text(error)
                    .font(AppTypography.caption())
                    .foregroundColor(AppColors.textSecondary)
                    .padding(.horizontal, AppSpacing.lg)
            }
        }
    }
}

#Preview {
    PlanTripView()
}
