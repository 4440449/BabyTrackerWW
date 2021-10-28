//
//  APIConfigurator.swift
//  BabyTrackerWW
//
//  Created by Max on 19.10.2021.
//  Copyright © 2021 Max. All rights reserved.
//
import Foundation

// NetworkTaskConfigurator?
protocol NetworkRepositoryConfiguratorProtocol {
    
    func fetch(at date: Date, callback: @escaping (Result<[LifeCycle], Error>) -> ()) -> ()
    func add(new lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) -> ()
    func change(_ lifeCycle: LifeCycle, callback: @escaping (Result<Void, Error>) -> ())
    func delete(_ lifeCycle: LifeCycle, callback: @escaping (Result<Void, Error>) -> ())
}


final class NetworkRepositoryConfiguratorImpl: NetworkRepositoryConfiguratorProtocol {
    
    private let apiKey: [String : String]
    //    private let apiPapams: ApiParams
    
    init(apiKey: String) {
        self.apiKey = ["apiKey" : apiKey]
        //        self.apiPapams = apiParams
    }
    
    func fetch(at date: Date, callback: @escaping (Result<[LifeCycle], Error>) -> ()) -> () {
        let apiURL = ApiURL(scheme: .https, host: .supabase, path: .dream, endPoint: [.date : date.description])
        let apiRequest = APIRequest(url: apiURL, method: .get, header: apiKey, body: nil)
        let apiSession = APISession.default
        let client = ApiClientImpl(requestConfig: apiRequest, sessionConfig: apiSession)
        return NetworkRepositoryImpl(client: client).fetchRequest(callback: callback)
    }
    
    func add(new lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) -> () {
        switch lifeCycle {
            
        case let lifeCycle as Dream:
            let apiURL = ApiURL(scheme: .https, host: .supabase, path: .dream, endPoint: [.date : date.description])
            let apiRequest = APIRequest(url: apiURL, method: .post, header: apiKey, body: [.dream : (DreamNetworkEntity(domainEntity: lifeCycle))])
            let apiSession = APISession.default
            let client = ApiClientImpl(requestConfig: apiRequest, sessionConfig: apiSession)
            return NetworkRepositoryImpl(client: client).request(callback: callback)
            
        case let lifeCycle as Wake:
            let apiURL = ApiURL(scheme: .https, host: .supabase, path: .wake, endPoint: [.date : date.description])
            let apiRequest = APIRequest(url: apiURL, method: .post, header: apiKey, body: [.wake : (WakeNetworkEntity(domainEntity: lifeCycle))])
            let apiSession = APISession.default
            let client = ApiClientImpl(requestConfig: apiRequest, sessionConfig: apiSession)
            return NetworkRepositoryImpl(client: client).request(callback: callback)
            
        default: fatalError("Undefined type for func network.add(new: lifecycle)")
        }
    }
    
    
    func change(_ lifeCycle: LifeCycle, callback: @escaping (Result<Void, Error>) -> ()) {
        
        
    }
    
    
    
    func delete(_ lifeCycle: LifeCycle, callback: @escaping (Result<Void, Error>) -> ()) {
        
        
        
    }
    
    
}
