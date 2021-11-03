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
    func fetchLifeCycle(at date: Date, callback: @escaping (Result<[LifeCycle], Error>) -> ()) {
        let task = network.fetch(at: date) { result in
            switch result {
            case let .success(lifeCycle):
                self.localStorage.synchronize(lifeCycle: lifeCycle, date: date) { result in
                    switch result {
                    case .success: callback(.success(lifeCycle))
                    case let .failure(localStorageError): callback(.failure(localStorageError))
                    }
                }
            case let .failure(networkError): callback(.failure(networkError))
            }
        }
    }
    
    
    func addNewLifeCycle(new lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
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
    
    
    func changeLifeCycle(_ lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        let task = network.change(lifeCycle, at: date) { result in
            switch result {
            case .success():
                self.localStorage.change(lifeCycle) { result in
                    switch result {
                    case .success(): callback(.success(()))
                    case let .failure(localStorageError): callback(.failure(localStorageError))
                    }
                }
            case let .failure(networkError): callback(.failure(networkError))
            }
        }
    }
    
    
    func deleteLifeCycle(_ lifeCycle: LifeCycle, date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        let task = network.delete(lifeCycle, date: date) { result in
            switch result {
            case .success():
                self.localStorage.delete(lifeCycle) { result in
                    switch result {
                    case .success(): callback(.success(()))
                    case let .failure(localStorageError): callback(.failure(localStorageError))
                    }
                }
            case let .failure(networkError): callback(.failure(networkError))
            }
        }
    }
    
    
    func synchronize(new elements: [LifeCycle], date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        let task = self.network.synchronize(elements, date: date) { result in
            switch result {
            case .success:
                self.localStorage.synchronize(lifeCycle: elements, date: date) { result in
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



