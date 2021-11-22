//
//  WakeGatewayImpl.swift
//  BabyTrackerWW
//
//  Created by Max on 14.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


final class WakeGatewayImpl: WakeGatewayProtocol {
    
    
    // MARK: - Dependencies

    private let network: WakeNetworkRepositoryProtocol
    private let localStorage: WakePersistentRepositoryProtocol
    
    init(network: WakeNetworkRepositoryProtocol, localStorage: WakePersistentRepositoryProtocol) {
        self.network = network
        self.localStorage = localStorage
    }
    
    func add(new wake: Wake, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        
            localStorage.add(new: wake, at: date) { result in
                switch result {
                case .success: callback(.success(()))
                case let .failure(localStorageError): callback(.failure(localStorageError))
                }
            }
            
//        network.add(new: wake, at: date) { result in //  let task = TODO: - Реализовать в виде таски с передачей наверх для контроля состояния
//            switch result {
//            case .success():
//                self.localStorage.add(new: wake, at: date) { result in
//                    switch result {
//                    case .success: callback(.success(()))
//                    case let .failure(localStorageError): callback(.failure(localStorageError))
//                    }
//                }
//            case let .failure(networkError): callback(.failure(networkError))
//            }
//        }
    }
    
    
    
    func change(_ wake: Wake, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        
        localStorage.change(wake) { result in
            switch result {
            case .success(): callback(.success(()))
            case let .failure(localStorageError): callback(.failure(localStorageError))
            }
        }
        
//        network.change(wake, at: date) { result in //  let task = TODO: - Реализовать в виде таски с передачей наверх для контроля состояния
//                switch result {
//                case .success():
//                    self.localStorage.change(wake) { result in
//                        switch result {
//                        case .success(): callback(.success(()))
//                        case let .failure(localStorageError): callback(.failure(localStorageError))
//                        }
//                    }
//                case let .failure(networkError): callback(.failure(networkError))
//                }
//            }
    }
    
    
}
