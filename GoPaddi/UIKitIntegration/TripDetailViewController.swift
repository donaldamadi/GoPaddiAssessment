//
//  TripDetailViewController.swift
//  GoPaddi
//
//  A comprehensive UIKit view controller displaying detailed trip information, including itineraries for flights, hotels, and activities.
//

import UIKit

final class TripDetailViewController: UIViewController {

    // MARK: - Properties

    private let trip: Trip
    private let onDelete: () -> Void
    private let onBack: () -> Void

    // MARK: - UI Elements

    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = true
        sv.alwaysBounceVertical = true
        return sv
    }()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init

    init(trip: Trip, onDelete: @escaping () -> Void, onBack: @escaping () -> Void) {
        self.trip = trip
        self.onDelete = onDelete
        self.onBack = onBack
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appLightGray
        setupNavBar()
        setupScrollView()
        buildContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Custom Nav Bar

    private func setupNavBar() {
        let navBar = UIView()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.backgroundColor = .white

        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .appTextPrimary
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.accessibilityLabel = "Back"

        let titleLabel = UILabel()
        titleLabel.text = "Plan a Trip"
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .appTextPrimary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        navBar.addSubview(backButton)
        navBar.addSubview(titleLabel)
        view.addSubview(navBar)

        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 48),

            backButton.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),

            titleLabel.centerXAnchor.constraint(equalTo: navBar.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
        ])
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }

    // MARK: - Build Content

    private func buildContent() {
        // 1. Banner image
        addBannerImage()
        // 2. Date range
        addDateRange()
        // 3. Trip title + location
        addTripInfo()
        // 4. Action buttons row
        addActionButtons()
        addSpacer(24)
        // 5. Itinerary quick-add sections (Activities / Hotels / Flights)
        addItineraryQuickSection(
            title: "Activities", color: .appPrimaryBlue,
            description: "Build, personalize, and optimize your itineraries with our trip planner.",
            buttonTitle: "Add Activities")
        addSpacer(16)
        addItineraryQuickSection(
            title: "Hotels", color: .appPrimaryBlue,
            description: "Build, personalize, and optimize your itineraries with our trip planner.",
            buttonTitle: "Add Hotels")
        addSpacer(16)
        addItineraryQuickSection(
            title: "Flights", color: .appPrimaryBlue,
            description: "Build, personalize, and optimize your itineraries with our trip planner.",
            buttonTitle: "Add Flights")
        addSpacer(32)
        // 6. Trip itineraries header
        addSectionHeader(
            title: "Trip itineraries", subtitle: "Your trip itineraries are placed here")
        addSpacer(16)
        // 7. Flight itinerary card (populated demo)
        addFlightItineraryCard()
        addSpacer(16)
        // 8. Hotel itinerary card (populated demo)
        addHotelItineraryCard()
        addSpacer(16)
        // 9. Activity itinerary card (populated demo)
        addActivityItineraryCard()
        addSpacer(48)
    }

    // MARK: - 1. Banner Image

    private func addBannerImage() {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "trip_banner")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(
            red: 200 / 255, green: 230 / 255, blue: 255 / 255, alpha: 1)

        container.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 220),
        ])
        imageView.layer.cornerRadius = 8
        contentStack.addArrangedSubview(container)
    }

    // MARK: - 2. Date Range

    private func addDateRange() {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.spacing = 6
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false

        let calIcon = UIImageView(image: UIImage(systemName: "calendar"))
        calIcon.tintColor = .appTextSecondary
        calIcon.translatesAutoresizingMaskIntoConstraints = false
        calIcon.widthAnchor.constraint(equalToConstant: 14).isActive = true
        calIcon.heightAnchor.constraint(equalToConstant: 14).isActive = true

        let dateLabel = UILabel()
        dateLabel.text = trip.dateRangeDisplay
        dateLabel.font = .systemFont(ofSize: 14, weight: .regular)
        dateLabel.textColor = .appTextSecondary

        hStack.addArrangedSubview(calIcon)
        hStack.addArrangedSubview(dateLabel)
        hStack.addArrangedSubview(UIView())  // spacer

        container.addSubview(hStack)
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            hStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            hStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4),
        ])
        contentStack.addArrangedSubview(container)
    }

    // MARK: - 3. Trip Info

    private func addTripInfo() {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 4
        vStack.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = trip.name
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .appTextPrimary
        titleLabel.accessibilityTraits = .header

        let subtitleLabel = UILabel()
        subtitleLabel.text = trip.locationDisplay
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = .appTextSecondary

        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(subtitleLabel)

        container.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 4),
            vStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            vStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
        ])
        contentStack.addArrangedSubview(container)
    }

    // MARK: - 4. Action Buttons

    private func addActionButtons() {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.spacing = 10
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false

        let collabButton = makePillButton(title: "Trip Collaboration", icon: "person.2.fill")
        let shareButton = makePillButton(title: "Share Trip", icon: "square.and.arrow.up")

        // More button (3-dot)
        let moreButton = UIButton(type: .system)
        moreButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        moreButton.tintColor = .appTextPrimary
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        moreButton.accessibilityLabel = "More options"

        let menu = UIMenu(children: [
            UIAction(
                title: "Delete Trip", image: UIImage(systemName: "trash"), attributes: .destructive
            ) { [weak self] _ in
                self?.showDeleteAlert()
            }
        ])
        moreButton.menu = menu
        moreButton.showsMenuAsPrimaryAction = true

        hStack.addArrangedSubview(collabButton)
        hStack.addArrangedSubview(shareButton)
        hStack.addArrangedSubview(UIView())  // flexible spacer
        hStack.addArrangedSubview(moreButton)

        container.addSubview(hStack)
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            hStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            hStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
        ])
        contentStack.addArrangedSubview(container)
    }

    // MARK: - 5. Itinerary Quick-Add Section (Colored card)

    private func addItineraryQuickSection(
        title: String, color: UIColor, description: String, buttonTitle: String
    ) {
        let outer = UIView()
        outer.translatesAutoresizingMaskIntoConstraints = false

        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.layer.cornerRadius = 8
        card.clipsToBounds = true
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor.appBorderColor.cgColor

        // -- Header bar --
        let header = UIView()
        header.backgroundColor = color
        header.translatesAutoresizingMaskIntoConstraints = false

        let headerLabel = UILabel()
        headerLabel.text = title
        headerLabel.font = .systemFont(ofSize: 16, weight: .bold)
        headerLabel.textColor = .white
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(headerLabel)

        // -- Body --
        let body = UIView()
        body.backgroundColor = .white
        body.translatesAutoresizingMaskIntoConstraints = false

        let descLabel = UILabel()
        descLabel.text = description
        descLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descLabel.textColor = .appTextSecondary
        descLabel.numberOfLines = 0
        descLabel.translatesAutoresizingMaskIntoConstraints = false

        let addBtn = makeBlueButton(title: buttonTitle)

        body.addSubview(descLabel)
        body.addSubview(addBtn)

        card.addSubview(header)
        card.addSubview(body)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: card.topAnchor),
            header.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 44),
            headerLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            headerLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor),

            body.topAnchor.constraint(equalTo: header.bottomAnchor),
            body.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            body.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            body.bottomAnchor.constraint(equalTo: card.bottomAnchor),

            descLabel.topAnchor.constraint(equalTo: body.topAnchor, constant: 16),
            descLabel.leadingAnchor.constraint(equalTo: body.leadingAnchor, constant: 16),
            descLabel.trailingAnchor.constraint(equalTo: body.trailingAnchor, constant: -16),

            addBtn.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 16),
            addBtn.leadingAnchor.constraint(equalTo: body.leadingAnchor, constant: 16),
            addBtn.trailingAnchor.constraint(equalTo: body.trailingAnchor, constant: -16),
            addBtn.heightAnchor.constraint(equalToConstant: 44),
            addBtn.bottomAnchor.constraint(equalTo: body.bottomAnchor, constant: -16),
        ])

        outer.addSubview(card)
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: outer.topAnchor),
            card.leadingAnchor.constraint(equalTo: outer.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: outer.trailingAnchor, constant: -16),
            card.bottomAnchor.constraint(equalTo: outer.bottomAnchor),
        ])
        contentStack.addArrangedSubview(outer)
    }

    // MARK: - 6. Section Header

    private func addSectionHeader(title: String, subtitle: String) {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 4
        vStack.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .appTextPrimary
        titleLabel.accessibilityTraits = .header

        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        subtitleLabel.textColor = .appTextSecondary

        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(subtitleLabel)

        container.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: container.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            vStack.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])
        contentStack.addArrangedSubview(container)
    }

    // MARK: - 7. Flight Itinerary Card (Populated)

    private func addFlightItineraryCard() {
        let outer = UIView()
        outer.translatesAutoresizingMaskIntoConstraints = false

        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 8
        card.layer.borderWidth = 2
        card.layer.borderColor = UIColor.appPrimaryBlue.cgColor
        card.clipsToBounds = true

        // -- Header --
        let header = makeItineraryHeader(icon: "airplane", title: "Flights")

        // -- Content --
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false

        // Airline name
        let airlineLabel = makeBoldLabel("American Airlines", size: 16)
        let flightNumLabel = makeSecondaryLabel("AA-829", size: 13)

        // Time row: departure — duration line — arrival
        let timeRow = makeFlightTimeRow()

        // Detail links
        let linksRow = makeLinksRow(links: ["Flight details", "Price details", "Edit details"])

        // Price
        let priceLabel = makeBoldLabel("₦ 123,450.00", size: 16)

        // Remove button
        let removeBtn = makeRemoveButton()

        content.addSubview(airlineLabel)
        content.addSubview(flightNumLabel)
        content.addSubview(timeRow)
        content.addSubview(linksRow)
        content.addSubview(priceLabel)
        content.addSubview(removeBtn)

        NSLayoutConstraint.activate([
            airlineLabel.topAnchor.constraint(equalTo: content.topAnchor, constant: 16),
            airlineLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),

            flightNumLabel.topAnchor.constraint(equalTo: airlineLabel.bottomAnchor, constant: 2),
            flightNumLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),

            timeRow.topAnchor.constraint(equalTo: flightNumLabel.bottomAnchor, constant: 16),
            timeRow.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),
            timeRow.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -16),

            linksRow.topAnchor.constraint(equalTo: timeRow.bottomAnchor, constant: 16),
            linksRow.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),
            linksRow.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -16),

            priceLabel.topAnchor.constraint(equalTo: linksRow.bottomAnchor, constant: 12),
            priceLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),

            removeBtn.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 12),
            removeBtn.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            removeBtn.trailingAnchor.constraint(equalTo: content.trailingAnchor),
            removeBtn.heightAnchor.constraint(equalToConstant: 44),
            removeBtn.bottomAnchor.constraint(equalTo: content.bottomAnchor),
        ])

        card.addSubview(header)
        card.addSubview(content)
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: card.topAnchor),
            header.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 44),

            content.topAnchor.constraint(equalTo: header.bottomAnchor),
            content.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            content.bottomAnchor.constraint(equalTo: card.bottomAnchor),
        ])

        outer.addSubview(card)
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: outer.topAnchor),
            card.leadingAnchor.constraint(equalTo: outer.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: outer.trailingAnchor, constant: -16),
            card.bottomAnchor.constraint(equalTo: outer.bottomAnchor),
        ])
        contentStack.addArrangedSubview(outer)
    }

    // MARK: - 8. Hotel Itinerary Card (Populated)

    private func addHotelItineraryCard() {
        let outer = UIView()
        outer.translatesAutoresizingMaskIntoConstraints = false

        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 8
        card.layer.borderWidth = 2
        card.layer.borderColor = UIColor.appPrimaryBlue.cgColor
        card.clipsToBounds = true

        // -- Header --
        let header = makeItineraryHeader(icon: "building.2.fill", title: "Hotels")

        // -- Image --
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "hotel_hero")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(
            red: 200 / 255, green: 230 / 255, blue: 255 / 255, alpha: 1)
        imageView.layer.cornerRadius = 8

        // Image carousel arrows
        let arrowStack = makeCarouselArrows()

        // -- Content --
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false

        let hotelName = makeBoldLabel("Riviera Resort, Lekki", size: 16)
        let addressLabel = makeSecondaryLabel(
            "18, Kenneth Agbakuru Street, Off Access Bank\nAdmiralty Way, Lekki Phase1", size: 13)
        addressLabel.numberOfLines = 0

        // Location + rating row
        let metaRow = UIStackView()
        metaRow.axis = .horizontal
        metaRow.spacing = 12
        metaRow.alignment = .center
        metaRow.translatesAutoresizingMaskIntoConstraints = false

        let mapLink = makeBlueTextLabel("Show in map", icon: "location.fill")
        let starLabel = makeIconLabel(
            icon: "star.fill", text: "8.5 (436)", iconColor: .systemYellow)
        let roomLabel = makeIconLabel(
            icon: "bed.double.fill", text: "King size room", iconColor: .appTextSecondary)

        metaRow.addArrangedSubview(mapLink)
        metaRow.addArrangedSubview(starLabel)
        metaRow.addArrangedSubview(roomLabel)
        metaRow.addArrangedSubview(UIView())

        // Dates row
        let datesRow = UIStackView()
        datesRow.axis = .horizontal
        datesRow.spacing = 16
        datesRow.alignment = .center
        datesRow.translatesAutoresizingMaskIntoConstraints = false

        let inLabel = makeIconLabel(
            icon: "calendar", text: "In: 20-04-2024", iconColor: .appTextSecondary)
        let outLabel = makeIconLabel(
            icon: "calendar", text: "Out: 29-04-2024", iconColor: .appTextSecondary)
        datesRow.addArrangedSubview(inLabel)
        datesRow.addArrangedSubview(outLabel)
        datesRow.addArrangedSubview(UIView())

        let linksRow = makeLinksRow(links: ["Hotel details", "Price details", "Edit details"])
        let priceLabel = makeBoldLabel("₦ 123,450.00", size: 16)
        let removeBtn = makeRemoveButton()

        content.addSubview(hotelName)
        content.addSubview(addressLabel)
        content.addSubview(metaRow)
        content.addSubview(datesRow)
        content.addSubview(linksRow)
        content.addSubview(priceLabel)
        content.addSubview(removeBtn)

        NSLayoutConstraint.activate([
            hotelName.topAnchor.constraint(equalTo: content.topAnchor, constant: 12),
            hotelName.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),
            hotelName.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -16),

            addressLabel.topAnchor.constraint(equalTo: hotelName.bottomAnchor, constant: 4),
            addressLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),
            addressLabel.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -16),

            metaRow.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10),
            metaRow.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),
            metaRow.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -16),

            datesRow.topAnchor.constraint(equalTo: metaRow.bottomAnchor, constant: 10),
            datesRow.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),
            datesRow.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -16),

            linksRow.topAnchor.constraint(equalTo: datesRow.bottomAnchor, constant: 12),
            linksRow.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),
            linksRow.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -16),

            priceLabel.topAnchor.constraint(equalTo: linksRow.bottomAnchor, constant: 12),
            priceLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),

            removeBtn.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 12),
            removeBtn.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            removeBtn.trailingAnchor.constraint(equalTo: content.trailingAnchor),
            removeBtn.heightAnchor.constraint(equalToConstant: 44),
            removeBtn.bottomAnchor.constraint(equalTo: content.bottomAnchor),
        ])

        card.addSubview(header)
        card.addSubview(imageView)
        card.addSubview(arrowStack)
        card.addSubview(content)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: card.topAnchor),
            header.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 44),

            imageView.topAnchor.constraint(equalTo: header.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 180),

            arrowStack.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: 40),
            arrowStack.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),

            content.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            content.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            content.bottomAnchor.constraint(equalTo: card.bottomAnchor),
        ])

        outer.addSubview(card)
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: outer.topAnchor),
            card.leadingAnchor.constraint(equalTo: outer.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: outer.trailingAnchor, constant: -16),
            card.bottomAnchor.constraint(equalTo: outer.bottomAnchor),
        ])
        contentStack.addArrangedSubview(outer)
    }

    // MARK: - 9. Activity Itinerary Card (Populated)

    private func addActivityItineraryCard() {
        let outer = UIView()
        outer.translatesAutoresizingMaskIntoConstraints = false

        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 8
        card.layer.borderWidth = 2
        card.layer.borderColor = UIColor.appPrimaryBlue.cgColor
        card.clipsToBounds = true

        // -- Header --
        let header = makeItineraryHeader(icon: "figure.walk", title: "Activities")

        // -- Image --
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "trip_placeholder")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(
            red: 200 / 255, green: 230 / 255, blue: 255 / 255, alpha: 1)

        let arrowStack = makeCarouselArrows()

        // -- Content --
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false

        let activityName = makeBoldLabel("The Museum of Modern Art", size: 16)
        let descLabel = makeSecondaryLabel(
            "Works from Van Gogh to Warhol & beyond plus a\nsculpture garden, 2 cafes & The modern restaurant",
            size: 13)
        descLabel.numberOfLines = 0

        // Location + rating row
        let metaRow = UIStackView()
        metaRow.axis = .horizontal
        metaRow.spacing = 12
        metaRow.alignment = .center
        metaRow.translatesAutoresizingMaskIntoConstraints = false

        let locLabel = makeBlueTextLabel("Melbourne, Australia", icon: "location.fill")
        let starLabel = makeIconLabel(
            icon: "star.fill", text: "8.5 (436)", iconColor: .systemYellow)
        let durLabel = makeIconLabel(
            icon: "clock.fill", text: "1 hour", iconColor: .appTextSecondary)

        metaRow.addArrangedSubview(locLabel)
        metaRow.addArrangedSubview(starLabel)
        metaRow.addArrangedSubview(durLabel)
        metaRow.addArrangedSubview(UIView())

        // Change time link
        let changeTimeLink = makeBlueTextLabel("Change time", icon: nil)

        let timeLabel = makeSecondaryLabel("10:30 AM on Mar 19", size: 13)

        // Day badge
        let dayBadge = makeDayBadge(text: "Day 1 (Activity 1)")

        // Time + day row
        let timeRow = UIStackView()
        timeRow.axis = .horizontal
        timeRow.spacing = 8
        timeRow.alignment = .center
        timeRow.translatesAutoresizingMaskIntoConstraints = false
        timeRow.addArrangedSubview(timeLabel)
        timeRow.addArrangedSubview(UIView())
        timeRow.addArrangedSubview(dayBadge)

        let linksRow = makeLinksRow(links: ["Hotel details", "Price details", "Edit details"])
        let priceLabel = makeBoldLabel("₦ 123,450.00", size: 16)
        let removeBtn = makeRemoveButton()

        content.addSubview(activityName)
        content.addSubview(descLabel)
        content.addSubview(metaRow)
        content.addSubview(changeTimeLink)
        content.addSubview(timeRow)
        content.addSubview(linksRow)
        content.addSubview(priceLabel)
        content.addSubview(removeBtn)

        NSLayoutConstraint.activate([
            activityName.topAnchor.constraint(equalTo: content.topAnchor, constant: 12),
            activityName.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),
            activityName.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -16),

            descLabel.topAnchor.constraint(equalTo: activityName.bottomAnchor, constant: 4),
            descLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),
            descLabel.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -16),

            metaRow.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 10),
            metaRow.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),
            metaRow.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -16),

            changeTimeLink.topAnchor.constraint(equalTo: metaRow.bottomAnchor, constant: 10),
            changeTimeLink.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),

            timeRow.topAnchor.constraint(equalTo: changeTimeLink.bottomAnchor, constant: 4),
            timeRow.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),
            timeRow.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -16),

            linksRow.topAnchor.constraint(equalTo: timeRow.bottomAnchor, constant: 12),
            linksRow.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),
            linksRow.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -16),

            priceLabel.topAnchor.constraint(equalTo: linksRow.bottomAnchor, constant: 12),
            priceLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),

            removeBtn.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 12),
            removeBtn.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            removeBtn.trailingAnchor.constraint(equalTo: content.trailingAnchor),
            removeBtn.heightAnchor.constraint(equalToConstant: 44),
            removeBtn.bottomAnchor.constraint(equalTo: content.bottomAnchor),
        ])

        card.addSubview(header)
        card.addSubview(imageView)
        card.addSubview(arrowStack)
        card.addSubview(content)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: card.topAnchor),
            header.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 44),

            imageView.topAnchor.constraint(equalTo: header.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 180),

            arrowStack.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: 40),
            arrowStack.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),

            content.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            content.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            content.bottomAnchor.constraint(equalTo: card.bottomAnchor),
        ])

        outer.addSubview(card)
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: outer.topAnchor),
            card.leadingAnchor.constraint(equalTo: outer.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: outer.trailingAnchor, constant: -16),
            card.bottomAnchor.constraint(equalTo: outer.bottomAnchor),
        ])
        contentStack.addArrangedSubview(outer)
    }

    // ====================================================================
    // MARK: - Reusable UI Factory Methods
    // ====================================================================

    private func addSpacer(_ height: CGFloat) {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.heightAnchor.constraint(equalToConstant: height).isActive = true
        contentStack.addArrangedSubview(spacer)
    }

    // MARK: Itinerary Card Header (blue bar with icon)

    private func makeItineraryHeader(icon: String, title: String) -> UIView {
        let header = UIView()
        header.backgroundColor = .appPrimaryBlue
        header.translatesAutoresizingMaskIntoConstraints = false

        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.spacing = 8
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .white
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white

        hStack.addArrangedSubview(iconView)
        hStack.addArrangedSubview(label)
        hStack.addArrangedSubview(UIView())

        header.addSubview(hStack)
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -16),
            hStack.centerYAnchor.constraint(equalTo: header.centerYAnchor),
        ])
        return header
    }

    // MARK: Pill-style outline button (for Trip Collaboration / Share Trip)

    private func makePillButton(title: String, icon: String) -> UIButton {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.title = title
        config.image = UIImage(systemName: icon)?.withRenderingMode(.alwaysTemplate)
        config.imagePadding = 6
        config.baseForegroundColor = .appPrimaryBlue
        config.background.strokeColor = .appBorderColor
        config.background.strokeWidth = 1
        config.background.cornerRadius = 20
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        let font = UIFont.systemFont(ofSize: 13, weight: .medium)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { c in
            var c = c
            c.font = font
            return c
        }
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = title
        return button
    }

    // MARK: Blue "Add ___" Button

    private func makeBlueButton(title: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .appPrimaryBlue
        btn.layer.cornerRadius = 4
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.accessibilityLabel = title
        return btn
    }

    // MARK: Flight Time Row (08:35 ——— 1h 45m ——— 09:55)

    private func makeFlightTimeRow() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        // Departure
        let depStack = UIStackView()
        depStack.axis = .vertical
        depStack.alignment = .center
        depStack.spacing = 2
        depStack.translatesAutoresizingMaskIntoConstraints = false

        let depTime = makeBoldLabel("08:35", size: 18)
        let depDate = makeSecondaryLabel("Sun, 20 Aug", size: 11)
        let depCode = makeBoldLabel("LOS", size: 12)
        depStack.addArrangedSubview(depTime)
        depStack.addArrangedSubview(depDate)
        depStack.addArrangedSubview(depCode)

        // Middle
        let midStack = UIStackView()
        midStack.axis = .vertical
        midStack.alignment = .center
        midStack.spacing = 2
        midStack.translatesAutoresizingMaskIntoConstraints = false

        let planeIcon = UIImageView(image: UIImage(systemName: "airplane"))
        planeIcon.tintColor = .appPrimaryBlue
        planeIcon.translatesAutoresizingMaskIntoConstraints = false
        planeIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        planeIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true

        let durLabel = makeSecondaryLabel("1h 45m", size: 12)

        // Progress bar
        let progressBar = UIView()
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.backgroundColor = .appPrimaryBlue
        progressBar.layer.cornerRadius = 2
        progressBar.heightAnchor.constraint(equalToConstant: 4).isActive = true
        progressBar.widthAnchor.constraint(equalToConstant: 80).isActive = true

        let directLabel = makeSecondaryLabel("Direct", size: 11)

        midStack.addArrangedSubview(planeIcon)
        midStack.addArrangedSubview(durLabel)
        midStack.addArrangedSubview(progressBar)
        midStack.addArrangedSubview(directLabel)

        // Arrival
        let arrStack = UIStackView()
        arrStack.axis = .vertical
        arrStack.alignment = .center
        arrStack.spacing = 2
        arrStack.translatesAutoresizingMaskIntoConstraints = false

        let arrIcon = UIImageView(image: UIImage(systemName: "airplane.arrival"))
        arrIcon.tintColor = .appTextSecondary
        arrIcon.translatesAutoresizingMaskIntoConstraints = false
        arrIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        arrIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true

        let arrTime = makeBoldLabel("09:55", size: 18)
        let arrDate = makeSecondaryLabel("Sun, 20 Aug", size: 11)
        let arrCode = makeBoldLabel("SIN", size: 12)
        arrStack.addArrangedSubview(arrTime)
        arrStack.addArrangedSubview(arrDate)
        arrStack.addArrangedSubview(arrCode)

        // Main horizontal layout
        let hStack = UIStackView(arrangedSubviews: [depStack, midStack, arrStack])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .equalSpacing
        hStack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(hStack)
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: container.topAnchor),
            hStack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])
        return container
    }

    // MARK: Detail links row ("Flight details · Price details · Edit details")

    private func makeLinksRow(links: [String]) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        for link in links {
            let btn = UIButton(type: .system)
            btn.setTitle(link, for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
            btn.setTitleColor(.appPrimaryBlue, for: .normal)
            btn.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview(btn)
        }
        stack.addArrangedSubview(UIView())
        return stack
    }

    // MARK: Remove button (pink bar)

    private func makeRemoveButton() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .appRemoveBackground

        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.spacing = 6
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = "Remove"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .appRemoveText

        let icon = UIImageView(image: UIImage(systemName: "xmark"))
        icon.tintColor = .appRemoveText
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: 12).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 12).isActive = true

        hStack.addArrangedSubview(UIView())
        hStack.addArrangedSubview(label)
        hStack.addArrangedSubview(icon)
        hStack.addArrangedSubview(UIView())

        container.addSubview(hStack)
        NSLayoutConstraint.activate([
            hStack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            hStack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])
        return container
    }

    // MARK: Carousel arrows (< >)

    private func makeCarouselArrows() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        for iconName in ["chevron.left", "chevron.right"] {
            let btn = UIButton(type: .system)
            btn.setImage(UIImage(systemName: iconName), for: .normal)
            btn.tintColor = .appTextPrimary
            btn.backgroundColor = UIColor.white.withAlphaComponent(0.85)
            btn.layer.cornerRadius = 16
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.widthAnchor.constraint(equalToConstant: 32).isActive = true
            btn.heightAnchor.constraint(equalToConstant: 32).isActive = true
            stack.addArrangedSubview(btn)
        }
        return stack
    }

    // MARK: Day badge

    private func makeDayBadge(text: String) -> UIView {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .appTextPrimary
        label.translatesAutoresizingMaskIntoConstraints = false

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .appLightGray
        container.layer.cornerRadius = 4
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.appBorderColor.cgColor

        container.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
        ])
        return container
    }

    // MARK: Label helpers

    private func makeBoldLabel(_ text: String, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: size, weight: .bold)
        label.textColor = .appTextPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func makeSecondaryLabel(_ text: String, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: size, weight: .regular)
        label.textColor = .appTextSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func makeBlueTextLabel(_ text: String, icon: String?) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        if let icon = icon {
            let iconView = UIImageView(image: UIImage(systemName: icon))
            iconView.tintColor = .appPrimaryBlue
            iconView.translatesAutoresizingMaskIntoConstraints = false
            iconView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            iconView.heightAnchor.constraint(equalToConstant: 12).isActive = true
            stack.addArrangedSubview(iconView)
        }
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .appPrimaryBlue
        stack.addArrangedSubview(label)
        return stack
    }

    private func makeIconLabel(icon: String, text: String, iconColor: UIColor) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = iconColor
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        stack.addArrangedSubview(iconView)

        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .appTextSecondary
        stack.addArrangedSubview(label)
        return stack
    }

    // MARK: - Actions

    @objc private func backTapped() {
        onBack()
    }

    private func showDeleteAlert() {
        let alert = UIAlertController(
            title: "Delete Trip",
            message:
                "Are you sure you want to delete \"\(trip.name)\"? This action cannot be undone.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(
            UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                self?.onDelete()
            })
        present(alert, animated: true)
    }
}
