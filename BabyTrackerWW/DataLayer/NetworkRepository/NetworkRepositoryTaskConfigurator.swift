//
//  APIConfigurator.swift
//  BabyTrackerWW
//
//  Created by Max on 19.10.2021.
//  Copyright © 2021 Max. All rights reserved.
//
import Foundation


protocol NetworkRepositoryConfiguratorProtocol {
    
    func fetch(at date: Date, callback: @escaping (Result<[LifeCycle], Error>) -> ()) -> ()
    func add(new lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) -> ()
    func change (_ lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ())
    func delete(_ lifeCycle: LifeCycle, callback: @escaping (Result<Void, Error>) -> ())
    func synchronize(_ lifeCycle: [LifeCycle], date: Date, callback: @escaping (Result<Void, Error>) -> ())
}


final class NetworkRepositoryConfiguratorImpl: NetworkRepositoryConfiguratorProtocol {
    
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
        //        self.header = ["apiKey" : apiKey, "Content-Type" : "application/json", "Prefer" : "return=representation"]
    }
    
    
    func fetch(at date: Date, callback: @escaping (Result<[LifeCycle], Error>) -> ()) -> () {
        let apiURL = ApiURL(scheme: .https, host: .supabase, path: .dream, endPoint: [.date : urlFormat(date)])
        let apiRequest = APIRequest(url: apiURL, method: .get, header: ["apiKey" : apiKey], body: nil)
        let apiSession = APISession.default
        let client = ApiClientImpl(requestConfig: apiRequest, sessionConfig: apiSession)
        return (NetworkRepositoryDTOMapper(client: client).fetchRequest(callback: callback))
    }
    
    
    func add(new lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) -> () {
        switch lifeCycle {
            
        case let lifeCycle as Dream:
            let apiURL = ApiURL(scheme: .https, host: .supabase, path: .dream, endPoint: nil)
            let addHeader = ["apiKey" : apiKey, "Content-Type" : "application/json", "Prefer" : "return=representation"]
            let apiRequest = APIRequest(url: apiURL, method: .post, header: addHeader, body: (DreamNetworkEntity(domainEntity: lifeCycle, date: webApiFormat(date))) )
            let apiSession = APISession.default
            let client = ApiClientImpl(requestConfig: apiRequest, sessionConfig: apiSession)
            return NetworkRepositoryDTOMapper(client: client).request(callback: callback)
            
        case let lifeCycle as Wake:
            let apiURL = ApiURL(scheme: .https, host: .supabase, path: .wake, endPoint: [.date : urlFormat(date)])
            let header = ["apiKey" : apiKey, "Content-Type" : "application/json", "Prefer" : "return=representation"]
            let apiRequest = APIRequest(url: apiURL, method: .post, header: header, body: (WakeNetworkEntity(domainEntity: lifeCycle, date: webApiFormat(date))) )
            let apiSession = APISession.default
            let client = ApiClientImpl(requestConfig: apiRequest, sessionConfig: apiSession)
            return NetworkRepositoryDTOMapper(client: client).request(callback: callback)
            
        default: callback(.failure(NetworkError.downcasting("Error downcasting! Unexpected input type / func network.add(new: Lifecycle)")))
            //fatalError("Undefined type for func network.add(new: Lifecycle)")
        }
    }
    
    //    func change(_ lifeCycle: LifeCycle, callback: @escaping (Result<Void, Error>) -> ()) {
    //        print("~")
    //    }
    
    func change (_ lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        
        switch lifeCycle {
            
        case let lifeCycle as Dream:
            let url = ApiURL(scheme: .https, host: .supabase, path: .dream, endPoint: [.id : webApiFormat(lifeCycle.id)])
            let changeHeader = ["apiKey" : apiKey, "Content-Type" : "application/json", "Prefer" : "return=representation"]
            let request = APIRequest(url: url, method: .patch, header: changeHeader, body: DreamNetworkEntity(domainEntity: lifeCycle, date: webApiFormat(date)) )
            let session = APISession.default
            let client = ApiClientImpl(requestConfig: request, sessionConfig: session)
            return NetworkRepositoryDTOMapper(client: client).request(callback: callback)
            
        case let lifeCycle as Wake:
            let url = ApiURL(scheme: .https, host: .supabase, path: .wake, endPoint: nil)
            let changeHeader = ["apiKey" : apiKey, "Content-Type" : "application/json", "Prefer" : "return=representation"]
            let request = APIRequest(url: url, method: .patch, header: changeHeader, body: WakeNetworkEntity(domainEntity: lifeCycle, date: webApiFormat(date)) )
            let session = APISession.default
            let client = ApiClientImpl(requestConfig: request, sessionConfig: session)
            return NetworkRepositoryDTOMapper(client: client).request(callback: callback)
            
        default: callback(.failure(NetworkError.downcasting("Error downcasting! Unexpected input type / func network.change(_: Lifecycle)")))
        }
    }
    
    
    
    func delete(_ lifeCycle: LifeCycle, callback: @escaping (Result<Void, Error>) -> ()) {
        switch lifeCycle {
            
        case let lifeCycle as Dream:
            let url = ApiURL(scheme: .https, host: .supabase, path: .dream, endPoint: [.id : webApiFormat(lifeCycle.id)])
            let request = APIRequest(url: url, method: .delete, header: ["apiKey" : apiKey], body: nil)
            let session = APISession.default
            let client = ApiClientImpl(requestConfig: request, sessionConfig: session)
            return NetworkRepositoryDTOMapper(client: client).request(callback: callback)
            
        case let lifeCycle as Wake:
            let url = ApiURL(scheme: .https, host: .supabase, path: .wake, endPoint: [.id : webApiFormat(lifeCycle.id)])
            let request = APIRequest(url: url, method: .delete, header: ["apiKey" : apiKey], body: nil)
            let session = APISession.default
            let client = ApiClientImpl(requestConfig: request, sessionConfig: session)
            return NetworkRepositoryDTOMapper(client: client).request(callback: callback)
            
        default: callback(.failure(NetworkError.downcasting("Error downcasting! Unexpected input type / func network.delete(_: Lifecycle)")))
        }
    }
    
    
    
    func synchronize(_ lifeCycle: [LifeCycle], date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        let dreams = lifeCycle.compactMap { $0 as? Dream }
        let wakes = lifeCycle.compactMap { $0 as? Wake }
        
        let group = DispatchGroup()
        let dreamWorkItem = DispatchWorkItem {
            
        }
        
        let wakeWorkItem = DispatchWorkItem  {
            
        }
        
        group.notify(queue: .main) {  } 
  
    }
    
    
    
    func urlFormat(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return "eq.\(formatter.string(from: date))"
    }
    
    func webApiFormat(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter.string(from: date)
    }
    
    func webApiFormat(_ id: UUID) -> String {
        let strID = id.uuidString
        return "eq.\(strID)"
    }
    
}
