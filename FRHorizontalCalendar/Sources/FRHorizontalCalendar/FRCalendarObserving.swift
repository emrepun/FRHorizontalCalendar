//
//  FRCalendarObserving.swift
//  
//
//  Created by Emre Havan on 09.04.24.
//

import Foundation

public protocol FRCalendarObserving: AnyObject {

    func didTapDay(onDate: Date)
    
    /// Implement this method if you want to get notified when a calendar appears. Please note that, everytime
    /// The calendar appears, for example if the user switches between tabs of the application and makes the whole view
    /// where the calendar view is contained appear again, this method will be triggered for each day on the screen
    /// in no particular order.
    /// You can use this method to set content available on the calendar in a paginated way, if you don't want to calculate and
    /// provide all the days with content all at once.
    /// - Parameter forDate: The `Date` for the beginning of moment of the tapped day.
    func dayAppeared(forDate: Date)

    /// Implement this method if you want to add the calendar to a scrollable component (List, ScrollView, etc.)
    /// Once it is called, set the height value on your observed object or state object, and update calendar view's height
    /// by updating a published property from your observed object where the view sets the value as calendar's height.
    /// - Parameter height: Height computed for the current device's orientation and the space available for the calendar's width.
    func didSetInitialHeight(_ height: CGFloat)

    /// This method will be called when the calendar first appears and today is auto selected, as the selected day.
    /// - Parameter date: The beginning of today's date.
    func didAutoSelectInitialDay(_ date: Date)
}

// Optional methods
public extension FRCalendarObserving {
    func dayAppeared(onDate: Date) {
        
    }

    func didSetInitialHeight(_ height: CGFloat) {
        
    }

    func didAutoSelectInitialDay(_ date: Date) {
        
    }
}
