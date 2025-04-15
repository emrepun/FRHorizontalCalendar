//
//  FRCalendarObservingMock.swift
//  FRHorizontalCalendar
//
//  Created by Emre Havan on 10.04.25.
//

@testable import FRHorizontalCalendar
import Foundation
import XCTest

final class FRCalendarObservingMock: FRCalendarObserving {

    func didTapDay(onDate: Date) { }

    var numberOfTimesDayAppearedWasCalled = 0
    var theLatestDateProvidedWhenDayAppearedWasCalled: Date?
    func dayAppeared(forDate: Date) {
        numberOfTimesDayAppearedWasCalled += 1
        theLatestDateProvidedWhenDayAppearedWasCalled = forDate
    }

    var expectationToFullfilWhenDidSetInitialHeightIsCalled: XCTestExpectation?
    func didSetInitialHeight(_ height: CGFloat) {
        expectationToFullfilWhenDidSetInitialHeightIsCalled?.fulfill()
    }

    var numberOfTimesDidAutoSelectInitialDayWasCalled = 0
    var theLatestDateProvidedWhenDidAutoSelectInitialDayWasCalled: Date?
    func didAutoSelectInitialDay(_ date: Date) {
        numberOfTimesDidAutoSelectInitialDayWasCalled += 1
        theLatestDateProvidedWhenDidAutoSelectInitialDayWasCalled = date
    }

}
