//
//  APIConfigurator.swift
//  BabyTrackerWW
//
//  Created by Max on 19.10.2021.
//  Copyright © 2021 Max. All rights reserved.
//


protocol NetworkRepositoryConfiguratorProtocol {
    
    func fetchDreams() -> NetworkRepositoryProtocol
    func fetchWakes() -> NetworkRepositoryProtocol
}

final class NetworkRepositoryConfiguratorImpl: NetworkRepositoryConfiguratorProtocol {
    
    private var apiKey = ["apiKey" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYzNDUwMDIxNiwiZXhwIjoxOTUwMDc2MjE2fQ.7ZAxW0Odek5URLpm5HOfLcD-mI-JJmdKTfbFUZnpBKk"]
    
    init(apiKey: String) {
        self.apiKey = ["apiKey" : apiKey]
//        Сделать внешнюю инъекцию ключа через init()
    }
    
    func fetchDreams() -> NetworkRepositoryProtocol {
        let apiURL = ApiURL(scheme: .https, host: .supabase, path: .dream)
        let apiRequest = APIRequest(url: apiURL, method: .get, header: apiKey)
        let session = APISession.default
        return NetworkRepository(session: session, request: apiRequest)
    }
    
    func fetchWakes() -> NetworkRepositoryProtocol {
        let apiURL = ApiURL(scheme: .https, host: .supabase, path: .wake)
        let apiRequest = APIRequest(url: apiURL, method: .get, header: apiKey)
        let session = APISession.default
        return NetworkRepository(session: session, request: apiRequest)
    }

    
    
    // дописать остальные вызовы
    
    
    
}
