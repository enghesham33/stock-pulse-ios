//
//  StockDetailsViewModel.swift
//  StockPulse
//
//  Created by Hesham Khaled on 26/03/2026.
//

import Foundation
import Combine

@MainActor
final class StockDetailsViewModel: ObservableObject {
    
    @Published var details: StockDetails?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let repository: StockRepository
    private let stock: Stock
    
    init(stock: Stock, repository: StockRepository) {
        self.stock = stock
        self.repository = repository
        
        // Initialize with basic data from the list
        self.details = StockDetails(
            name: stock.name,
            symbol: stock.symbol,
            price: stock.price,
            changePercentage: stock.changePercentage,
            website: nil,
            twitter: nil,
            description: nil,
            industry: nil,
            sector: nil,
            employees: nil,
            address: nil,
            country: nil,
            whitepaper: nil,
            irWebsite: nil
        )
    }
    
    func fetchDetails() async {
        isLoading = true
        do {
            let result = try await repository.fetchStockDetails(stock: stock)
            // Merge result with initial values
            details = StockDetails(
                name: result.name,
                symbol: stock.symbol,
                price: stock.price,
                changePercentage: stock.changePercentage,
                website: result.website,
                twitter: result.twitter,
                description: result.description,
                industry: result.industry,
                sector: result.sector,
                employees: result.employees,
                address: result.address,
                country: result.country,
                whitepaper: result.whitepaper,
                irWebsite: result.irWebsite
            )
            isLoading = false
        } catch let error as NetworkError {
            isLoading = false
            switch error {
            case .apiError(let message):
                errorMessage = message
            default:
                errorMessage = "Something went wrong"
            }
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
}
