//
//  MainSceneConfigurator.swift
//  Baby tracker
//
//  Created by Max on 11.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//


final class MainSceneConfiguratorImpl {
    
    func configureScene(view: MainSceneTableViewController) {
        let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYzNDUwMDIxNiwiZXhwIjoxOTUwMDc2MjE2fQ.7ZAxW0Odek5URLpm5HOfLcD-mI-JJmdKTfbFUZnpBKk"
        let networkRepository = NetworkRepositoryConfiguratorImpl(apiKey: apiKey)
        
        let wakePersistenceRepository = WakePersistenceRepositoryImpl()
        let dreamPersistenceRepository = DreamPersistenceRepositoryImpl()
        let localStorage = PersistenceRepositoryGateway(wakeRepository: wakePersistenceRepository, dreamRepository: dreamPersistenceRepository)
        
        let repository = DataAccessGateway(apiConfigurator: networkRepository, localStorage: localStorage)
        
        let interactor = MainModuleInteractorImpl(persistenceRepository: repository)
        let router = MainSceneRouterImpl()
        let presenter = MainScenePresenterImpl(router: router, interactor: interactor)
        view.presenter = presenter
    }
}
