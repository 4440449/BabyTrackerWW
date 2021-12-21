//
//  LifeCyclesCardNetworkRepository.swift
//  BabyTrackerWW
//
//  Created by Max on 14.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol LifeCyclesCardNetworkRepositoryProtocol {
    
    func fetch(at date: Date, callback: @escaping (Result<[LifeCycle], Error>) -> ()) -> ()
    func synchronize(_ lifeCycles: [LifeCycle], date: Date, callback: @escaping (Result<Void, Error>) -> ())
}



final class LifeCyclesCardNetworkRepositoryImpl: LifeCyclesCardNetworkRepositoryProtocol {
    
    // MARK: - Dependencies
    
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    
    // MARK: - Implements
    
    func fetch(at date: Date, callback: @escaping (Result<[LifeCycle], Error>) -> ()) {
        let apiURL = ApiURL(scheme: .https, host: .supabase, path: .lifeCycles, endPoint: [.date : date.urlFormat()])
        let apiRequest = APIRequest(url: apiURL, method: .get, header: ["apiKey" : apiKey], body: nil)
        let apiSession = APISession.default
        let client = ApiClientImpl(requestConfig: apiRequest, sessionConfig: apiSession)
        return (NetworkRepositoryDTOMapper(client: client).request(decoderType: LifeCycleNetworkEntity.self, callback))
        //        return (NetworkRepositoryDTOMapper(client: client).fetchRequest(callback))
    }
    
    func synchronize(_ lifeCycles: [LifeCycle], date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        let url = ApiURL(scheme: .https, host: .supabase, path: .lifeCycles, endPoint: nil)
        let changeHeader = ["apiKey" : self.apiKey, "Content-Type" : "application/json-patch+json", "Prefer" : "return=representation"]
        let request = APIRequest(url: url, method: .patch, header: changeHeader, body:
            JsonPatchEntity(op: .replace, path: date.webApiFormat(), values:  LifeCycleNetworkEntity(domainEntity: lifeCycles, date: date)))
        let session = APISession.default
        let client = ApiClientImpl(requestConfig: request, sessionConfig: session)
        return (NetworkRepositoryDTOMapper(client: client).request(decoderType: LifeCycleNetworkEntity.self, callback))
        //        return NetworkRepositoryDTOMapper(client: client).request(emptyResult: callback)
    }
    
}
