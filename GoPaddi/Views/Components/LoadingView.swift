//
//  LoadingView.swift
//  GoPaddi
//
//  A reusable component for displaying a loading indicator with an optional message.
//

import SwiftUI

struct LoadingView: View {
    var message: String = "Loading..."

    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: AppColors.primaryBlue))
                .scaleEffect(1.2)

            Text(message)
                .font(AppTypography.callout())
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(message)
    }
}

// MARK: - Inline Loading Button

struct LoadingButton: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                }
                Text(isLoading ? "Please wait..." : title)
                    .font(AppTypography.body(.semibold))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(isLoading ? AppColors.primaryBlue.opacity(0.7) : AppColors.primaryBlue)
            .foregroundColor(.white)
            .cornerRadius(AppCornerRadius.small)
        }
        .disabled(isLoading)
        .accessibilityLabel(isLoading ? "Loading" : title)
    }
}

#Preview {
    LoadingView()
}
