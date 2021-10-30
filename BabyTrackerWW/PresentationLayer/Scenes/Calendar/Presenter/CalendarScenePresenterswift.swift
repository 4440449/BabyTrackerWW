//
//  CalendarScenePresenterswift.swift
//  Baby tracker
//
//  Created by Max on 12.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol CalendarScenePresenterProtocol {
    
    var currentDate: Date { get }
    func format(date: Date) -> String
    func dateSelected(new date: Date)
    func saveButtonTapped()
}


final class CalendarScenePresenterImpl: CalendarScenePresenterProtocol {
 
    private let delegate: CalendarSceneDelegate
    init(delegate: CalendarSceneDelegate) {
        self.delegate = delegate
    }
    
    private var date: Date!
    
    
    var currentDate: Date {
        date = delegate.showDate()
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
