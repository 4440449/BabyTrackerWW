//
//  MainSceneConfigurator_BTWW.swift
//  Baby tracker
//
//  Created by Max on 11.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import BabyNet


final class MainSceneConfigurator_BTWW {
    
    func configureScene(view: MainSceneTableViewController_BTWW) {
        let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYzNDUwMDIxNiwiZXhwIjoxOTUwMDc2MjE2fQ.7ZAxW0Odek5URLpm5HOfLcD-mI-JJmdKTfbFUZnpBKk"
        let networkClient = BabyNetRepository()
        let dreamNetworkRepository = DreamNetworkRepository_BTWW(apiKey: apiKey, client: networkClient)
        let wakeNetworkRepository = WakeNetworkRepository_BTWW(apiKey: apiKey, client: networkClient)
        let lifeCyclesCardNetworkRepository = LifeCyclesCardNetworkRepository_BTWW(apiKey: apiKey, client: networkClient)
        
        let dreamPersistentRepository = DreamPersistentRepository_BTWW()
        let wakePersistentRepository = WakePersistentRepository_BTWW()
        let lifeCyclesCardPersistentRepository = LifeCyclesCardPersistentRepository_BTWW(dreamRepository: dreamPersistentRepository, wakeRepository: wakePersistentRepository)
        
        let dreamGateway = DreamRepository_BTWW(network: dreamNetworkRepository, localStorage: dreamPersistentRepository)
        let wakeGateway = WakeRepository_BTWW(network: wakeNetworkRepository, localStorage: wakePersistentRepository)
        let lifeCyclesCardGateway = LifeCyclesCardRepository_BTWW(network: lifeCyclesCardNetworkRepository, localStorage: lifeCyclesCardPersistentRepository)
        
        let interactor = Interactor_BTWW(dreamRepository: dreamGateway, wakeRepository: wakeGateway, lifecycleCardRepository: lifeCyclesCardGateway)
        let router = MainSceneRouter_BTWW()
        let presenter = MainScenePresenter_BTWW(view: view, router: router, interactor: interactor)
        view.setupPresenter(presenter)
    }
}
