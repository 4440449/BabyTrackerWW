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
        let dreamNetworkRepository = DreamNetworkRepository(apiKey: apiKey)
        let wakeNetworkRepository = WakeNetworkRepository(apiKey: apiKey)
        let lifeCyclesCardNetworkRepository = LifeCyclesCardNetworkRepositoryImpl(apiKey: apiKey)
        
        let dreamPersistentRepository = DreamPersistentRepositoryImpl()
        let wakePersistentRepository = WakePersistentRepositoryImpl()
        let lifeCyclesCardPersistentRepository = LifeCyclesCardPersistentRepositoryImpl(dreamRepository: dreamPersistentRepository, wakeRepository: wakePersistentRepository)
        
        let dreamGateway = DreamGatewayImpl(network: dreamNetworkRepository, localStorage: dreamPersistentRepository)
        let wakeGateway = WakeGatewayImpl(network: wakeNetworkRepository, localStorage: wakePersistentRepository)
        let lifeCyclesCardGateway = LifeCyclesCardGatewayImpl(network: lifeCyclesCardNetworkRepository, localStorage: lifeCyclesCardPersistentRepository)
        
        
        let interactor = MainModuleInteractorImpl(dreamRepository: dreamGateway, wakeRepository: wakeGateway, lifecycleCardRepository: lifeCyclesCardGateway)
        let router = MainSceneRouterImpl()
        let presenter = MainScenePresenterImpl(router: router, interactor: interactor)
        view.presenter = presenter
    }
}
