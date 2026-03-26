//
//  MockAPIClient.swift
//  StockPulse
//
//  Created by Hesham Khaled on 25/03/2026.
//

import Foundation

final class MockAPIClient: APIClientProtocol {
    
    /// Mocked JSON response as Data
    var mockedData: Data?
    
    /// Optional error to simulate network failures
    var mockedError: Error?
    
    init(mockedData: Data? = nil, mockedError: Error? = nil) {
        self.mockedData = mockedData
        self.mockedError = mockedError
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        if let error = mockedError {
            throw error
        }
        
        guard let data = mockedData else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
