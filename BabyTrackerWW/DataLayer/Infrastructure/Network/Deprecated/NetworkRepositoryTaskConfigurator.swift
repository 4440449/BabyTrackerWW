//
//  APIConfigurator.swift
//  BabyTrackerWW
//
//  Created by Max on 19.10.2021.
//  Copyright © 2021 Max. All rights reserved.
//
/*
import Foundation


protocol NetworkRepositoryConfiguratorProtocol { // LifeCyclesCardNetworkTaskConfiguratorProtocol
    
//    func fetch(at date: Date, callback: @escaping (Result<[LifeCycle], Error>) -> ()) -> ()
//    func synchronize(_ lifeCycle: [LifeCycle], date: Date, callback: @escaping (Result<Void, Error>) -> ())
    
    
    func add(new lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) -> ()
    func change (_ lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ())
    func delete(_ lifeCycle: LifeCycle, date: Date, callback: @escaping (Result<Void, Error>) -> ())
}



protocol WakeNetworkTaskConfiguratorProtocol {
    
    func add(new wake: Wake, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) -> ()
    func change (_ wake: Wake, at date: Date, callback: @escaping (Result<Void, Error>) -> ())
}



final class NetworkRepositoryConfiguratorImpl: NetworkRepositoryConfiguratorProtocol {
    
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    
//    func fetch(at date: Date, callback: @escaping (Result<[LifeCycle], Error>) -> ()) -> () {
//        let apiURL = ApiURL(scheme: .https, host: .supabase, path: .lifeCycles, endPoint: [.date : date.urlFormat()])
//        let apiRequest = APIRequest(url: apiURL, method: .get, header: ["apiKey" : apiKey], body: nil)
//        let apiSession = APISession.default
//        let client = ApiClientImpl(requestConfig: apiRequest, sessionConfig: apiSession)
//        return (NetworkRepositoryDTOMapper(client: client).fetchRequest(callback))
//    }
    
    
    func add(new lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) -> () {
        let apiURL = ApiURL(scheme: .https, host: .supabase, path: .lifeCycles, endPoint: nil)
        let addHeader = ["apiKey" : self.apiKey, "Content-Type" : "application/json-patch+json", "Prefer" : "return=representation"]
        let apiRequest = APIRequest(url: apiURL, method: .post, header: addHeader, body: JsonPatchEntity(op: .replace, path: date.webApiFormat(), values:
            LifeCycleNetworkEntity(domainEntity: [lifeCycle], date: date)) )
        let apiSession = APISession.default
        let client = ApiClientImpl(requestConfig: apiRequest, sessionConfig: apiSession)
        return NetworkRepositoryDTOMapper(client: client).request(emptyResult: callback)
    }

    
    func change (_ lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        let url = ApiURL(scheme: .https, host: .supabase, path: .lifeCycles, endPoint: nil)
        let changeHeader = ["apiKey" : self.apiKey, "Content-Type" : "application/json-patch+json", "Prefer" : "return=representation"]
        let request = APIRequest(url: url, method: .patch, header: changeHeader, body: JsonPatchEntity(op: .replace, path: date.webApiFormat(), values:
            LifeCycleNetworkEntity(domainEntity: [lifeCycle], date: date)) )
        let session = APISession.default
        let client = ApiClientImpl(requestConfig: request, sessionConfig: session)
        return NetworkRepositoryDTOMapper(client: client).request(emptyResult: callback)
    }
    
    
    func delete(_ lifeCycle: LifeCycle, date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        let url = ApiURL(scheme: .https, host: .supabase, path: .lifeCycles, endPoint: nil)
        let deleteHeader = ["apiKey" : self.apiKey, "Content-Type" : "application/json-patch+json", "Prefer" : "return=representation"]
        let request = APIRequest(url: url, method: .delete, header: deleteHeader, body: JsonPatchEntity(op: .remove, path: date.webApiFormat(), values: LifeCycleNetworkEntity(domainEntity: [lifeCycle], date: date)) )
        let session = APISession.default
        let client = ApiClientImpl(requestConfig: request, sessionConfig: session)
        return NetworkRepositoryDTOMapper(client: client).request(emptyResult: callback)
    }
    
    
//    func synchronize(_ lifeCycles: [LifeCycle], date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
//        let url = ApiURL(scheme: .https, host: .supabase, path: .lifeCycles, endPoint: nil)
//        let changeHeader = ["apiKey" : self.apiKey, "Content-Type" : "application/json-patch+json", "Prefer" : "return=representation"]
//        let request = APIRequest(url: url, method: .patch, header: changeHeader, body:
//            JsonPatchEntity(op: .replace, path: date.webApiFormat(), values:  LifeCycleNetworkEntity(domainEntity: lifeCycles, date: date)))
//        let session = APISession.default
//        let client = ApiClientImpl(requestConfig: request, sessionConfig: session)
//        return NetworkRepositoryDTOMapper(client: client).request(emptyResult: callback)
//    }
    
}
*/
