//
//  FRHorizontalCalendarViewModelTests.swift
//  FRHorizontalCalendar
//
//  Created by Emre Havan on 10.04.25.
//

import XCTest
@testable import FRHorizontalCalendar
import SwiftUI

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

    func test_delegate_is_notified_only_once_when_height_is_set() {
        let sut = makeSUTAndSetDelegate()
        let expectation = XCTestExpectation()
        expectation.assertForOverFulfill = true
        delegateMock.expectationToFullfilWhenDidSetInitialHeightIsCalled = expectation

        // Call it twice to ensure it won't fulfill the expectation twice
        sut.setHeight(100.0)
        sut.setHeight(100.0)

        wait(for: [expectation], timeout: 0.1)
    }

    // MARK: - dayStringFor(_ date: Date) -> String

    func test_day_string_is_formatted_as_expected() throws {
        let date = try XCTUnwrap(makeDateForARegularDay())
        let sut = makeSUTAndSetDelegate()

        let result = sut.dayStringFor(date)

        XCTAssertEqual(result, "Thu")
    }

    // MARK: - dateStringFor(_ date: Date) -> String

    func test_date_string_is_formatted_as_expected() throws {
        let date = try XCTUnwrap(makeDateForARegularDay())
        let sut = makeSUTAndSetDelegate()

        let result = sut.dateStringFor(date)
        XCTAssertEqual(result, "10")
    }

    // MARK: - dayStringForegroundColorFor(_ day: FRCalendarDayModel) -> Color

    func test_correct_day_string_foreground_color_is_provided_for_a_non_available_day() {
        let sut = makeSUTAndSetDelegate()
        let day = makeDay()

        let result = sut.dayStringForegroundColorFor(day)

        XCTAssertEqual(result, Color(uiColor: .systemGray5))
    }

    func test_correct_day_string_foreground_color_is_provided_for_an_available_and_selected_day() {
        let sut = makeSUTAndSetDelegate()
        let day = makeDay(isSelected: true, isAvailable: true)

        let result = sut.dayStringForegroundColorFor(day)

        XCTAssertEqual(result, Color.white)
    }

    func test_correct_day_string_color_is_provided_for_an_available_unselected_day_when_it_is_today() {
        let sut = makeSUTAndSetDelegate()
        let beginningOfToday = Calendar.current.startOfDay(for: .now)
        let day = makeDay(date: beginningOfToday, isAvailable: true)

        let result = sut.dayStringForegroundColorFor(day)

        XCTAssertEqual(result, Color.blue)
    }

    func test_correct_day_string_color_is_provided_for_an_available_unselected_previous_day() throws {
        let sut = makeSUTAndSetDelegate()
        // This date will guaranteed to be non-today for any day this unit tests are run in the future
        let dateComponents = DateComponents(year: 2025, month: 4, day: 9)
        let date = try XCTUnwrap(Calendar.current.date(from: dateComponents))
        let day = makeDay(date: date, isAvailable: true)

        let result = sut.dayStringForegroundColorFor(day)

        XCTAssertEqual(result, Color(uiColor: .systemGray))
    }
    
    // MARK: - Utilities

    private func makeDay(date: Date = .now, isSelected: Bool = false, hasContentAvailable: Bool = false, isAvailable: Bool = false) -> FRCalendarDayModel {
        FRCalendarDayModel(date: date, isSelected: isSelected, hasContentAvailable: hasContentAvailable, isAvailable: isAvailable)
    }
    private func makeDateForARegularDay() -> Date? {
        let dateComponents = DateComponents(year: 2025, month: 4, day: 10)
        return Calendar.current.date(from: dateComponents)
    }

    private func makeSUTAndSetDelegate() -> FRHorizontalCalendarViewModel {
        let sut = FRHorizontalCalendarViewModel(startDate: calendarStartDate)
        sut.delegate = delegateMock
        return sut
    }

    private func subtractDays(from startDate: Date, dayCount: Int) -> Date? {
        guard let newDate = Calendar.current.date(byAdding: .day, value: -dayCount, to: startDate) else {
            return nil
        }
        return newDate
    }
}
