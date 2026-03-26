//
//  Stock.swift
//  StockPulse
//
//  Created by Hesham Khaled on 25/03/2026.
//

import Foundation

struct Stock: Identifiable, Hashable {
    let id = UUID()
    let symbol: String
    let name: String
    let price: Double
    let changePercentage: Double
}

extension QuoteDTO {
    func toDomain() -> Stock {
        let price = regularMarketPrice?.raw ?? 0
        let previousClose = regularMarketPreviousClose?.raw ?? 0
        let changePercent = previousClose != 0 ? ((price - previousClose)/previousClose) * 100 : 0
        
        return Stock(
            symbol: symbol ?? "",
            name: shortName ?? symbol ?? "",
            price: price,
            changePercentage: changePercent
        )
    }
}
