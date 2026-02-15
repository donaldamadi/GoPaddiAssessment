//
//  TripDetailRepresentable.swift
//  GoPaddi
//
//  A container view responsible for hosting the UIKit-based TripDetailViewController within the SwiftUI hierarchy.
//

import SwiftUI

struct TripDetailRepresentable: UIViewControllerRepresentable {
    let trip: Trip
    let onDelete: () -> Void

    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> TripDetailViewController {
        TripDetailViewController(
            trip: trip,
            onDelete: {
                onDelete()
            },
            onBack: {
                dismiss()
            }
        )
    }

    func updateUIViewController(_ uiViewController: TripDetailViewController, context: Context) {
        // No dynamic updates needed
    }
}

#Preview {
    TripDetailRepresentable(trip: .sample) {}
}
