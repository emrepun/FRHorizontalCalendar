//
//  FRHorizontalCalendarViewModel.swift
//
//
//  Created by Emre Havan on 08.04.24.
//

import SwiftUI

public final class FRHorizontalCalendarViewModel: ObservableObject {
    
    @Published var allDays: [FRCalendarDayModel] = []
    @Published var selectedDayText: String = ""
    @Published var mostProminentMonthText: String = ""

    public weak var delegate: FRCalendarObserving? {
        didSet {
            guard allDays.indices.contains(selectedDayIndex) else {
                return
            }
            delegate?.didAutoSelectInitialDay(allDays[selectedDayIndex].date)
        }
    }

    private var selectedDayIndex: Int
    private var visibleDays: Set<FRCalendarDayModel> = []
    private var didSetHeightOnFirstLoad = false
    
    /// A dictionary to keep the index of the array for given Dates
    /// It is used to  update content available status for days performantly
    private var allDaysDictionary: [Date: Int] = [:]

    private let beginningOfToday: Date = {
        Calendar.current.startOfDay(for: .now)
    }()

    private let dayNameFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter
    }()
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter
    }()

    private let selectedDayDateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        return dateFormatter
    }()

    private let mostProminentMonthFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter
    }()

    public init(startDate: Date) {
        var allDays = Date.dates(from: startDate, to: .now).map {
            FRCalendarDayModel(date: $0, isSelected: false, hasContentAvailable: false, isAvailable: true)
        }
        guard allDays.count > 7 else {
            assertionFailure("The calendar must be initialised with a start date that is earlier than 7 days ago")
            self.allDays = []
            self.selectedDayIndex = 0
            self.selectedDayText = ""
            return
        }
        // select today
        allDays[allDays.count - 1].isSelected = true
        self.allDays = allDays
        self.selectedDayIndex = allDays.count - 1
        self.selectedDayText = selectedDayDateFormatter.string(from: allDays.last!.date)

        insertAdditionalDaysToPositionFirstDayOfTheWeek()
        populateLookupDictionaryForAllDays()
        setInitialMonthText()
        setProminentMonthText()
    }


    func setHeight(_ height: CGFloat) {
        guard didSetHeightOnFirstLoad == false else {
            return
        }
        didSetHeightOnFirstLoad = true
        DispatchQueue.main.async {
            self.delegate?.didSetInitialHeight(height)
        }
    }

    func dayStringFor(_ date: Date) -> String {
        return dayNameFormatter.string(from: date)
    }

    func dateStringFor(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }

    func dayStringForegroundColorFor(_ day: FRCalendarDayModel) -> Color {
        if day.isAvailable == false {
            return Color(uiColor: .systemGray5)
        } else if day.isSelected {
            return .white
        } else if day.date == beginningOfToday {
            return .blue
        } else {
            return Color(uiColor: .systemGray)
        }
    }

    func dateStringForegroundColorFor(_ day: FRCalendarDayModel) -> Color {
        if day.isAvailable == false {
            return Color(uiColor: .systemGray3)
        } else if day.isSelected {
            return .white
        } else if day.date == beginningOfToday {
            return .blue
        } else {
            return Color(uiColor: .label)
        }
    }

    func backgroundColorFor(_ day: FRCalendarDayModel) -> Color {
        if day.isSelected {
            return Color.blue
        } else if day.hasContentAvailable {
            return Color.blue.opacity(0.25)
        } else {
            return Color.clear
        }
    }

    func dayAppeared(_ day: FRCalendarDayModel) {
        visibleDays.insert(day)
        setProminentMonthText()
        delegate?.dayAppeared(forDate: day.date)
    }

    func dayDisappeared(_ day: FRCalendarDayModel) {
        visibleDays.remove(day)
        setProminentMonthText()
    }

    func didTapOnDayAt(_ index: Int) {
        guard allDays[index].isAvailable else {
            return
        }
        let lastElementIndex = allDays.count - 1
        // The animation is broken if the last day was selected
        // or if we are about to select the last day
        selectedDayText = selectedDayDateFormatter.string(from: allDays[index].date)
        if selectedDayIndex == lastElementIndex || index == lastElementIndex {
            updateSelection(index)
        } else {
            withAnimation {
                updateSelection(index)
            }
        }
        delegate?.didTapDay(onDate: allDays[index].date)
    }

    // MARK: - Private
    private func updateSelection(_ index: Int) {
        allDays[selectedDayIndex].isSelected.toggle()
        allDays[index].isSelected.toggle()
        selectedDayIndex = index
    }

    private func insertAdditionalDaysToPositionFirstDayOfTheWeek() {
        // get the seventh day in the allDays
        let seventhLastDay = allDays[allDays.count - 7]
        // If the seventh last day's weekday number is 1, it means its the first day of the week
        // No need to insert additional days.
        guard seventhLastDay.date.weekday != 1 else {
            return
        }
        let numberOfUnavailableDaysToAppend = 7 - seventhLastDay.date.weekday + 1

        for _ in 0..<numberOfUnavailableDaysToAppend {
            guard let lastDay = allDays.last, 
                    let dateToAppend = Calendar.current.date(byAdding: .day, value: 1, to: lastDay.date) else {
                // no point on continuing on for, if for some reason we couldn't get a date for a number,
                // the calendar will be broken. Should never happen though.
                return
            }
            self.allDays.append(.init(date: dateToAppend, isSelected: false, hasContentAvailable: false, isAvailable: false))
        }
    }

    private func populateLookupDictionaryForAllDays() {
        for (index, day) in allDays.enumerated() {
            allDaysDictionary[day.date] = index
        }
    }

    private func setInitialMonthText() {
        var monthNumberForVisibleDays = [Int]()
        for i in 0...6 {
            monthNumberForVisibleDays.append(Calendar.current.component(.month, from: allDays[allDays.count - 1 - i].date))
        }
        updateProminentMonthForGivenMonthsForDays(monthsForDays: monthNumberForVisibleDays)
    }

    private func setProminentMonthText() {
        // When the whole view reappears, the cells become visible one by one
        // and in no particular order, thus, it may cause showing incorrect month
        // for a split second, untill all day's onAppear is triggered.
        // Imagine a scenario, where the following days are showing Mar-Apr
        // 28-29-30-31-01-02-03
        // It should eventually show March as the prominent month
        // But if the april's days appear first, and then march's days,
        // for a split second it will show the incorrect month
        // which causes a flickering bug.
        guard visibleDays.count == 7 else {
            return
        }
        var monthNumberForVisibleDays = [Int]()
        visibleDays.forEach {
            monthNumberForVisibleDays.append(Calendar.current.component(.month, from: $0.date))
        }
        updateProminentMonthForGivenMonthsForDays(monthsForDays: monthNumberForVisibleDays)
    }

    private func updateProminentMonthForGivenMonthsForDays(monthsForDays: [Int]) {
        var dictionaryToCount = [Int: Int]()
        monthsForDays.forEach {
            dictionaryToCount[$0, default: 0] += 1
        }

        var maxCount = 0
        var mostFrequentElement: Int?

        for (element, count) in dictionaryToCount {
            if count > maxCount {
                maxCount = count
                mostFrequentElement = element
            }
        }

        if let mostFrequentElement {
            withAnimation {
                mostProminentMonthText = mostProminentMonthFormatter.monthSymbols[mostFrequentElement - 1]
            }
        }
    }
}

// MARK: - Public API
public extension FRHorizontalCalendarViewModel {
    func setContentAvailableForDaysWithGivenDates(_ dates: [Date]) {
        for date in dates {
            if let matchingIndex = allDaysDictionary[Calendar.current.startOfDay(for: date)] {
                allDays[matchingIndex].hasContentAvailable = true
            }
        }
    }

    func removeContentAvailableForDayWithGivenDate(_ date: Date) {
        let matchingIndex = allDays.firstIndex { model in
            Calendar.current.isDate(model.date, inSameDayAs: date)
        }
        if let matchingIndex {
            allDays[matchingIndex].hasContentAvailable = false
        }
    }
}
