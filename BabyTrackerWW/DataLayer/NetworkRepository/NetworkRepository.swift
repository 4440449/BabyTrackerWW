//
//  NetworkRepositoryGateway.swift
//  BabyTrackerWW
//
//  Created by Max on 14.10.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol NetworkRepositoryProtocol {
    
    func execute(request: URLRequest, session: URLSession, callback: @escaping (Result<Data, Error>) -> ())
    
}


public final class NetworkRepository: NetworkRepositoryProtocol { // Переименовать в Менеджера? Т.к. более не репозиторий, просто выходит в сеть и проверяет ошибки и респонз
    func execute(request: URLRequest, session: URLSession, callback: @escaping (Result<Data, Error>) -> ()) {
        //
        //        guard let request = request.create(callback: callback) else { return } // адекватно?
        //
        //        guard let request = try? self.request.create() else { callback (.failure(NetworkErrors.requestError)); return // пока преобразовываю ошибку из реквест функции в нил, хз как ее здесь обработать нормально и записать в значение для дальнейшего использования в создании сессии...
        //        }
        //
        //        let dataTask = session.create().dataTask(with: request) { data, response, error in
        let dataTask = session.dataTask(with: request) { data, response, error in
            guard error == nil else { callback(.failure(error!)); return }
            guard let data = data else { callback (.failure(error!)); return }
            guard let response = response as? HTTPURLResponse else { callback(.failure(error!)); return }
            let httpResp = APIResponseError(value: response.statusCode)
            guard httpResp.description == .success else { callback(.failure(httpResp)); return } // чекнуть корректность вывода ошибки
            callback(.success(data))
        }
        //
        //            guard let httpUrlResponse = response as? HTTPURLResponse, let error = error else {
        //                callback(.failure(error))
        //                return
        //            }
        //            guard let data = data,
        //                      (200...299).contains(httpUrlResponse.statusCode),
        //                      response as! HTTPURLResponse
        //                        else {
        //                callback(.failure(error!))
        //                return
        //            }
        //            callback(.success(data))
        //        }
        dataTask.resume()
    }
}



struct APIResponseError: Error {
    
    enum HTTPResponseCustom: String {
        case info = "Info"
        case success = "Success!"
        case redirect = "Redirect!"
        case errorClient = "Client error!"
        case errorServer = "Server error!"
        
        case unknown = "Unknown!"
    }
    
    let code: Int
    let description: HTTPResponseCustom
    
    init (value: Int) {
        self.code = value
        
        switch value {
        case 100...199: self.description = .info
        case 200...299: self.description = .success
        case 300...399: self.description = .redirect
        case 400...499: self.description = .errorClient
        case 500...599: self.description = .errorServer
        default: self.description = .unknown
            //        default: self.value = .unknown("Error initilize property")
            
        }
    }
}

