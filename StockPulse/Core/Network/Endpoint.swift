//
//  Endpoint.swift
//  StockPulse
//
//  Created by Hesham Khaled on 25/03/2026.
//

import Foundation



struct Endpoint {
    let path: String
    let method: HTTPMethod
    let queryItems: [URLQueryItem]
    let body: Data?
    
    init(
        path: String,
        method: HTTPMethod = .GET,
        queryItems: [URLQueryItem] = [],
        body: Data? = nil
    ) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.body = body
    }
    
    var url: URL {
        var components = URLComponents()
        components.scheme = urlScheme
        components.host = apiHost
        components.path = path
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        
        guard let url = components.url else {
            fatalError("Invalid URL for endpoint: \(path)")
        }
        return url
    }
    
    var headers: [String: String] {
        let apiKey = ProcessInfo.processInfo.environment["RAPIDAPI_KEY"] ?? ""
        var headers = [
            "X-RapidAPI-Key": apiKey,
            "X-RapidAPI-Host": apiHost
        ]
        if method != .GET {
            headers["Content-Type"] = contentType
        }
        
        return headers
    }
}
