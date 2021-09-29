//
//  CalendarSceneConfigurator.swift
//  Baby tracker
//
//  Created by Max on 23.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//


final class CalendarSceneConfiguratorImpl {
    
    func configureScene<D>(view: CalendarSceneViewController, delegate: D) {
        guard let delegate = delegate as? CalendarSceneDelegate else { return }
        let presenter = CalendarScenePresenterImpl(delegate: delegate)
        view.presenter = presenter
    }
    
}
