//
//  TripCardView.swift
//  GoPaddi
//
//  A card view displaying trip details such as image, destination, title, date, and duration.
//

import SwiftUI

struct TripCardView: View {
    let trip: Trip

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Trip Image
            ZStack(alignment: .topTrailing) {
                Image("trip_placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 186)
                    .contentShape(Rectangle())
                    .clipped()
                    .overlay(
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.1)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                // City badge
                Text(trip.destination.components(separatedBy: ",").first ?? trip.destination)
                    .font(AppTypography.caption(.medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, AppSpacing.sm)
                    .padding(.vertical, AppSpacing.xs)
                    .background(Color.black.opacity(0.55))
                    .cornerRadius(AppCornerRadius.small)
                    .padding(AppSpacing.md)
            }
            .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.medium))

            // Trip Info
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(trip.name)
                    .font(AppTypography.headline(.bold))
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(1)

                HStack {
                    Text(trip.formattedStartDate)
                        .font(AppTypography.callout())
                        .foregroundColor(AppColors.textSecondary)

                    Spacer()

                    Text(trip.durationDisplay)
                        .font(AppTypography.callout())
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.top, AppSpacing.md)
            .padding(.bottom, AppSpacing.sm)

            // View Button — uses NavigationLink for reliable navigation
            NavigationLink(value: trip) {
                Text("View")
                    .font(AppTypography.body(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(AppColors.primaryBlue)
                    .cornerRadius(AppCornerRadius.small)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, AppSpacing.md)
            .padding(.bottom, AppSpacing.lg)
            .accessibilityLabel("View \(trip.name)")
        }
        .background(Color.white)
        .cornerRadius(AppCornerRadius.medium)
        .cardShadow()
    }
}

#Preview {
    NavigationStack {
        TripCardView(trip: .sample)
            .padding()
            .background(Color.gray.opacity(0.1))
            .navigationDestination(for: Trip.self) { trip in
                Text("Detail for \(trip.name)")
            }
    }
}
