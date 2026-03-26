//
//  StockDetailsDTO.swift
//  StockPulse
//
//  Created by Hesham Khaled on 26/03/2026.
//

import Foundation

import Foundation

struct StockProfileResponseDTO: Decodable {
    let quoteSummary: QuoteSummaryDTO?
}

struct QuoteSummaryDTO: Decodable {
    let result: [StockProfileResultDTO]?
    let error: APIErrorDTO?
}

struct StockProfileResultDTO: Decodable {
    let summaryProfile: SummaryProfileDTO?
}

struct SummaryProfileDTO: Decodable {
    let name: String?
    let website: String?
    let twitter: String?
    let startDate: String?
    let description: String?
    let longBusinessSummary: String?  
    let industry: String?
    let sector: String?
    let fullTimeEmployees: Int?
    let address1: String?
    let address2: String?
    let city: String?
    let zip: String?
    let country: String?
    
    // Optional documents / links
    let whitepaper: String?
    let irWebsite: String?
    
    // Executive / officer info
    let companyOfficers: [CompanyOfficerDTO]?
    let executiveTeam: [ExecutiveDTO]?
    
    let maxAge: Int?
}

// MARK: - Officers / Executives
struct CompanyOfficerDTO: Decodable {
    let name: String?
    let title: String?
    let pay: String?
}

struct ExecutiveDTO: Decodable {
    let name: String?
    let title: String?
    let pay: String?
}

extension StockProfileResponseDTO {
    
    func toDomain(with stock: Stock) throws -> StockDetails {
        
        if let errorMessage = quoteSummary?.error?.description {
            throw NetworkError.apiError(errorMessage)
        }
        guard let profile = quoteSummary?.result?.first?.summaryProfile else {
            throw NetworkError.apiError("No profile data available")
        }
        
        return profile.toDomain(stock: stock)
    }
}
