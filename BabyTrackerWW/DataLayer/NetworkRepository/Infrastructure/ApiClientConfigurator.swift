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
    
    private let scheme: Scheme
    private let host: Host
    private let path: Path
    private let endPoint: [EndPointKeys : String]?
    
    
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
    enum EndPointKeys: String {
        case date = "date"
        case id = "id"
    }
    
    
    init(scheme: Scheme, host: Host, path: Path, endPoint: [EndPointKeys : String]) {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.endPoint = endPoint
    }
    
    
    func createURL() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme.rawValue
        urlComponents.host = host.rawValue
        urlComponents.path = path.rawValue
        endPoint?.forEach { urlComponents.queryItems?.append(URLQueryItem(name: $0.key.rawValue, value: $0.value)) } // Потестить в консоле!!
        print("urlComp == \(urlComponents.description)")
        guard let url = urlComponents.url else { return nil }
        return url
    }
    
}


// MARK: - Request

struct APIRequest {
    
    private let url: ApiURL
    private let method: HTTPMethod
    private let header: [String : String] // нужен кастомный объект для создания массива?
    private let body: [BodyKeys : BodyValues]? // нужен кастомный объект для создания массива?
    
    enum BodyValues {
        case dream (DreamNetworkEntity)
        case wake (WakeNetworkEntity)
        case str (String)
    }
    enum BodyKeys: String {
        case dream = "dream"
        case wake = "wake"
    }
    
    private func JSONSerialize(obj: Any) throws -> Data {
        do {
            return try JSONSerialization.data(withJSONObject: obj, options: [])
        } catch {
            throw NetworkError.jsonSerialization(error.localizedDescription)
        }
    }
    
//    private func JSONEncoderR <T: Encodable> (encoder: T) throws -> Data {
//        return try JSONEncoder().encode(encoder)
//    }
    
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
    
    
    init(url: ApiURL, method: HTTPMethod, header: [String : String], body: [BodyKeys : BodyValues]? = nil) { // посмотреть инит дефолт значения нил
        self.url = url
        self.method = method
        self.header = header
        self.body = body
    }
    
    
    func createRequest() throws -> URLRequest {
        
        guard let url = url.createURL() else { throw NetworkError.urlCreate("The URL cannot be configured") }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        header.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
//        urlRequest.setValue(header.values.first, forHTTPHeaderField: header.keys.first ?? "")
        guard let body = body, JSONSerialization.isValidJSONObject(body) else { return urlRequest } // проверка на валидность избыточна, сделал только для теста
        urlRequest.httpBody = try JSONSerialize(obj: body)
        return urlRequest
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
}

