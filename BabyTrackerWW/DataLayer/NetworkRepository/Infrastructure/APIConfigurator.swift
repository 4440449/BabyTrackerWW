//
//  APIRequest.swift
//  BabyTrackerWW
//
//  Created by Max on 18.10.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation

// MARK: - URL

public struct ApiURL {
    
    private let scheme: Scheme
    private let host: Host
    private let path: Path
    
    
    enum Scheme: String {
        case http  = "http://"
        case https = "https://"
    }
    enum Host: String {
        case supabase = "lgrxdkchkrkunwoqiwtl.supabase.co"
    }
    enum Path: String {
        case dream = "/rest/v1/Dream"
        case wake  = "/rest/v1/Wake"
    }
    
    
    init (scheme: Scheme, host: Host, path: Path) {
        self.scheme = scheme
        self.host = host
        self.path = path
    }
    
    
    public func create() -> URL? {
        var urlComp = URLComponents()
        urlComp.scheme = scheme.rawValue
        urlComp.host = host.rawValue
        urlComp.path = path.rawValue
        guard let url = urlComp.url else { return nil }
//        guard let url = urlComp.url else { print("createURL() Error!"); return nil } // Некорректная обработка
        
        return url
    }
    
}




// MARK: - Request

public struct APIRequest {
    
    private let url: ApiURL
    private let method: HTTPMethod
    private let header: [String : String] // нужен кастомный объект для создания массива?
    private let body: [String : String]? // нужен кастомный объект для создания массива?
    
    
    private func JSONSerialize(obj: Any) throws -> Data {
        do {
            return try JSONSerialization.data(withJSONObject: obj, options: [])
        } catch {
            throw NetworkError.JSONSerialization(error.localizedDescription)
        }
    }
    
    enum HTTPMethod: String {
        case get     = "GET"
        case head    = "HEAD"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
        case trace   = "TRACE"
        case connect = "CONNECT"
    }
    
    
    init(url: ApiURL, method: HTTPMethod, header: [String : String], body: [String : String] = [:]) {
        self.url = url
        self.method = method
        self.header = header
        self.body = body
    }
    
    
     func create() throws -> URLRequest {

            guard let url = url.create() else { throw NetworkError.urlCreate("The URL cannot be configured") }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue
            urlRequest.setValue(header.values.first, forHTTPHeaderField: header.keys.first ?? "")
            guard let body = body else { return urlRequest }
            urlRequest.httpBody = try JSONSerialize(obj: body)
            return urlRequest
        //        do {
//        } catch let error {
//            throw error
//        }
//        guard let url = url.create() else { return nil }
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = method.rawValue
//        urlRequest.setValue(header.values.first, forHTTPHeaderField: header.keys.first ?? "")
//        guard let body = JSONSerialize(obj: body) else { return nil }
//        urlRequest.httpBody = body
//        // будет ли отрабатывать метод сериализации при пустом значении?
//        return urlRequest
    }
    
//    public func create(callback: (Result<Data, Error>) -> ()) -> URLRequest? {
//        do {
//            return try self.create()
//        } catch {
//            callback(.failure(error));
//            return nil
//        }
//    }
    
}


// MARK: - Session

public enum APISession {
    case `default`
    
    func create() -> URLSession {
        switch self {
        case .default:
            let session = URLSession(configuration: .default)
            return session
        }
    }
}



enum NetworkError: Error {
    case urlCreate (String)
    case JSONSerialization (String)
    case HTTPURLResponse (statusCode: Int, data: Data?)
    
//    case requestError // временная мера! Не получается обработать url / serialize ошибки в методе execute NetworkRepository
    
}

