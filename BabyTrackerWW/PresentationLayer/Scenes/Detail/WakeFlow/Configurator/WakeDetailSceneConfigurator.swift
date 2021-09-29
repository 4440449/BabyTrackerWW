//
//  WakeDetailSceneConfigurator.swift
//  BabyTracker - 2 with WakeWindow
//
//  Created by Max on 12.09.2021.
//  Copyright © 2021 Max. All rights reserved.
//


final class WakeDetailSceneConfiguratorImpl {
    func configureScene<D>(view: WakeDetailSceneViewController, delegate: D) {
        guard let delegate = delegate as? DetailSceneDelegate else { return }
        let router = DetailSceneRouterImpl() // Единый Роутер!
        let presenter = DetailScenePresenterImpl(delegate: delegate, router: router) // Единый Презентер!
        view.presenter = presenter
        view.setButtonLabel()
    }
    
    deinit {
        print("WakeDetailSceneConfiguratorImpl - is Deinit!")
    }
    
}


