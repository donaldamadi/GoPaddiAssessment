//
//  EmptyStateView.swift
//  GoPaddi
//
//  A reusable component for displaying an empty state with an icon, message, and optional action button.
//

import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(AppColors.textTertiary)

            Text(title)
                .font(AppTypography.headline())
                .foregroundColor(AppColors.textPrimary)

            Text(message)
                .font(AppTypography.callout())
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.xxxl)

            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(AppTypography.body(.semibold))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 44)
                        .background(AppColors.primaryBlue)
                        .cornerRadius(AppCornerRadius.small)
                }
                .padding(.top, AppSpacing.sm)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    EmptyStateView(
        icon: "airplane",
        title: "No Trips Yet",
        message: "Start planning your next adventure!",
        actionTitle: "Create Trip"
    )
}
