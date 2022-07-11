//
//  DetailDreamSceneConfigurator_BTWW.swift
//  Baby tracker
//
//  Created by Max on 13.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//



final class DetailDreamSceneConfigurator_BTWW {
    func configureScene<D>(view: DetailDreamSceneViewController_BTWW,
                           delegate: D,
                           selectedIndex: Int?) {
        guard let delegate = delegate as? DetailDreamSceneDelegate_BTWW else { return }
        let router = DetailDreamSceneRouter_BTWW()
        let presenter = DetailDreamScenePresenter_BTWW(view: view,
                                                       delegate: delegate,
                                                       router: router,
                                                       selectedIndex: selectedIndex)
        view.setupPresenter(presenter)
    }
    
    deinit {
        print("DetailDreamSceneConfigurator_BTWW - is Deinit!")
    }
    
}
