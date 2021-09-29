//
//  DetailSceneConfigurator.swift
//  Baby tracker
//
//  Created by Max on 13.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//




final class DreamDetailSceneConfiguratorImpl {
    func configureScene<D>(view: DreamDetailSceneViewController, delegate: D) {
        guard let delegate = delegate as? DetailSceneDelegate else { return }
        let router = DetailSceneRouterImpl() // Единый Роутер!
        let presenter = DetailScenePresenterImpl(delegate: delegate, router: router) // Единый Презентер!
        view.presenter = presenter
        view.setButtonLabel()
    }
    
    deinit {
        print("DreamDetailSceneConfiguratorImpl - is Deinit!")
    }
    
}

