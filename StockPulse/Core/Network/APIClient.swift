//
//  APIClient.swift
//  StockPulse
//
//  Created by Hesham Khaled on 25/03/2026.
//

import Foundation

final class APIClient: APIClientProtocol {
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        
        // Add headers
        endpoint.headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        do {
            // Perform network request
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Ensure valid HTTP response
            guard let httpResponse = response as? HTTPURLResponse,
                  200...299 ~= httpResponse.statusCode else {
                throw NetworkError.invalidResponse
            }
            
            // Decode JSON
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return decoded
            } catch {
                throw NetworkError.decodingError(error)
            }
            
        } catch {
            throw NetworkError.unknown(error)
        }
    }
}
