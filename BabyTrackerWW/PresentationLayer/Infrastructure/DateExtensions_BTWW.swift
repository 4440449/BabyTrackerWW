//
//  DateExtensions_BTWW.swift
//  BabyTrackerWW
//
//  Created by Maxim on 12.07.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import Foundation


extension Array {
    
    mutating func rearrange(from: Int, to: Int) {
        insert(remove(at: from), at: to)
    }
}

extension Date {
    
    func nextDay() -> Date? {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        let nextDay = calendar.date(byAdding: .hour, value: 24, to: self)
        return nextDay
    }
    
    func previousDay() -> Date? {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        let previousDay = calendar.date(byAdding: .hour, value: -24, to: self)
        return previousDay
    }
    
    
}
