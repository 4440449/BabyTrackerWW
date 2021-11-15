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
    private let localStorage: DreamPersistenceRepositoryProtocol
    
    init(network: DreamNetworkRepositoryProtocol, localStorage: DreamPersistenceRepositoryProtocol) {
        self.network = network
        self.localStorage = localStorage
    }
    
    
    // MARK: - Protocol Implements

    func add(new dream: Dream, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        network.add(new: dream, at: date) { result in //  let task = TODO: - Реализовать в виде таски с передачей наверх для контроля состояния
            switch result {
            case .success():
                self.localStorage.add(new: dream, at: date) { result in
                    switch result {
                    case .success: callback(.success(()))
                    case let .failure(localStorageError): callback(.failure(localStorageError))
                    }
                }
            case let .failure(networkError): callback(.failure(networkError))
            }
        }
        
    }
    
    
    func change(_ dream: Dream, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
       network.change(dream, at: date) { result in //  let task = TODO: - Реализовать в виде таски с передачей наверх для контроля состояния
            switch result {
            case .success():
                self.localStorage.change(dream) { result in
                    switch result {
                    case .success(): callback(.success(()))
                    case let .failure(localStorageError): callback(.failure(localStorageError))
                    }
                }
            case let .failure(networkError): callback(.failure(networkError))
            }
        }
        
    }
    
}
