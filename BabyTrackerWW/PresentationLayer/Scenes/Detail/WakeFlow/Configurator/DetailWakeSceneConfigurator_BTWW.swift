//
//  DetailWakeSceneConfigurator_BTWW.swift
//  BabyTrackerWW
//
//  Created by Max on 12.09.2021.
//  Copyright © 2021 Max. All rights reserved.
//



final class DetailWakeSceneConfigurator_BTWW {
    func configureScene<D>(view: DetailWakeSceneViewController_BTWW,
                           delegate: D,
                           selectedIndex: Int?) {
        guard let delegate = delegate as? DetailWakeSceneDelegate_BTWW else { return }
        let router = DetailWakeSceneRouter_BTWW()
        let presenter = DetailWakeScenePresenter_BTWW(view: view,
                                                      delegate: delegate,
                                                      router: router,
                                                      selectedIndex: selectedIndex)
        view.setupPresenter(presenter)
    }
    
    deinit {
        print("DetailWakeSceneConfigurator_BTWW - is Deinit!")
    }
    
}

