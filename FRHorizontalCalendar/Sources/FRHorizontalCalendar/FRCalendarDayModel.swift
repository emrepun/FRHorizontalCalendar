//
//  FRCalendarDayModel.swift
//  
//
//  Created by Emre Havan on 09.04.24.
//

import Foundation

struct FRCalendarDayModel: Hashable {
    let date: Date
    var isSelected: Bool
    var hasContentAvailable: Bool
    // false if in the future
    let isAvailable: Bool
}
