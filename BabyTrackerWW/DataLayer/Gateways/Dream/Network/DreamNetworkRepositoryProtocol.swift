//
//  DreamNetworkRepositoryProtocol.swift
//  BabyTrackerWW
//
//  Created by Max on 14.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation
import BabyNet


protocol DreamNetworkRepositoryProtocol {
    
    func add(new dream: Dream, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) -> URLSessionTask?
    func change (_ dream: Dream, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) -> URLSessionTask?
}



final class DreamNetworkRepository: DreamNetworkRepositoryProtocol {
    
    // MARK: - Dependencies
    
    private let apiKey: String
    private let client: BabyNetRepositoryProtocol
    
    init(apiKey: String, client: BabyNetRepositoryProtocol) {
        self.apiKey = apiKey
        self.client = client
    }
    
    
    // MARK: - Protocol Implements
    
    func add(new dream: Dream, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) -> URLSessionTask? {
        let url = BabyNetURL(scheme: .https,
                             host: "lgrxdkchkrkunwoqiwtl.supabase.co",
                             path: "/rest/v1/LifeCycles",
                             endPoint: nil)
        let request = BabyNetRequest(method: .post,
                                     header: ["apiKey" : apiKey, "Content-Type" : "application/json-patch+json", "Prefer" : "return=representation"],
                                     body: JsonPatchEntity(op: .replace, path: date.webApiFormat(), values: LifeCycleNetworkEntity(domainEntity: [dream], date: date)) )
        let session = BabyNetSession.default
        let decoderType = DreamNetworkEntity.self
        
        return client.connect(url: url,
                              request: request,
                              session: session,
                              decoderType: decoderType,
                              callback: callback)
    }
    
    func change (_ dream: Dream, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) -> URLSessionTask? {
        let url = BabyNetURL(scheme: .https,
                             host: "lgrxdkchkrkunwoqiwtl.supabase.co",
                             path: "/rest/v1/LifeCycles",
                             endPoint: nil)
        let request = BabyNetRequest(method: .patch,
                                     header: ["apiKey" : apiKey, "Content-Type" : "application/json-patch+json", "Prefer" : "return=representation"],
                                     body: JsonPatchEntity(op: .replace, path: date.webApiFormat(), values: LifeCycleNetworkEntity(domainEntity: [dream], date: date)) )
        let session = BabyNetSession.default
        let decoderType = DreamNetworkEntity.self
        
        return client.connect(url: url,
                              request: request,
                              session: session,
                              decoderType: decoderType,
                              callback: callback)
    }
    
}
