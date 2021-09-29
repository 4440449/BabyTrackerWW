//
//  WakeDetailSceneConfigurator.swift
//  BabyTracker - 2 with WakeWindow
//
//  Created by Max on 12.09.2021.
//  Copyright © 2021 Max. All rights reserved.
//


final class WakeDetailSceneConfiguratorImpl {
    func configureScene<D>(view: WakeDetailSceneViewController, delegate: D) {
        guard let delegate = delegate as? WakeDetailSceneDelegate else { return }
        let router = DetailSceneRouterImpl() // Единый Роутер!
        let presenter = DetailScenePresenterImpl(router: router) // Единый Презентер!
        presenter.wakeDelegate = delegate
        view.presenter = presenter
        view.setButtonLabel()
    }
    
    deinit {
        print("WakeDetailSceneConfiguratorImpl - is Deinit!")
    }
    
}


