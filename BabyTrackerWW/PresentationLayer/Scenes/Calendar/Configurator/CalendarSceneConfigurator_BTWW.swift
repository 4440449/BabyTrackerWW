//
//  CalendarSceneConfigurator_BTWW.swift
//  Baby tracker
//
//  Created by Max on 23.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//


final class CalendarSceneConfigurator_BTWW {
    
    func configureScene<D>(view: CalendarSceneViewController_BTWW, interactor: D) {
        guard let interactor = interactor as? CalendarSceneInteractor_BTWW else { return }
        let presenter = CalendarScenePresenter_BTWW(interactor: interactor)
        view.setupPresenter(presenter)
    }
    
}
