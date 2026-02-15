//
//  Extensions.swift
//  GoPaddi
//
//  Utility extensions for SwiftUI Views and standard types.
//

import SwiftUI

// MARK: - View Extensions

extension View {
    /// Apply a card-style shadow
    func cardShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
    }

    /// Rounded border style
    func roundedBorder(
        color: Color = AppColors.borderColor, radius: CGFloat = AppCornerRadius.medium
    ) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: radius)
                .stroke(color, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: radius))
    }

    /// Standard screen horizontal padding
    func screenPadding() -> some View {
        self.padding(.horizontal, AppSpacing.lg)
    }

    /// Conditional modifier
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - String Extensions

extension String {
    var isNotEmpty: Bool {
        !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
