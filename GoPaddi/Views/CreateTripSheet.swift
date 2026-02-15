//
//  CreateTripSheet.swift
//  GoPaddi
//
//  A bottom sheet for creating new trips, featuring input fields for trip details and travel style selection.
//

import SwiftUI

struct CreateTripSheet: View {
    @ObservedObject var viewModel: CreateTripViewModel
    @Environment(\.dismiss) private var dismiss
    let onTripCreated: (Trip) -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xl) {
                    // Header icon + title
                    headerSection

                    // Trip Name
                    tripNameField

                    // Travel Style
                    travelStyleSection

                    // Trip Description
                    descriptionField

                    Spacer(minLength: AppSpacing.xxl)

                    // Next / Create button
                    LoadingButton(
                        title: viewModel.isEditing ? "Update Trip" : "Next",
                        isLoading: viewModel.isLoading
                    ) {
                        Task {
                            if let trip = await viewModel.createTrip() {
                                onTripCreated(trip)
                                dismiss()
                            }
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.lg)
                .padding(.bottom, AppSpacing.xxxl)
            }
            .background(Color.white)
            .navigationTitle("Plan a Trip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(AppColors.textPrimary)
                    }
                }
            }
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            // Subtitle
            Text("Plan Your Dream Trip in Minutes")
                .font(AppTypography.callout())
                .foregroundColor(AppColors.textSecondary)
                .padding(.bottom, AppSpacing.sm)

            // Icon
            HStack {
                Text("🏕")
                    .font(.system(size: 32))
                    .frame(width: 48, height: 48)
                    .background(AppColors.lightGrayBackground)
                    .cornerRadius(AppCornerRadius.medium)

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                        .frame(width: 32, height: 32)
                        .background(AppColors.lightGrayBackground)
                        .clipShape(Circle())
                }
            }

            Text("Create a Trip")
                .font(AppTypography.title(.bold))
                .foregroundColor(AppColors.textPrimary)

            Text("Let's Go! Build Your Next Adventure")
                .font(AppTypography.callout())
                .foregroundColor(AppColors.textSecondary)
        }
    }

    // MARK: - Trip Name Field

    private var tripNameField: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Trip Name")
                .font(AppTypography.callout(.medium))
                .foregroundColor(AppColors.textPrimary)

            TextField("Enter the trip name", text: $viewModel.tripName)
                .font(AppTypography.body())
                .padding(AppSpacing.md)
                .roundedBorder(
                    color: viewModel.tripNameError != nil ? AppColors.error : AppColors.borderColor
                )
                .accessibilityLabel("Trip name")

            if let error = viewModel.tripNameError {
                Text(error)
                    .font(AppTypography.caption())
                    .foregroundColor(AppColors.error)
            }
        }
    }

    // MARK: - Travel Style Section

    private var travelStyleSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Travel Style")
                .font(AppTypography.callout(.medium))
                .foregroundColor(AppColors.textPrimary)

            // Travel style chips
            VStack(spacing: AppSpacing.sm) {
                ForEach(TravelStyle.allCases) { style in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.travelStyle = style
                        }
                    } label: {
                        HStack {
                            Text(style.displayName)
                                .font(AppTypography.body())
                                .foregroundColor(
                                    viewModel.travelStyle == style
                                        ? .white
                                        : AppColors.textPrimary
                                )

                            Spacer()

                            if viewModel.travelStyle == style {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.vertical, AppSpacing.md)
                        .background(
                            viewModel.travelStyle == style
                                ? AppColors.primaryBlue
                                : Color.white
                        )
                        .cornerRadius(AppCornerRadius.small)
                        .roundedBorder(
                            color: viewModel.travelStyle == style
                                ? AppColors.primaryBlue
                                : AppColors.borderColor
                        )
                    }
                    .accessibilityLabel("\(style.displayName) travel style")
                    .accessibilityAddTraits(viewModel.travelStyle == style ? .isSelected : [])
                }
            }

            if let error = viewModel.travelStyleError {
                Text(error)
                    .font(AppTypography.caption())
                    .foregroundColor(AppColors.error)
            }
        }
    }

    // MARK: - Description Field

    private var descriptionField: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Trip Description")
                .font(AppTypography.callout(.medium))
                .foregroundColor(AppColors.textPrimary)

            TextEditor(text: $viewModel.tripDescription)
                .font(AppTypography.body())
                .frame(minHeight: 80)
                .padding(AppSpacing.sm)
                .scrollContentBackground(.hidden)
                .background(Color.white)
                .roundedBorder()
                .accessibilityLabel("Trip description")

            if viewModel.tripDescription.isEmpty {
                Text("Tell us more about the trip")
                    .font(AppTypography.callout())
                    .foregroundColor(AppColors.textTertiary)
                    .padding(.leading, AppSpacing.md)
                    .padding(.top, -70)
                    .allowsHitTesting(false)
            }
        }
    }
}

#Preview {
    CreateTripSheet(viewModel: CreateTripViewModel()) { _ in }
}
