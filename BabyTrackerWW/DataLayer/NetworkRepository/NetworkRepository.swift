//
//  NetworkRepository.swift
//  BabyTrackerWW
//
//  Created by Max on 21.10.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol NetworkRepositoryProtocol { // Как нибудь переименовать? Не оч нравится название, т.к. класс не только мапит..
    func fetchRequest(callback: @escaping (Result<[LifeCycle], Error>) -> ())
}


final class NetworkRepositoryImpl: NetworkRepositoryProtocol {

    private let request: APIRequest
    private let session: APISession
    private let client: ApiClientProtocol
    
    init(request: APIRequest, session: APISession, client: ApiClientProtocol) {
        self.request = request
        self.session = session
        self.client = client
    }
    
    func fetchRequest(callback: @escaping (Result<[LifeCycle], Error>) -> ()) {
        do {
            let request = try self.request.create()
            let session = self.session.create()
            
            self.client.execute(request: request, session: session) { result in
                switch result {
                case let .success(data): break
                case let .failure(error): break
                }
            }
            
        } catch let requestGenerationError {
            // DEBUG
            print(requestGenerationError)
            // DEBUG
            callback(.failure(requestGenerationError))
        }
        
    
        
    }
    
//    func parseToDomain (data: Data) -> LifeCycle {
//        switch data {
//        case let data as Wake:
//        case let data as Dream:
//        }
//    }
//    func parseToNetwork -> {}
}

//    func parseJsonToDomain(data: Data) { // Парсинг вынести куда нибудь повыше
//        JSONDecoder.decode(<#T##self: JSONDecoder##JSONDecoder#>)
//    }
