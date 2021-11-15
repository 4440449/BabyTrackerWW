//
//  DreamNetworkRepositoryProtocol.swift
//  BabyTrackerWW
//
//  Created by Max on 14.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol DreamNetworkRepositoryProtocol {
    
    func add(new dream: Dream, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) -> ()
    func change (_ dream: Dream, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) -> ()
}



final class DreamNetworkRepository: DreamNetworkRepositoryProtocol {
    
    // MARK: - Dependencies
    
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    
    // MARK: - Protocol Implements

    func add(new dream: Dream, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) -> () {
        let apiURL = ApiURL(scheme: .https, host: .supabase, path: .lifeCycles, endPoint: nil)
        let addHeader = ["apiKey" : self.apiKey, "Content-Type" : "application/json-patch+json", "Prefer" : "return=representation"]
        let apiRequest = APIRequest(url: apiURL, method: .post, header: addHeader, body: JsonPatchEntity(op: .replace, path: date.webApiFormat(), values:
            LifeCycleNetworkEntity(domainEntity: [dream], date: date)) )
        let apiSession = APISession.default
        let client = ApiClientImpl(requestConfig: apiRequest, sessionConfig: apiSession)
        return NetworkRepositoryDTOMapper(client: client).request(emptyResult: callback)
    }
    
    func change (_ dream: Dream, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) -> () {
        let url = ApiURL(scheme: .https, host: .supabase, path: .lifeCycles, endPoint: nil)
        let changeHeader = ["apiKey" : self.apiKey, "Content-Type" : "application/json-patch+json", "Prefer" : "return=representation"]
        let request = APIRequest(url: url, method: .patch, header: changeHeader, body: JsonPatchEntity(op: .replace, path: date.webApiFormat(), values:
            LifeCycleNetworkEntity(domainEntity: [dream], date: date)) )
        let session = APISession.default
        let client = ApiClientImpl(requestConfig: request, sessionConfig: session)
        return NetworkRepositoryDTOMapper(client: client).request(emptyResult: callback)
    }
    
}
