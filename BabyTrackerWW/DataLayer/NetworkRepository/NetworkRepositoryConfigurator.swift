//
//  APIConfigurator.swift
//  BabyTrackerWW
//
//  Created by Max on 19.10.2021.
//  Copyright © 2021 Max. All rights reserved.
//
import Foundation


protocol NetworkRepositoryConfiguratorProtocol {
    
    func fetchDreamsConfig(at date: Date) -> NetworkRepositoryProtocol
    func fetchWakesConfig() -> NetworkRepositoryProtocol
}

final class NetworkRepositoryConfiguratorImpl: NetworkRepositoryConfiguratorProtocol {
    
    private let apiKey: [String : String]
    
    init(apiKey: String) {
        self.apiKey = ["apiKey" : apiKey]
    }
    
    func fetchDreamsConfig(at date: Date) -> NetworkRepositoryProtocol { // принимаю на вход боди в виде структуры Лайфцикл
        let apiURL = ApiURL(scheme: .https, host: .supabase, path: .dream)
        let apiRequest = APIRequest(url: apiURL, method: .get, header: apiKey)
        let apiSession = APISession.default
        let client = ApiClientImpl(requestConfig: apiRequest, sessionConfig: apiSession)
        return NetworkRepositoryImpl(client: client)
            // 25.10.21  МБ конфигурировать конкретную таску?
    }
    
    func fetchWakesConfig() -> NetworkRepositoryProtocol {
        let apiURL = ApiURL(scheme: .https, host: .supabase, path: .wake)
        let apiRequest = APIRequest(url: apiURL, method: .get, header: apiKey)
        let apiSession = APISession.default
        let client = ApiClientImpl(requestConfig: apiRequest, sessionConfig: apiSession)
        return NetworkRepositoryImpl(client: client)
    }

    
    
// Реализовать прием хедера, боди
    struct ApiParameters {
        let header: [String : String]?
        let body: [String : String]?
    }
    
//    init(header: String, body: String) {
//        self.header =
//    }
    
}
