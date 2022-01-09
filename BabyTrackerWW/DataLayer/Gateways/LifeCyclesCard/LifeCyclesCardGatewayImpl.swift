//
//  DataAccessGateway.swift
//  BabyTrackerWW
//
//  Created by Max on 14.10.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


final class LifeCyclesCardGatewayImpl: LifeCyclesCardGateway {
    
    // MARK: - Dependencies

    private let network: LifeCyclesCardNetworkRepositoryProtocol
    private let localStorage: LifeCyclesCardPersistentRepositoryProtocol
    
    init(network: LifeCyclesCardNetworkRepositoryProtocol, localStorage: LifeCyclesCardPersistentRepositoryProtocol) {
        self.network = network
        self.localStorage = localStorage
    }
    
    
    // MARK: - Implements

    // Таску можно возвращать в презент для обратной связи, чтобы пользователь мог скипать задачу
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
    




    
    /*
    
    func add(new lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        let task = network.add(new: lifeCycle, at: date) { result in
            switch result {
            case .success():
                self.localStorage.add(new: lifeCycle, at: date) { result in
                    switch result {
                    case .success: callback(.success(()))
                    case let .failure(localStorageError): callback(.failure(localStorageError))
                    }
                }
            case let .failure(networkError): callback(.failure(networkError))
            }
        }
    }
    
    
    func change(current lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        let task = network.change(lifeCycle, at: date) { result in
            switch result {
            case .success():
                self.localStorage.change(current: lifeCycle, at: date) { result in
                    switch result {
                    case .success(): callback(.success(()))
                    case let .failure(localStorageError): callback(.failure(localStorageError))
                    }
                }
            case let .failure(networkError): callback(.failure(networkError))
            }
        }
    }
    
    
    func delete(_ lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        let task = network.delete(lifeCycle, date: date) { result in
            switch result {
            case .success():
                self.localStorage.delete(lifeCycle, at: date) { result in
                    switch result {
                    case .success(): callback(.success(()))
                    case let .failure(localStorageError): callback(.failure(localStorageError))
                    }
                }
            case let .failure(networkError): callback(.failure(networkError))
            }
        }
    }
    
    */
    




