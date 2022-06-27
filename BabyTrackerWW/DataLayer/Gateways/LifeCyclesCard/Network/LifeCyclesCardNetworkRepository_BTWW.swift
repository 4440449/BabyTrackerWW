//
//  LifeCyclesCardNetworkRepository_BTWW.swift
//  BabyTrackerWW
//
//  Created by Max on 14.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation
import BabyNet


protocol LifeCyclesCardNetworkRepositoryProtocol_BTWW {
    
    func fetch(at date: Date, callback: @escaping (Result<[LifeCycleNetworkEntity], Error>) -> ()) -> URLSessionTask?
    func synchronize(_ lifeCycles: [LifeCycle], date: Date, callback: @escaping (Result<Data, Error>) -> ()) -> URLSessionTask?
}



final class LifeCyclesCardNetworkRepository_BTWW: LifeCyclesCardNetworkRepositoryProtocol_BTWW {
    
    // MARK: - Dependencies
    
    private let apiKey: String
    private let client: BabyNetRepositoryProtocol
    
    init(apiKey: String, client: BabyNetRepositoryProtocol) {
        self.apiKey = apiKey
        self.client = client
    }
    
    
    // MARK: - Implementation
    
    func fetch(at date: Date, callback: @escaping (Result<[LifeCycleNetworkEntity], Error>) -> ()) -> URLSessionTask? {
        let url = BabyNetURL(scheme: .https,
                             host: "lgrxdkchkrkunwoqiwtl.supabase.co",
                             path: "/rest/v1/LifeCycles",
                             endPoint: ["date" : date.urlFormat()])
        let request = BabyNetRequest(method: .get, header: ["apiKey" : apiKey], body: nil)
        let session = BabyNetSession.default
        let decoderType = [LifeCycleNetworkEntity].self
        
        return client.connect(url: url,
                              request: request,
                              session: session,
                              decoderType: decoderType,
                              observationCallback: nil,
                              taskProgressCallback: nil,
                              responseCallback: callback)
    }
    
    func synchronize(_ lifeCycles: [LifeCycle], date: Date, callback: @escaping (Result<Data, Error>) -> ()) -> URLSessionTask? {
        let url = BabyNetURL(scheme: .https,
                             host: "lgrxdkchkrkunwoqiwtl.supabase.co",
                             path: "/rest/v1/LifeCycles",
                             endPoint: nil)
        let request = BabyNetRequest(method: .patch,
                                     header: ["apiKey" : apiKey, "Content-Type" : "application/json-patch+json", "Prefer" : "return=representation"],
                                     body: JsonPatchEntity_BTWW(op: .replace, path: date.webApiFormat(), values:  LifeCycleNetworkEntity(domainEntity: lifeCycles, date: date)) )
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
