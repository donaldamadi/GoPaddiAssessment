//
//  DesignSystem.swift
//  GoPaddi
//
//  Defines variable constants for application-wide design tokens including colors, typography, and spacing.
//

import SwiftUI
import UIKit

// MARK: - Colors

enum AppColors {
    static let primaryBlue = Color(hex: "0D6EFD")
    static let darkBackground = Color(hex: "1A1A2E")
    static let cardBackground = Color.white
    static let textPrimary = Color(hex: "1D1D1D")
    static let textSecondary = Color(hex: "676E7E")
    static let textTertiary = Color(hex: "9CA3AF")
    static let borderColor = Color(hex: "E4E7EC")
    static let lightGrayBackground = Color(hex: "F7F9FC")
    static let inputBackground = Color(hex: "F0F2F5")

    // Itinerary section colors
    static let activitiesBlue = Color(hex: "0D6EFD")
    static let hotelsBlue = Color(hex: "0D6EFD")
    static let flightsRed = Color(hex: "FE3B30")
    static let flightsBackground = Color(hex: "FFF2F1")

    // Status
    static let success = Color(hex: "34C759")
    static let warning = Color(hex: "FF9500")
    static let error = Color(hex: "FF3B30")

    // Remove button
    static let removeBackground = Color(hex: "FBEAE9")
    static let removeText = Color(hex: "9E0A05")
}

// MARK: - Typography

enum AppTypography {
    static func largeTitle(_ weight: Font.Weight = .bold) -> Font {
        .system(size: 24, weight: weight, design: .default)
    }

    static func title(_ weight: Font.Weight = .semibold) -> Font {
        .system(size: 20, weight: weight, design: .default)
    }

    static func headline(_ weight: Font.Weight = .semibold) -> Font {
        .system(size: 17, weight: weight, design: .default)
    }

    static func body(_ weight: Font.Weight = .regular) -> Font {
        .system(size: 15, weight: weight, design: .default)
    }

    static func callout(_ weight: Font.Weight = .regular) -> Font {
        .system(size: 14, weight: weight, design: .default)
    }

    static func caption(_ weight: Font.Weight = .regular) -> Font {
        .system(size: 12, weight: weight, design: .default)
    }

    static func small(_ weight: Font.Weight = .regular) -> Font {
        .system(size: 10, weight: weight, design: .default)
    }
}

// MARK: - Spacing

enum AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let xxxl: CGFloat = 32
}

// MARK: - Corner Radius

enum AppCornerRadius {
    static let small: CGFloat = 4
    static let medium: CGFloat = 8
    static let large: CGFloat = 12
    static let extraLarge: CGFloat = 16
    static let pill: CGFloat = 24
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a: UInt64
        let r: UInt64
        let g: UInt64
        let b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - UIColor Extension for UIKit

extension UIColor {
    static let appPrimaryBlue = UIColor(red: 13 / 255, green: 110 / 255, blue: 253 / 255, alpha: 1)
    static let appDarkBackground = UIColor(red: 26 / 255, green: 26 / 255, blue: 46 / 255, alpha: 1)
    static let appTextPrimary = UIColor(red: 29 / 255, green: 29 / 255, blue: 29 / 255, alpha: 1)
    static let appTextSecondary = UIColor(
        red: 103 / 255, green: 110 / 255, blue: 126 / 255, alpha: 1)
    static let appBorderColor = UIColor(red: 228 / 255, green: 231 / 255, blue: 236 / 255, alpha: 1)
    static let appCardBackground = UIColor.white
    static let appLightGray = UIColor(red: 247 / 255, green: 249 / 255, blue: 252 / 255, alpha: 1)
    static let appFlightsRed = UIColor(red: 254 / 255, green: 59 / 255, blue: 48 / 255, alpha: 1)
    static let appRemoveBackground = UIColor(
        red: 251 / 255, green: 234 / 255, blue: 233 / 255, alpha: 1)
    static let appRemoveText = UIColor(red: 158 / 255, green: 10 / 255, blue: 5 / 255, alpha: 1)
}
