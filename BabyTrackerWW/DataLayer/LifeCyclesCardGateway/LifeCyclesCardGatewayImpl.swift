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
    private let localStorage: LifeCyclesCardPersistenceRepositoryProtocol
    
    init(network: LifeCyclesCardNetworkRepositoryProtocol, localStorage: LifeCyclesCardPersistenceRepositoryProtocol) {
        self.network = network
        self.localStorage = localStorage
    }
    
    
    // MARK: - Implements

    // Таску можно возвращать в презент для обратной связи, чтобы пользователь мог скипать задачу
    func fetch(at date: Date, callback: @escaping (Result<[LifeCycle], Error>) -> ()) {
        network.fetch(at: date) { result in //  let task = TODO: - Реализовать в виде таски с передачей наверх для контроля состояния
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
    
    func update(new lifeCycles: [LifeCycle], date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        self.network.synchronize(lifeCycles, date: date) { result in //  let task = TODO: - Реализовать в виде таски с передачей наверх для контроля состояния
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
    



