//
//  DatePickerView.swift
//  GoPaddi
//
//  A custom calendar view for selecting start and end dates for a trip.
//

import SwiftUI

struct DatePickerView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var startDate: Date?
    @Binding var endDate: Date?
    @State private var isSelectingStartDate: Bool
    @State private var currentMonth: Date
    @State private var selectedDate: Date?

    let onConfirm: () -> Void

    private let calendar = Calendar.current
    private let dayNames = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]

    init(
        startDate: Binding<Date?>, endDate: Binding<Date?>, isSelectingStart: Bool,
        onConfirm: @escaping () -> Void
    ) {
        self._startDate = startDate
        self._endDate = endDate
        self._isSelectingStartDate = State(initialValue: isSelectingStart)
        self._currentMonth = State(initialValue: Date())
        self.onConfirm = onConfirm

        if isSelectingStart, let existing = startDate.wrappedValue {
            self._selectedDate = State(initialValue: existing)
        } else if !isSelectingStart, let existing = endDate.wrappedValue {
            self._selectedDate = State(initialValue: existing)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()

            ScrollView {
                VStack(spacing: AppSpacing.xxl) {
                    // Current month
                    calendarMonth(for: currentMonth)

                    // Next month
                    if let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) {
                        calendarMonth(for: nextMonth)
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.lg)
            }

            Divider()

            // Bottom date display + confirm button
            bottomSection
        }
        .background(Color.white)
        .navigationBarHidden(true)
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
                    .frame(width: 40, height: 40)
            }
            .accessibilityLabel("Close")

            Spacer()

            Text("Date")
                .font(AppTypography.headline(.semibold))
                .foregroundColor(AppColors.textPrimary)

            Spacer()

            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.sm)
    }

    // MARK: - Calendar Month

    private func calendarMonth(for month: Date) -> some View {
        VStack(spacing: AppSpacing.md) {
            // Month title
            Text(monthTitle(for: month))
                .font(AppTypography.headline(.semibold))
                .foregroundColor(AppColors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .center)

            // Day headers
            HStack(spacing: 0) {
                ForEach(dayNames, id: \.self) { day in
                    Text(day)
                        .font(AppTypography.caption(.medium))
                        .foregroundColor(AppColors.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }

            // Day grid
            let days = daysInMonth(month)
            let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)

            LazyVGrid(columns: columns, spacing: AppSpacing.sm) {
                ForEach(days, id: \.self) { date in
                    if let date = date {
                        dayCell(date: date)
                    } else {
                        Text("")
                            .frame(height: 40)
                    }
                }
            }
        }
    }

    private func dayCell(date: Date) -> some View {
        let isSelected = isDateSelected(date)
        let isToday = calendar.isDateInToday(date)
        let isPast = date < calendar.startOfDay(for: Date())
        let isInRange = isDateInRange(date)

        return Button {
            guard !isPast else { return }
            selectDate(date)
        } label: {
            Text("\(calendar.component(.day, from: date))")
                .font(AppTypography.callout(isSelected ? .bold : .regular))
                .foregroundColor(
                    isPast
                        ? AppColors.textTertiary
                        : isSelected
                            ? .white : isToday ? AppColors.primaryBlue : AppColors.textPrimary
                )
                .frame(width: 40, height: 40)
                .background(
                    Group {
                        if isSelected {
                            Circle()
                                .fill(AppColors.primaryBlue)
                        } else if isInRange {
                            Circle()
                                .fill(AppColors.primaryBlue.opacity(0.1))
                        }
                    }
                )
        }
        .disabled(isPast)
        .accessibilityLabel(AppDateFormatter.fullDate.string(from: date))
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    // MARK: - Bottom Section

    private var bottomSection: some View {
        VStack(spacing: AppSpacing.md) {
            HStack(spacing: AppSpacing.lg) {
                // Start Date
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("Start Date")
                        .font(AppTypography.caption())
                        .foregroundColor(AppColors.textSecondary)

                    HStack {
                        Text(
                            startDate != nil
                                ? AppDateFormatter.shortDate.string(from: startDate!)
                                : "Select date"
                        )
                        .font(AppTypography.callout(.medium))
                        .foregroundColor(
                            startDate != nil ? AppColors.textPrimary : AppColors.textTertiary)

                        Spacer()

                        Image(systemName: "calendar")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.textTertiary)
                    }
                    .padding(AppSpacing.sm)
                    .roundedBorder(
                        color: isSelectingStartDate ? AppColors.primaryBlue : AppColors.borderColor)
                }
                .onTapGesture { isSelectingStartDate = true }

                // End Date
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("End Date")
                        .font(AppTypography.caption())
                        .foregroundColor(AppColors.textSecondary)

                    HStack {
                        Text(
                            endDate != nil
                                ? AppDateFormatter.shortDate.string(from: endDate!) : "Select date"
                        )
                        .font(AppTypography.callout(.medium))
                        .foregroundColor(
                            endDate != nil ? AppColors.textPrimary : AppColors.textTertiary)

                        Spacer()

                        Image(systemName: "calendar")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.textTertiary)
                    }
                    .padding(AppSpacing.sm)
                    .roundedBorder(
                        color: !isSelectingStartDate ? AppColors.primaryBlue : AppColors.borderColor
                    )
                }
                .onTapGesture { isSelectingStartDate = false }
            }

            // Choose Date button
            Button {
                onConfirm()
                dismiss()
            } label: {
                Text("Choose Date")
                    .font(AppTypography.body(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(
                        (startDate != nil && endDate != nil)
                            ? AppColors.primaryBlue
                            : AppColors.primaryBlue.opacity(0.5)
                    )
                    .cornerRadius(AppCornerRadius.small)
            }
            .disabled(startDate == nil || endDate == nil)
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.lg)
    }

    // MARK: - Helpers

    private func monthTitle(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    private func daysInMonth(_ date: Date) -> [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: date),
            let firstDay = calendar.date(
                from: calendar.dateComponents([.year, .month], from: date))
        else {
            return []
        }

        // Monday = 1 in our layout (ISO weekday), adjust the offset
        var weekday = calendar.component(.weekday, from: firstDay)
        // Convert Sunday=1..Saturday=7 to Monday=0..Sunday=6
        weekday = (weekday + 5) % 7

        var days: [Date?] = Array(repeating: nil, count: weekday)

        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                days.append(date)
            }
        }

        // Pad remaining cells
        while days.count % 7 != 0 {
            days.append(nil)
        }

        return days
    }

    private func isDateSelected(_ date: Date) -> Bool {
        if let start = startDate, calendar.isDate(date, inSameDayAs: start) { return true }
        if let end = endDate, calendar.isDate(date, inSameDayAs: end) { return true }
        return false
    }

    private func isDateInRange(_ date: Date) -> Bool {
        guard let start = startDate, let end = endDate else { return false }
        return date > start && date < end
    }

    private func selectDate(_ date: Date) {
        if isSelectingStartDate {
            startDate = date
            // If end date is before new start date, reset it
            if let end = endDate, end < date {
                endDate = nil
            }
            isSelectingStartDate = false
        } else {
            // Validate end date >= start date
            if let start = startDate, date < start {
                startDate = date
                endDate = nil
            } else {
                endDate = date
            }
        }
    }
}

#Preview {
    DatePickerView(
        startDate: .constant(nil),
        endDate: .constant(nil),
        isSelectingStart: true
    ) {}
}
