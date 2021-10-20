//
//  APIConfigurator.swift
//  BabyTrackerWW
//
//  Created by Max on 19.10.2021.
//  Copyright © 2021 Max. All rights reserved.
//


protocol NetworkRepositoryConfiguratorProtocol {
    
    func fetch() -> NetworkRepositoryProtocol
}

final class NetworkRepositoryConfiguratorImpl: NetworkRepositoryConfiguratorProtocol {
    
    private let apiKey = ["apiKey" : "yJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYzNDUwMDIxNiwiZXhwIjoxOTUwMDc2MjE2fQ.7ZAxW0Odek5URLpm5HOfLcD-mI-JJmdKTfbFUZnpBKk"]
    
    init(apiKey: [String : String]) {
//        self.apiKey = apiKey
//        Сделать внешнюю инъекцию ключа через init()
    }
    
    func fetch() -> NetworkRepositoryProtocol {
        let apiURL = ApiURL(scheme: .https, host: .supabase, path: .dreamDB)
        let apiRequest = APIRequest(url: apiURL, method: .get, header: apiKey)
        let session = APISession.default
        return NetworkRepository(session: session, request: apiRequest)
    }
    
    // дописать остальные вызовы
    
    
    
}
