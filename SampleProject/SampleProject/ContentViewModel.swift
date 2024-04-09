//
//  ContentViewModel.swift
//  SampleProject
//
//  Created by Emre Havan on 09.04.24.
//

import Foundation
import FRHorizontalCalendar

final class ContentViewModel: ObservableObject {
    
    let calendarViewModel: FRHorizontalCalendarViewModel

    @Published var calendarHeight: CGFloat?

    init() {
        let components = DateComponents(year: 2023, month: 1, day: 1)
        let startDate = Calendar.current.date(from: components)!
        self.calendarViewModel = .init(startDate: startDate)
        calendarViewModel.delegate = self
    }

    func highlightDaysOnCalendar() {
        // Highlight a couple days before today for sake of example
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: Calendar.current.startOfDay(for: .now))!
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Calendar.current.startOfDay(for: .now))!
        let tenDaysAgo = Calendar.current.date(byAdding: .day, value: -10, to: Calendar.current.startOfDay(for: .now))!
        calendarViewModel.setContentAvailableForDaysWithGivenDates(
            [
                threeDaysAgo,
                sevenDaysAgo,
                tenDaysAgo
            ]
        )
    }
}

extension ContentViewModel: FRCalendarViewModelTapObserving {
    func didTapDay(onDate: Date) {
        // IMPLEMENT ME
    }
    
    func dayAppeared(onDate: Date) {
        // IMPLEMENT ME
    }

    func didSetInitialHeight(_ height: CGFloat) {
        calendarHeight = height
    }

    func didAutoSelectInitialDay(_ date: Date) {
        
    }
}
