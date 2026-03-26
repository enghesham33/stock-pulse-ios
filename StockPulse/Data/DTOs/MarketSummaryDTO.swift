//
//  MarketSummaryDTO.swift
//  StockPulse
//
//  Created by Hesham Khaled on 25/03/2026.
//

import Foundation

// MARK: - Root Response
struct MarketSummaryResponseDTO: Decodable {
    let marketSummaryAndSparkResponse: MarketSummaryAndSparkResponseDTO
}

struct MarketSummaryAndSparkResponseDTO: Decodable {
    let result: [QuoteDTO]?
    let error: APIErrorDTO?
}

// MARK: - Quote
struct QuoteDTO: Decodable {
    let fullExchangeName: String?
    let symbol: String?
    let shortName: String?
    let regularMarketPrice: PriceDTO?
    let regularMarketPreviousClose: PriceDTO?
    let spark: SparkDTO?
    
    struct PriceDTO: Decodable {
        let raw: Double?
        let fmt: String?
    }
    
    struct SparkDTO: Decodable {
        let timestamp: [Int]?
        let close: [Double]?
        let previousClose: Double?
        let chartPreviousClose: Double?
        let dataGranularity: Int?
        let start: Int?
        let end: Int?
        let symbol: String?
    }
}
