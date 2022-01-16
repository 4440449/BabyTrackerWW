//
//  CalendarSceneConfigurator_BTWW.swift
//  Baby tracker
//
//  Created by Max on 23.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//


final class CalendarSceneConfigurator_BTWW {
    
    func configureScene<D>(view: CalendarSceneViewController_BTWW, delegate: D) {
        guard let delegate = delegate as? CalendarSceneDelegate_BTWW else { return }
        let viewModel = CalendarSceneViewModel_BTWW(delegate: delegate)
        view.viewModel = viewModel
    }
    
}
