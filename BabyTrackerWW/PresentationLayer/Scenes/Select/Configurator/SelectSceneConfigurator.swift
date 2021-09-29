//
//  SelectSceneConfigurator.swift
//  BabyTracker - 2 with WakeWindow
//
//  Created by Max on 14.09.2021.
//  Copyright © 2021 Max. All rights reserved.
//


class SelectSceneConfiguratorImpl {
    
    func configureScene<D>(view: SelectSceneTableViewController, delegate: D) {
        guard let delegate = delegate as? SelectSceneDelegate else { return }
        let router = SelectSceneRouterImpl()
        let presenter = SelectScenePresenterImpl(router: router, delegate: delegate)
        view.presenter = presenter
    }
    
    deinit {
        print("SelectSceneConfiguratorImpl - is Deinit!")
    }
}


