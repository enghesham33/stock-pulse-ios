//
//  NetworkError.swift
//  StockPulse
//
//  Created by Hesham Khaled on 25/03/2026.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case decodingError(Error)
    case apiError(String)
    case unknown(Error)
}
