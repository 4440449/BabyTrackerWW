//
//  ApiClientConfigurator.swift
//  BabyTrackerWW
//
//  Created by Max on 18.10.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation

// MARK: - URL

struct ApiURL {
    
    private let scheme: String
    private let host: String
    private let path: String
    private let endPoint: [String : String]?
    
    
    enum Scheme: String {
        case http  = "http"
        case https = "https"
    }
    enum Host: String {
        case supabase = "lgrxdkchkrkunwoqiwtl.supabase.co"
    }
    enum Path: String {
        case dream = "/rest/v1/Dream"
        case wake  = "/rest/v1/Wake"
    }
    enum EndPointKeys: String { // контроль знака равно при генерации урла
        case date = "date"
        case id = "id"
    }
    
    // LifeCycle API init
    init(scheme: Scheme, host: Host, path: Path, endPoint: [EndPointKeys : String]?) {
        self.scheme = scheme.rawValue
        self.host = host.rawValue
        self.path = path.rawValue
        guard endPoint != nil else { self.endPoint = nil; return }
        self.endPoint = Dictionary(uniqueKeysWithValues: endPoint!.map ({($0.key.rawValue, $0.value) }))
        print("endPoint == \(endPoint)")
    }
    //    external init
    init(scheme: Scheme, host: String, path: String, endPoint: [String : String]?) {
        self.scheme = scheme.rawValue
        self.host = host
        self.path = path
        guard endPoint != nil else { self.endPoint = nil; return }
        self.endPoint = endPoint
    }
    
    
    func createURL() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        if let endPoint = endPoint { urlComponents.queryItems = []; endPoint.forEach {
            urlComponents.queryItems?.append(URLQueryItem(name: $0.key, value: $0.value))
            }
        }
        print("urlComp == \(urlComponents.description)")
        print("queryItems == \(urlComponents.queryItems)")
        guard let url = urlComponents.url else { return nil }
        return url
    }
    
}


// MARK: - Request

struct APIRequest {
    
    private let url: ApiURL
    //Инкапсулировать поля запроса в отдельный объект?
    private let method: String
    private let header: [String : String]
    private var body: Codable?
    
    enum BodyKeys: String {
        case dream = "dream"
        case wake = "wake"
    }
    
    enum HTTPMethod: String {
        case get     = "GET"
        case post    = "POST"
        case delete  = "DELETE"
    }
    
    // LifeCycle API init
    init(url: ApiURL, method: HTTPMethod, header: [String : String], body: Codable?) {
        self.url = url
        self.method = method.rawValue
        self.header = header
        guard body != nil else { self.body = nil; return }
        self.body = body
//        self.body = Dictionary(uniqueKeysWithValues: body!.map ({ ($0.key.rawValue, $0.value) })) // force!
    }
    
    // external init
//    init(url: ApiURL, method: String, header: [String : String], body: [String : Codable]?) {
//        self.url = url
//        self.method = method
//        self.header = header
//        guard body != nil else { self.body = nil; return }
////        self.body = body
//    }
    
    
    func createRequest() throws -> URLRequest {
        
        guard let url = url.createURL() else { throw NetworkError.urlCreate("The URL cannot be configured") }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        header.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
        //        urlRequest.setValue(header.values.first, forHTTPHeaderField: header.keys.first ?? "")
        guard let body = body else { return urlRequest }
        print("Is json valid object? \(JSONSerialization.isValidJSONObject(body))")
        urlRequest.httpBody = try JSONEncoder().encode(body as! DreamNetworkEntity)
//            try JSONSerialize(obj: body)
        print("urlRequest.httpBody == \(urlRequest.httpBody!)")
        //        print("httpBody == \(urlRequest.httpBody)")
        return urlRequest
    }
    
    
    //    private func JSONEncoderR <T: Encodable> (encoder: T) throws -> Data {
    //        return try JSONEncoder().encode(encoder)
    //    }
    
    
    private func JSONSerialize(obj: Any) throws -> Data {
        do {
            return try JSONSerialization.data(withJSONObject: obj, options: [])
        } catch {
            throw NetworkError.jsonSerialization(error.localizedDescription)
        }
    }
    
}


// MARK: - Session

enum APISession {
    case `default`
    
    func createSession() -> URLSession {
        switch self {
        case .default:
            let session = URLSession(configuration: .default)
            return session
        }
    }
}


// MARK: - Errors

enum NetworkError: Error {
    case urlCreate (String)
    case jsonSerialization (String)
    
    case badRequest (String)
    case badResponse (String)
    
    case parseToDomain (String)
    
    case downcasting (String)
}






struct ApiParams {
    
    let url: ApiURL
    let header: [String : String]
    let body: [String : Codable]?
    
    
    enum HeaderKey: String {
        case apiKey = "apiKey"
    }
    
    
    init(url: ApiURL, header: [HeaderKey : String], body: [String : Codable]?) {
        self.url = url
        self.header = Dictionary(uniqueKeysWithValues: header.map ({($0.key.rawValue, $0.value) }))
        guard body != nil else { self.body = nil; return }
        self.body = body
    }
    
    
    init(url: ApiURL, header: [String : String], body: [String : Codable]?) {
        self.url = url
        self.header = header
        guard body != nil else { self.body = nil; return }
        self.body = body
    }
    
}
