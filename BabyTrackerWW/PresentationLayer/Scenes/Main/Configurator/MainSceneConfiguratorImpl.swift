//
//  MainSceneConfigurator.swift
//  Baby tracker
//
//  Created by Max on 11.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//


final class MainSceneConfiguratorImpl {
    
    func configureScene(view: MainSceneTableViewController) {
        let wakeRepository = WakePersistenceRepositoryImpl()
        let dreamRepository = DreamPersistenceRepositoryImpl()
        let persistenceRepository = PersistenceRepositoryGateway(wakeRepository: wakeRepository, dreamRepository: dreamRepository)
        let interactor = MainModuleInteractorImpl(persistenceRepository: persistenceRepository)
        let router = MainSceneRouterImpl()
        let presenter = MainScenePresenterImpl(router: router, interactor: interactor)
        view.presenter = presenter
    }
}
