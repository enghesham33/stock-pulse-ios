//
//  StockRepository.swift
//  StockPulse
//
//  Created by Hesham Khaled on 25/03/2026.
//

import Foundation

protocol StockRepository {
    func fetchMarketStocks() async throws -> [Stock]
    func fetchStockDetails(stock: Stock) async throws -> StockDetails
}
