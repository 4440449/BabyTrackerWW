//
//  WakeDetailSceneConfigurator.swift
//  BabyTracker - 2 with WakeWindow
//
//  Created by Max on 12.09.2021.
//  Copyright © 2021 Max. All rights reserved.
//



final class DetailWakeSceneConfiguratorImpl {
    func configureScene<D>(view: DetailWakeSceneViewController, delegate: D) {
        guard let delegate = delegate as? DetailWakeSceneDelegate else { return }
        let router = DetailWakeSceneRouterImpl() // Единый Роутер!
        let presenter = DetailWakeScenePresenterImpl(delegate: delegate, router: router)
        view.presenter = presenter
    }
    
    deinit {
        print("WakeDetailSceneConfiguratorImpl - is Deinit!")
    }
    
}

