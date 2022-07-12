//
//  CalendarScenePresenter_BTWW.swift
//  Baby tracker
//
//  Created by Max on 12.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol CalendarScenePresenterInputProtocol_BTWW {
    func getCurrentDate() -> Date
    func format(date: Date) -> String
    func dateSelected(new date: Date)
    func saveButtonTapped()
}


final class CalendarScenePresenter_BTWW: CalendarScenePresenterInputProtocol_BTWW {
 
    //MARK: - Dependencies
    
    private let interactor: CalendarSceneInteractor_BTWW
    
    init(interactor: CalendarSceneInteractor_BTWW) {
        self.interactor = interactor
    }
    
    
    //MARK: - Buffer

    private var date = Date()
    
    
    // MARK: - Input interface

    func getCurrentDate() -> Date {
        date = interactor.shareStateForCalendarScene().date
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
        interactor.changeDate(new: date)
    }

}
