//
//  FRHorizontalCalendarViewModelTests.swift
//  FRHorizontalCalendar
//
//  Created by Emre Havan on 10.04.25.
//

import XCTest
@testable import FRHorizontalCalendar

final class FRHorizontalCalendarViewModelTests: XCTestCase {

    private var delegateMock: FRCalendarObservingMock!
    private let calendarStartDate: Date = {
        let components = DateComponents(year: 2023, month: 1, day: 1)
        return Calendar.current.date(from: components)!
    }()

    override func setUp() {
        super.setUp()
        delegateMock = .init()
    }

    override func tearDown() {
        delegateMock = nil
        super.tearDown()
    }

    private func subtractDays(from startDate: Date, dayCount: Int) -> Date? {
        guard let newDate = Calendar.current.date(byAdding: .day, value: -dayCount, to: startDate) else {
            fatalError()
        }
        return newDate
    }
}
