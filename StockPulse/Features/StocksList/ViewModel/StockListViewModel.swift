//
//  StockListViewModel.swift
//  StockPulse
//
//  Created by Hesham Khaled on 25/03/2026.
//

import Foundation
import Combine

@MainActor
final class StockListViewModel: ObservableObject {
    
    // MARK: - Dependencies
    private let repository: StockRepository
    
    // MARK: - Published Properties
    @Published var stocks: [Stock] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var timer: Timer?
    
    // MARK: - Init
    init(repository: StockRepository) {
        self.repository = repository
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Fetch Stocks
    func fetchStocks() async {
        isLoading = true
        do {
            let fetchedStocks = try await repository.fetchMarketStocks()
            stocks = fetchedStocks
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Timer Control
    func startTimer() {
        guard timer == nil else { return } // prevent duplicate timers
        
        timer = Timer.scheduledTimer(withTimeInterval: 8.0, repeats: true) { [weak self] _ in
            Task {
                await self?.fetchStocks()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Filtered Stocks
    var filteredStocks: [Stock] {
        if searchText.isEmpty {
            return stocks
        } else {
            return stocks.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
