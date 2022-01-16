//
//  DetailWakeSceneConfigurator_BTWW.swift
//  BabyTrackerWW
//
//  Created by Max on 12.09.2021.
//  Copyright © 2021 Max. All rights reserved.
//



final class DetailWakeSceneConfigurator_BTWW {
    func configureScene<D>(view: DetailWakeSceneViewController_BTWW, delegate: D) {
        guard let delegate = delegate as? DetailWakeSceneDelegate_BTWW else { return }
        let router = DetailWakeSceneRouter_BTWW()
        let viewModel = DetailWakeSceneViewModel_BTWW(delegate: delegate, router: router)
        view.viewModel = viewModel
    }
    
    deinit {
        print("DetailWakeSceneConfigurator_BTWW - is Deinit!")
    }
    
}

