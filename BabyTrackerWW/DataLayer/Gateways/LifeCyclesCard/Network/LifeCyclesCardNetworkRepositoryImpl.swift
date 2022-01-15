//
//  LifeCyclesCardNetworkRepository.swift
//  BabyTrackerWW
//
//  Created by Max on 14.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation
import BabyNet


protocol LifeCyclesCardNetworkRepositoryProtocol {
    
    func fetch(at date: Date, callback: @escaping (Result<[LifeCycle], Error>) -> ()) -> URLSessionTask?
    func synchronize(_ lifeCycles: [LifeCycle], date: Date, callback: @escaping (Result<Void, Error>) -> ()) -> URLSessionTask?
}



final class LifeCyclesCardNetworkRepositoryImpl: LifeCyclesCardNetworkRepositoryProtocol {
    
    // MARK: - Dependencies
    
    private let apiKey: String
    private let client: BabyNetRepositoryProtocol
    
    init(apiKey: String, client: BabyNetRepositoryProtocol) {
        self.apiKey = apiKey
        self.client = client
    }
    
    
    // MARK: - Implements
    
    func fetch(at date: Date, callback: @escaping (Result<[LifeCycle], Error>) -> ()) -> URLSessionTask? {
        let url = BabyNetURL(scheme: .https,
                             host: "lgrxdkchkrkunwoqiwtl.supabase.co",
                             path: "/rest/v1/LifeCycles",
                             endPoint: ["date" : date.urlFormat()])
        let request = BabyNetRequest(method: .get, header: ["apiKey" : apiKey], body: nil)
        let session = BabyNetSession.default
        let decoderType = LifeCycleNetworkEntity.self
        
        return client.connect(url: url,
                              request: request,
                              session: session,
                              decoderType: decoderType,
                              callback: callback)
    }
    
    func synchronize(_ lifeCycles: [LifeCycle], date: Date, callback: @escaping (Result<Void, Error>) -> ()) -> URLSessionTask? {
        let url = BabyNetURL(scheme: .https,
                             host: "lgrxdkchkrkunwoqiwtl.supabase.co",
                             path: "/rest/v1/LifeCycles",
                             endPoint: nil)
        let request = BabyNetRequest(method: .patch,
                                     header: ["apiKey" : apiKey, "Content-Type" : "application/json-patch+json", "Prefer" : "return=representation"],
                                     body: JsonPatchEntity(op: .replace, path: date.webApiFormat(), values:  LifeCycleNetworkEntity(domainEntity: lifeCycles, date: date)) )
        let session = BabyNetSession.default
        let decoderType = LifeCycleNetworkEntity.self
        
        return client.connect(url: url,
                              request: request,
                              session: session,
                              decoderType: decoderType,
                              callback: callback)
    }
    
}
