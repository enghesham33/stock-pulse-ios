//
//  StockDetails.swift
//  StockPulse
//
//  Created by Hesham Khaled on 26/03/2026.
//

import Foundation

struct StockDetails {
    // MARK: - Basic info from list
    let name: String
    let symbol: String?
    let price: Double?
    let changePercentage: Double?
    
    // MARK: - Profile info from API
    let website: String?
    let twitter: String?
    let description: String?
    let industry: String?
    let sector: String?
    let employees: Int?
    let address: String?
    let country: String?
    
    // MARK: - Optional docs / links
    let whitepaper: String?
    let irWebsite: String?
}

extension SummaryProfileDTO {
    func toDomain(stock: Stock) -> StockDetails {
        let fullAddress: String? = {
            if let a1 = address1, let a2 = address2, let c = city, let z = zip {
                return "\(a1), \(a2), \(c) \(z)"
            }
            return nil
        }()
        
        return StockDetails(
            name: stock.name,
            symbol: stock.symbol,
            price: stock.price,
            changePercentage: stock.changePercentage,
            website: website,
            twitter: twitter,
            description: description ?? longBusinessSummary,
            industry: industry,
            sector: sector,
            employees: fullTimeEmployees,
            address: fullAddress,
            country: country,
            whitepaper: whitepaper,
            irWebsite: irWebsite
        )
    }
}
