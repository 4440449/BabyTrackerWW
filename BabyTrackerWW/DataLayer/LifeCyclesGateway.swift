//
//  DataAccessGateway.swift
//  BabyTrackerWW
//
//  Created by Max on 14.10.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


final class DataAccessGateway: LifeCyclesCardGateway {
    
    private let network: NetworkRepositoryConfiguratorProtocol
    private let localStorage: PersistenceRepositoryProtocol
    
    init(apiConfigurator: NetworkRepositoryConfiguratorProtocol, localStorage: PersistenceRepositoryProtocol) {
        self.network = apiConfigurator
        self.localStorage = localStorage
    }
    
    
    // Таску можно возвращать в презент для обратной связи, чтобы пользователь мог скипать задачу
    func fetch(at date: Date, callback: @escaping (Result<[LifeCycle], Error>) -> ()) {
        let task = network.fetch(at: date) { result in
            switch result {
            case let .success(lifeCycle):
                self.localStorage.synchronize(new: lifeCycle, date: date) { result in
                    switch result {
                    case .success: callback(.success(lifeCycle))
                    case let .failure(localStorageError): callback(.failure(localStorageError))
                    }
                }
            case let .failure(networkError): callback(.failure(networkError))
            }
        }
    }
    
    
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
    
    
    func synchronize(new lifeCycles: [LifeCycle], date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        let task = self.network.synchronize(lifeCycles, date: date) { result in
            switch result {
            case .success:
                self.localStorage.synchronize(new: lifeCycles, date: date) { result in
                    switch result {
                    case .success: callback(.success(()))
                    case let .failure(localStorageError): callback(.failure(localStorageError))
                    }
                }
            case let .failure(networkError):
                callback(.failure(networkError))
            }
        }
    }
    
}



