//
//  DreamGateway.swift
//  BabyTrackerWW
//
//  Created by Max on 14.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


final class DreamGatewayImpl: DreamGatewayProtocol {
    
    
    // MARK: - Dependencies

    private let network: DreamNetworkRepositoryProtocol
    private let localStorage: DreamPersistentRepositoryProtocol
    
    init(network: DreamNetworkRepositoryProtocol, localStorage: DreamPersistentRepositoryProtocol) {
        self.network = network
        self.localStorage = localStorage
    }
    
    
    // MARK: - Protocol Implements

    func add(new dream: Dream, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) -> Cancellable? {
        
        localStorage.add(new: dream, at: date) { result in
            switch result {
            case .success: callback(.success(()))
            case let .failure(localStorageError): callback(.failure(localStorageError))
            }
        }
        // STUB
        return nil
        
//        let task = RepositoryTask()
//        task.networkTask = network.add(new: dream, at: date) { result in
//            switch result {
//            case .success():
//                self.localStorage.add(new: dream, at: date) { result in
//                    switch result {
//                    case .success: callback(.success(()))
//                    case let .failure(localStorageError): callback(.failure(localStorageError))
//                    }
//                }
//            case let .failure(networkError): callback(.failure(networkError))
//            }
//        }
//       return task
        
    }
    
    
    func change(_ dream: Dream, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) -> Cancellable? {
        
        localStorage.change(dream) { result in
            switch result {
            case .success(): callback(.success(()))
            case let .failure(localStorageError): callback(.failure(localStorageError))
            }
        }
        // STUB
        return nil
        
//      let task = RepositoryTask()
//      task.networkTask = network.change(dream, at: date) { result in
//            switch result {
//            case .success():
//                self.localStorage.change(dream) { result in
//                    switch result {
//                    case .success(): callback(.success(()))
//                    case let .failure(localStorageError): callback(.failure(localStorageError))
//                    }
//                }
//            case let .failure(networkError): callback(.failure(networkError))
//            }
//        }
//        return task
        
    }
    
}
