//
//  LifeCyclesCardRepository_BTWW.swift
//  BabyTrackerWW
//
//  Created by Max on 14.10.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


final class LifeCyclesCardRepository_BTWW: LifeCyclesCardGateway {
    
    // MARK: - Dependencies

    private let network: LifeCyclesCardNetworkRepositoryProtocol_BTWW
    private let localStorage: LifeCyclesCardPersistentRepositoryProtocol_BTWW
    
    init(network: LifeCyclesCardNetworkRepositoryProtocol_BTWW, localStorage: LifeCyclesCardPersistentRepositoryProtocol_BTWW) {
        self.network = network
        self.localStorage = localStorage
    }
    
    
    // MARK: - Implementation

    func fetch(at date: Date, callback: @escaping (Result<[LifeCycle], Error>) -> ()) -> Cancellable? {
        localStorage.fetch(at: date) { result in
            switch result {
            case let .success(lifecycles): callback(.success(lifecycles))
            case let .failure(localStorageError): callback(.failure(localStorageError))
            }
        }
        // STUB
        return nil
//        let task = RepositoryTask()
//        task.networkTask = network.fetch(at: date) { result in
//            switch result {
//            case let .success(lifeCycle):
//                self.localStorage.synchronize(newValue: newValue, oldValue: oldValue, date: date) { result in
//                    switch result {
//                    case .success: callback(.success(lifeCycle))
//                    case let .failure(localStorageError): callback(.failure(localStorageError))
//                    }
//                }
//            case let .failure(networkError): callback(.failure(networkError))
//            }
//        }
//       return task
    }
    
    func update(newValue: [LifeCycle], oldValue: [LifeCycle], date: Date, callback: @escaping (Result<Void, Error>) -> ()) -> Cancellable? {
        localStorage.synchronize(newValue: newValue, oldValue: oldValue, date: date) { result in
            switch result {
            case .success: callback(.success(()))
            case let .failure(localStorageError): callback(.failure(localStorageError))
            }
        }
        // STUB
        return nil
//        let task = RepositoryTask()
//        task.networkTask = network.synchronize(newValue, date: date) { result in
//            switch result {
//            case .success:
//                self.localStorage.synchronize(newValue: newValue, oldValue: oldValue, date: date) { result in
//                    switch result {
//                    case .success: callback(.success(()))
//                    case let .failure(localStorageError): callback(.failure(localStorageError))
//                    }
//                }
//            case let .failure(networkError):
//                callback(.failure(networkError))
//            }
//        }
//       return task
    }
    
}
