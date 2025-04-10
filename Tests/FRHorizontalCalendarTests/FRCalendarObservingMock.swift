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

    func dayAppeared(forDate: Date) { }

    var expectationToFullfilWhenDidSetInitialHeightIsCalled: XCTestExpectation?
    func didSetInitialHeight(_ height: CGFloat) {
        expectationToFullfilWhenDidSetInitialHeightIsCalled?.fulfill()
    }

    func didAutoSelectInitialDay(_ date: Date) { }

}
