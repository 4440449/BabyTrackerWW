//
//  NetworkRepositoryGateway.swift
//  BabyTrackerWW
//
//  Created by Max on 14.10.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol ApiClientProtocol {
    
    func execute(callback: @escaping (Result<Data, Error>) -> ())
}


final class ApiClientImpl: ApiClientProtocol {
    
    private let requestConfig: APIRequest
    private let sessionConfig: APISession
    
    init(requestConfig: APIRequest, sessionConfig: APISession) {
        self.requestConfig = requestConfig
        self.sessionConfig = sessionConfig
    }
    
    func execute(callback: @escaping (Result<Data, Error>) -> ()) {
        do {
            let request = try self.requestConfig.createRequest()
            let session = self.sessionConfig.createSession()
            
            let dataTask = session.dataTask(with: request) { data, response, error in
                // если сервер не ответил - выкидываю ошибку
                guard error == nil, let httpResponse = response as? HTTPURLResponse else {
                    callback(.failure(NetworkError.badRequest(error!.localizedDescription)) ); return }
                // если сервер ответил неудачно - выкидываю ошибку
                guard let data = data, (200...299).contains(httpResponse.statusCode) else { callback(.failure(NetworkError.badResponse("\(httpResponse.statusCode) + \(httpResponse.allHeaderFields)")) ); return }
                callback(.success(data))
            }
            dataTask.resume()
            
        } catch let requestGeneration {
            callback(.failure(requestGeneration))
        }
    }
    
}


//
//struct BadResponse: Error {
//
//    enum HTTPDescription: String {
//        case redirect = "Redirect!"
//        case errorClient = "Client error! Code status"
//        case errorServer = "Server error!"
//        case unknown = "Unknown!"
//    }
//
//    let code: Int
//    let description: HTTPDescription
//
//    init (code: Int) {
//        self.code = code
//
//        switch code {
//        case 300...399: self.description = .redirect
//        case 400...499: self.description = .errorClient
//        case 500...599: self.description = .errorServer
//        default: self.description = .unknown
//        }
//    }
//}
//
//            guard error == nil else { callback(.failure(NetworkError.request(error!.localizedDescription))); return }
//            guard let response = response as? HTTPURLResponse else { callback(.failure(NetworkError.httpURLResponse("Fatal url response error"))); return }
//            if let data = data, (200...299).contains(response.statusCode) {
//                callback(.success(data))
//            } else {
//                let unexpectResponse = UnexpectHTTPResponse(code: response.statusCode)
//                callback(.failure(unexpectResponse))
//            }
//
//            if let error = error {
//                guard let httpResponse = response as? HTTPURLResponse else { callback(.failure(NetworkError.badRequest(error.localizedDescription))) }
//                callback(.failure(NetworkError.badResponse("Bad response, error code: \(httpResponse.statusCode)")))
//            } else {
//                callback(.success(data!))
//            }
//
//            guard error == nil else { callback (.failure(NetworkError.request(error!.localizedDescription))) }
//            if let response = response as? HTTPURLResponse {
//                guard let data = data, (200...299).contains(response.statusCode) else { }
//                callback(.success(data))
//                }
