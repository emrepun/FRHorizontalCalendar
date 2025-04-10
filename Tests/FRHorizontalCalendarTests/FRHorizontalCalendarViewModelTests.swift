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

    // MARK: - setHeight(_ height: CGFloat) tests
    func test_delegate_is_notified_only_once_when_height_is_set() throws {
        let sut = FRHorizontalCalendarViewModel(startDate: calendarStartDate)
        sut.delegate = delegateMock
        let expectation = XCTestExpectation()
        expectation.assertForOverFulfill = true
        delegateMock.expectationToFullfilWhenDidSetInitialHeightIsCalled = expectation

        // Call it twice to ensure it won't fulfill the expectation twice
        sut.setHeight(100.0)
        sut.setHeight(100.0)

        wait(for: [expectation], timeout: 0.1)
    }

    private func subtractDays(from startDate: Date, dayCount: Int) -> Date? {
        guard let newDate = Calendar.current.date(byAdding: .day, value: -dayCount, to: startDate) else {
            fatalError()
        }
        return newDate
    }
}
