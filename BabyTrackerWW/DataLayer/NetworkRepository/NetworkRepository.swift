//
//  NetworkRepositoryGateway.swift
//  BabyTrackerWW
//
//  Created by Max on 14.10.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol NetworkRepositoryProtocol {
    
    func execute(callback: @escaping (Result<Data, Error>) -> ())
}


public final class NetworkRepository: NetworkRepositoryProtocol {
    
    private let session: APISession
    private let request: APIRequest
    
    init(session: APISession, request: APIRequest) {
        self.session = session
        self.request = request
    }
    
    func execute(callback: @escaping (Result<Data, Error>) -> ()) {

        guard let request = request.create() else { callback(.failure(RequestError.ReqErr)); return }
        
        let dataTask = session.create().dataTask(with: request) { data, response, error in
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                callback(.failure(error!))
                return
            }
            guard let data = data, (200...299).contains(httpUrlResponse.statusCode) else {
                callback(.failure(error!))
                return
            }
            callback(.success(data))
        }
        dataTask.resume()
    }
    
    // Еще нужны коды ошибок! Сделать энумы!
            
    
    
//    func parseJsonToDomain(data: Data) { // Парсинг вынести куда нибудь повыше
//        JSONDecoder.decode(<#T##self: JSONDecoder##JSONDecoder#>)
//    }
    
}

enum RequestError: Error {
    case ReqErr
}

