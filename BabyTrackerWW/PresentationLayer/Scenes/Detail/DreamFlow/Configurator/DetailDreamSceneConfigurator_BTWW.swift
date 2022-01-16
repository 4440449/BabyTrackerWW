//
//  DetailDreamSceneConfigurator_BTWW.swift
//  Baby tracker
//
//  Created by Max on 13.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//



final class DetailDreamSceneConfigurator_BTWW {
    func configureScene<D>(view: DetailDreamSceneViewController_BTWW, delegate: D) {
        guard let delegate = delegate as? DetailDreamSceneDelegate_BTWW else { return }
        let router = DetailDreamSceneRouter_BTWW()
        let viewModel = DetailDreamSceneViewModel_BTWW(delegate: delegate, router: router)
        view.viewModel = viewModel
    }
    
    deinit {
        print("DetailDreamSceneConfigurator_BTWW - is Deinit!")
    }
    
}
