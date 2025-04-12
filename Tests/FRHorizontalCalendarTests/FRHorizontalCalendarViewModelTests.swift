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
    
    // MARK: - didAutoSelectInitialDay(_ date: Date)
    func test_delegate_is_notified_when_initial_day_is_auto_selected() {
        _ = makeSUTAndSetDelegate()

        XCTAssertEqual(1, delegateMock.numberOfTimesDidAutoSelectInitialDayWasCalled)
    }

    func test_expected_date_is_provided_for_auto_selected_initial_day() {
        // it should select today automatically, regardless of what today is
        _ = makeSUTAndSetDelegate()

        let expectedDate = Calendar.current.startOfDay(for: .now)

        XCTAssertEqual(expectedDate, delegateMock.theLatestDateProvidedWhenDidAutoSelectInitialDayWasCalled)
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
    
    // MARK: - dateStringForegroundColorFor(_ day: FRCalendarDayModel) -> Color
    
    func test_correct_date_string_foreground_color_is_provided_for_a_non_available_day() {
        let sut = makeSUTAndSetDelegate()
        let day = makeDay()
        
        let result = sut.dateStringForegroundColorFor(day)
        
        XCTAssertEqual(result, Color(uiColor: .systemGray3))
    }
    
    func test_correct_date_string_foreground_color_is_provided_for_an_available_and_selected_day() {
        let sut = makeSUTAndSetDelegate()
        let day = makeDay(isSelected: true, isAvailable: true)
        
        let result = sut.dateStringForegroundColorFor(day)
        
        XCTAssertEqual(result, Color.white)
    }

    func test_correct_date_string_color_is_provided_for_an_available_unselected_day_when_it_is_today() {
        let sut = makeSUTAndSetDelegate()
        let beginningOfToday = Calendar.current.startOfDay(for: .now)
        let day = makeDay(date: beginningOfToday, isAvailable: true)
        
        let result = sut.dateStringForegroundColorFor(day)
        
        XCTAssertEqual(result, Color.blue)
    }
    
    func test_correct_date_string_color_is_provided_for_an_available_unselected_previous_day() throws {
        let sut = makeSUTAndSetDelegate()
        // This date will guaranteed to be non-today for any day this unit tests are run in the future
        let dateComponents = DateComponents(year: 2025, month: 4, day: 9)
        let date = try XCTUnwrap(Calendar.current.date(from: dateComponents))
        let day = makeDay(date: date, isAvailable: true)
        
        let result = sut.dateStringForegroundColorFor(day)
        
        XCTAssertEqual(result, Color(uiColor: .label))
    }
    
    // MARK: - backgroundColorFor(_ day: FRCalendarDayModel) -> Color

    func test_correct_background_color_is_provided_for_a_selected_day() {
        let sut = makeSUTAndSetDelegate()
        let day = makeDay(isSelected: true)

        let result = sut.backgroundColorFor(day)

        XCTAssertEqual(result, Color.blue)
    }

    func test_correct_background_color_is_provided_for_an_unselected_day_with_content() {
        let sut = makeSUTAndSetDelegate()
        let day = makeDay(hasContentAvailable: true)

        let result = sut.backgroundColorFor(day)

        XCTAssertEqual(result, Color.blue.opacity(0.25))
    }

    func test_correct_background_color_is_provided_for_an_unselected_day_with_no_content() {
        let sut = makeSUTAndSetDelegate()
        let day = makeDay()

        let result = sut.backgroundColorFor(day)

        XCTAssertEqual(result, Color.clear)
    }

    // MARK: - dayAppeared(_ day: FRCalendarDayModel)

    func test_delegate_is_notified_when_a_day_appears() {
        let sut = makeSUTAndSetDelegate()
        let beginningDateOfToday = Calendar.current.startOfDay(for: .now)
        let day = makeDay(date: beginningDateOfToday)

        sut.dayAppeared(day)

        XCTAssertEqual(delegateMock.numberOfTimesDayAppearedWasCalled, 1)
        XCTAssertEqual(delegateMock.theLatestDateProvidedWhenDayAppearedWasCalled, beginningDateOfToday)
    }

    // MARK: - setContentAvailableForDaysWithGivenDates(_ dates: [Date])

    func test_setting_content_available_for_given_dates_update_the_day_models() throws {
        let sut = makeSUTAndSetDelegate()
        // This date will guaranteed to be non-today for any day this unit tests are run in the future
        let dateComponents = DateComponents(year: 2025, month: 4, day: 9)
        let date = try XCTUnwrap(Calendar.current.date(from: dateComponents))

        sut.setContentAvailableForDaysWithGivenDates([date])

        let contentAvailableDayIndex = sut.allDays.first(where: {
            $0.hasContentAvailable &&
            $0.date == Calendar.current.startOfDay(for: date)
        })

        // Since by default no day has contentAvailable, and we only set the content available for one date,
        // If we get a non-nil value from allDays where dates are a match, we can assume it is working as intended
        XCTAssertNotNil(contentAvailableDayIndex)
    }

    func test_removing_content_available_for_given_dates_update_day_models() throws {
        let sut = makeSUTAndSetDelegate()
        // This date will guaranteed to be non-today for any day this unit tests are run in the future
        let dateComponents = DateComponents(year: 2025, month: 4, day: 9)
        let date = try XCTUnwrap(Calendar.current.date(from: dateComponents))
        // First set content available for the date to bring it to the desired state
        sut.setContentAvailableForDaysWithGivenDates([date])

        sut.removeContentAvailableForDayWithGivenDate(date)

        let contentAvailableDayIndex = sut.allDays.first(where: {
            $0.hasContentAvailable &&
            $0.date == Calendar.current.startOfDay(for: date)
        })

        XCTAssertNil(contentAvailableDayIndex)
    }
    
    // TODO: Write tests `dayDisappeared`, which is related to mostProminentMonthText
    // TODO: Write tests for `mostProminentMonthText`
    // TODO: Write tests for `didTapOnDayAt`
    // It is not easy to write tests for the methods above
    // due to the way the calendar is configured at the moment, we will revisit this later.
    // The problem is the calendar automatically loads and adds days to the day when the code is run
    // Thus, it is hard to implement non-flaky tests at the moments.

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
