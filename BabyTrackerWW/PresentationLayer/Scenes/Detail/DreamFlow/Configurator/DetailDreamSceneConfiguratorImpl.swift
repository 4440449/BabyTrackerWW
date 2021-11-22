//
//  DetailSceneConfigurator.swift
//  Baby tracker
//
//  Created by Max on 13.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//



final class DetailDreamSceneConfiguratorImpl {
    func configureScene<D>(view: DetailDreamSceneViewController, delegate: D) {
        guard let delegate = delegate as? DetailDreamSceneDelegate else { return }
        let router = DetailDreamSceneRouterImpl()
        let presenter = DetailDreamScenePresenterImpl(delegate: delegate, router: router)
        view.presenter = presenter
    }
    
    deinit {
        print("DreamDetailSceneConfiguratorImpl - is Deinit!")
    }
    
}
