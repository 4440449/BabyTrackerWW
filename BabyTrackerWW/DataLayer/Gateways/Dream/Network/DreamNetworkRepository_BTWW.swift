//
//  DreamNetworkRepository_BTWW.swift
//  BabyTrackerWW
//
//  Created by Max on 14.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation
import BabyNet


protocol DreamNetworkRepositoryProtocol_BTWW {
    
    func add(new dream: Dream, at date: Date, callback: @escaping (Result<Data, Error>) -> ()) -> URLSessionTask?
    func change (_ dream: Dream, at date: Date, callback: @escaping (Result<Data, Error>) -> ()) -> URLSessionTask?
}



final class DreamNetworkRepository_BTWW: DreamNetworkRepositoryProtocol_BTWW {
    
    // MARK: - Dependencies
    
    private let apiKey: String
    private let client: BabyNetRepositoryProtocol
    
    init(apiKey: String, client: BabyNetRepositoryProtocol) {
        self.apiKey = apiKey
        self.client = client
    }
    
    
    // MARK: - Protocol Implementation
    
    func add(new dream: Dream, at date: Date, callback: @escaping (Result<Data, Error>) -> ()) -> URLSessionTask? {
        let url = BabyNetURL(scheme: .https,
                             host: "lgrxdkchkrkunwoqiwtl.supabase.co",
                             path: "/rest/v1/LifeCycles",
                             endPoint: nil)
        let request = BabyNetRequest(method: .post,
                                     header: ["apiKey" : apiKey, "Content-Type" : "application/json-patch+json", "Prefer" : "return=representation"],
                                     body: JsonPatchEntity_BTWW(op: .replace, path: date.webApiFormat(), values: LifeCycleNetworkEntity(domainEntity: [dream], date: date)) )
        let session = BabyNetSession.default
        
        return client.connect(url: url,
                              request: request,
                              session: session,
                              decoderType: nil,
                              observationCallback: nil,
                              taskProgressCallback: nil,
                              responseCallback: callback)
    }
    
    func change (_ dream: Dream, at date: Date, callback: @escaping (Result<Data, Error>) -> ()) -> URLSessionTask? {
        let url = BabyNetURL(scheme: .https,
                             host: "lgrxdkchkrkunwoqiwtl.supabase.co",
                             path: "/rest/v1/LifeCycles",
                             endPoint: nil)
        let request = BabyNetRequest(method: .patch,
                                     header: ["apiKey" : apiKey, "Content-Type" : "application/json-patch+json", "Prefer" : "return=representation"],
                                     body: JsonPatchEntity_BTWW(op: .replace, path: date.webApiFormat(), values: LifeCycleNetworkEntity(domainEntity: [dream], date: date)) )
        let session = BabyNetSession.default
        
        return client.connect(url: url,
                              request: request,
                              session: session,
                              decoderType: nil,
                              observationCallback: nil,
                              taskProgressCallback: nil,
                              responseCallback: callback)
    }
    
}
