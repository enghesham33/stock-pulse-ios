//
//  StockRepositoryImpl.swift
//  StockPulse
//
//  Created by Hesham Khaled on 25/03/2026.
//

import Foundation

struct StockRepositoryImpl: StockRepository {
    
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchMarketStocks() async throws -> [Stock] {
        let endpoint = Endpoint(path: getMarketSummaryApiPath, method: .GET)
        let response: MarketSummaryResponseDTO = try await apiClient.request(endpoint)
        return response.marketSummaryAndSparkResponse.result?.map { $0.toDomain() } ?? []
    }
    
    func fetchStockDetails(stock: Stock) async throws -> StockDetails {
        let endpoint = Endpoint(
            path: getStockDetailsApiPath,
            method: .GET,
            queryItems: [
                URLQueryItem(name: "symbol", value: stock.symbol),
                URLQueryItem(name: "region", value: "US")
            ]
        )
        
        let response: StockProfileResponseDTO = try await apiClient.request(endpoint)
        return try response.toDomain(with: stock)
    }
}
