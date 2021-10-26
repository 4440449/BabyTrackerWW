//
//  NetworkRepository.swift
//  BabyTrackerWW
//
//  Created by Max on 21.10.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol NetworkRepositoryProtocol {
    func fetchRequest(callback: @escaping (Result<[LifeCycle], Error>) -> ())
    func request(callback: @escaping (Result<Void, Error>) -> ())
}


final class NetworkRepositoryImpl: NetworkRepositoryProtocol {
    
    private let client: ApiClientProtocol
    
    init(client: ApiClientProtocol) {
        self.client = client
    }
    
    func fetchRequest(callback: @escaping (Result<[LifeCycle], Error>) -> ()) {
        self.client.execute { result in
            switch result {
            case let .success(data):
                do {
                    let domainEntity = try JSONDecoder().decode(LifeCycleNetworkEntity.self, from: data).parseToDomain()
                    callback(.success(domainEntity))
                } catch {
                    callback(.failure(error))
                }
                
            case let .failure(error): callback(.failure(error))
            }
        }
    }
    
    func request(callback: @escaping (Result<Void, Error>) -> ()) {
        self.client.execute { result in
            switch result {
            case .success: callback(.success(()))
            case let .failure(error): callback(.failure(error))
            }
        }
    }


}
