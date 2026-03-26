//
//  DIContainer.swift
//  StockPulse
//
//  Created by Hesham Khaled on 25/03/2026.
//

import Foundation
import Swinject

final class DIContainer {
    
    static let shared = DIContainer()
    let container: Container
    
    private init() {
        container = Container()
        registerCore()
        registerRepositories()
        registerViewModels()
    }
    
    // MARK: - Core Dependencies
    private func registerCore() {
        container.register(APIClientProtocol.self) { _ in
            APIClient()
        }.inObjectScope(.container)
        
        container.register(APIClientProtocol.self, name: "mockMarketStocksAPI") { _ in
            let data = jsonResponse.data(using: .utf8)
            return MockAPIClient(mockedData: data)
        }.inObjectScope(.container)
        
        container.register(APIClientProtocol.self, name: "mockStockDetailsAPI") { _ in
            let data = stockDetailsJson.data(using: .utf8)
            return MockAPIClient(mockedData: data)
        }.inObjectScope(.container)
    }
    
    // MARK: - Repositories
    private func registerRepositories() {
        container.register(StockRepository.self) { resolver in
            let apiClient = resolver.resolve(APIClientProtocol.self)!
            return StockRepositoryImpl(apiClient: apiClient)
        }.inObjectScope(.container)
        
        container.register(StockRepository.self, name: "mockMarketStocksAPI") { resolver in
            let apiClient = resolver.resolve(APIClientProtocol.self, name: "mockMarketStocksAPI")!
            return StockRepositoryImpl(apiClient: apiClient)
        }.inObjectScope(.container)
        
        container.register(StockRepository.self, name: "mockStockDetailsAPI") { resolver in
            let apiClient = resolver.resolve(APIClientProtocol.self, name: "mockStockDetailsAPI")!
            return StockRepositoryImpl(apiClient: apiClient)
        }.inObjectScope(.container)
    }
    
    // MARK: - ViewModels
    private func registerViewModels() {
        container.register(StockListViewModel.self) { resolver in
            let repository = resolver.resolve(StockRepository.self)!
            return StockListViewModel(repository: repository)
        }
        
        container.register(StockListViewModel.self, name: "mockMarketStocksAPI") { resolver in
            let repository = resolver.resolve(StockRepository.self, name: "mockMarketStocksAPI")!
            return StockListViewModel(repository: repository)
        }
        
        container.register(StockDetailsViewModel.self) { (resolver, stock) in
            let repository = resolver.resolve(StockRepository.self)!
            return StockDetailsViewModel(stock: stock, repository: repository)
        }
        
        container.register(StockDetailsViewModel.self, name: "mockStockDetailsAPI") { (resolver, stock) in
            let repository = resolver.resolve(StockRepository.self, name: "mockStockDetailsAPI")!
            return StockDetailsViewModel(stock: stock, repository: repository)
        }
    }
}
