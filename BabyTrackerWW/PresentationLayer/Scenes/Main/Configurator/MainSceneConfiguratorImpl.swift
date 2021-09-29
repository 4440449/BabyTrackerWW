//
//  MainSceneConfigurator.swift
//  Baby tracker
//
//  Created by Max on 11.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//


final class MainSceneConfiguratorImpl {
    
    func configureScene(view: MainSceneTableViewController) {
        let dreamGateway = PersistenceRepositoryImpl()
        let interactor = MainModuleInteractorImpl(dreamGateway: dreamGateway)
        let router = MainSceneRouterImpl()
        let presenter = MainScenePresenterImpl(router: router, interactor: interactor)
        view.presenter = presenter
    }
}
