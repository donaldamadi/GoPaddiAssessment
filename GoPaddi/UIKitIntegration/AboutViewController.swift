//
//  AboutViewController.swift
//  GoPaddi
//
//  Backing view controller for the About screen, loaded from Storyboard.
//

import SwiftUI
import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!

    var onDismiss: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        // App Name
        appNameLabel.text = "GoPaddi"
        appNameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        appNameLabel.textColor = .appTextPrimary

        // Version
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        {
            versionLabel.text = "Version \(version) (\(build))"
        } else {
            versionLabel.text = "Version 1.0.0"
        }
        versionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        versionLabel.textColor = .appTextSecondary

        // Description
        descriptionLabel.text =
            "GoPaddi is your ultimate travel companion. Plan, organize, and experience your dream trips with ease.\n\nBuilt with Swift, SwiftUI, and UIKit."
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.textColor = .appTextPrimary
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center

        // Close Button
        closeButton.setTitle("Close", for: .normal)
        closeButton.backgroundColor = .appPrimaryBlue
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.layer.cornerRadius = 8
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        // Icon styling
        appIconImageView.layer.cornerRadius = 20
        appIconImageView.clipsToBounds = true
        appIconImageView.image = UIImage(named: "Logo") ?? UIImage(named: "AppIcon")
        appIconImageView.backgroundColor = .appPrimaryBlue  // Fallback
    }

    @objc private func closeTapped() {
        onDismiss?()
        dismiss(animated: true)
    }
}

// MARK: - SwiftUI Bridge
struct AboutViewRepresentable: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss

    func makeUIViewController(context: Context) -> AboutViewController {
        let storyboard = UIStoryboard(name: "About", bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? AboutViewController else {
            fatalError("Could not instantiate AboutViewController from Storyboard")
        }
        vc.onDismiss = {
            dismiss()
        }
        return vc
    }

    func updateUIViewController(_ uiViewController: AboutViewController, context: Context) {}
}
