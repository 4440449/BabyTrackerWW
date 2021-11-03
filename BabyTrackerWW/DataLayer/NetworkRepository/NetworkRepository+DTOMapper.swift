//
//  NetworkRepository.swift
//  BabyTrackerWW
//
//  Created by Max on 21.10.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol NetworkRepositoryDTOMapperProtocol {
    func fetchRequest(_ callback: @escaping (Result<[LifeCycle], Error>) -> ())
    func request(emptyResult callback: @escaping (Result<Void, Error>) -> ())
}


final class NetworkRepositoryDTOMapper: NetworkRepositoryDTOMapperProtocol {
    
    private let client: ApiClientProtocol
    
    init(client: ApiClientProtocol) {
        self.client = client
    }

    
    func fetchRequest(_ callback: @escaping (Result<[LifeCycle], Error>) -> ()) {
        self.client.execute { result in
            switch result {
            case let .success(data):
//                print("json data == \(String(data: data, encoding: .utf8)!)")
                do {
                    let networkEntity = try JSONDecoder().decode(LifeCycleNetworkEntity.self, from: data)
                    let domainEntity = try networkEntity.parseToDomain()
//                    print("networkEntity == \(networkEntity)")
//                    print("domainEntity == \(domainEntity)")
                    callback(.success(domainEntity))
                } catch {
                    callback(.failure(error))
                }
            case let .failure(error): callback(.failure(error))
            }
        }
    }
    
    
    func request(emptyResult callback: @escaping (Result<Void, Error>) -> ()) {
        self.client.execute { result in
            switch result {
            case .success: callback(.success(()))
            case let .failure(error): callback(.failure(error))
            }
        }
    }
    
}
