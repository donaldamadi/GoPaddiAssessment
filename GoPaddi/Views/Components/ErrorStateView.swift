//
//  ErrorStateView.swift
//  GoPaddi
//
//  A reusable component for displaying error messages with a retry option.
//

import SwiftUI

struct ErrorStateView: View {
    let message: String
    var retryAction: (() -> Void)?

    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(AppColors.warning)

            Text("Something went wrong")
                .font(AppTypography.headline())
                .foregroundColor(AppColors.textPrimary)

            Text(message)
                .font(AppTypography.callout())
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.xxxl)

            if let retryAction = retryAction {
                Button(action: retryAction) {
                    Text("Try Again")
                        .font(AppTypography.body(.semibold))
                        .foregroundColor(.white)
                        .frame(width: 160, height: 44)
                        .background(AppColors.primaryBlue)
                        .cornerRadius(AppCornerRadius.small)
                }
                .padding(.top, AppSpacing.sm)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.xxxl)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Error: \(message)")
    }
}

#Preview {
    ErrorStateView(message: "Network request failed. Please check your connection.")
}
