//
//  CalendarSceneViewModel_BTWW.swift
//  Baby tracker
//
//  Created by Max on 12.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol CalendarSceneViewModelProtocol_BTWW {
    
    func getCurrentDate() -> Date
    func format(date: Date) -> String
    func dateSelected(new date: Date)
    func saveButtonTapped()
}


final class CalendarSceneViewModel_BTWW: CalendarSceneViewModelProtocol_BTWW {
 
    private let delegate: CalendarSceneDelegate_BTWW
    
    init(delegate: CalendarSceneDelegate_BTWW) {
        self.delegate = delegate
    }
    
    private var date: Date!
    
    
    func getCurrentDate() -> Date {
        date = delegate.shareStateForCalendarScene().date
        return date
    }
    
    func format(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd MMMM YYYY"
        let formatDate = formatter.string(from: date)
        return formatDate
    }

    func dateSelected(new date: Date) {
        self.date = date
    }
    
    func saveButtonTapped() {
        delegate.changeDate(new: date)
    }

}
