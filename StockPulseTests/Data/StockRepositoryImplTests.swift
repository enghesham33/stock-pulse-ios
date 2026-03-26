import XCTest
@testable import StockPulse
import Swinject

final class StockRepositoryImplTests: XCTestCase {

    func test_fetchMarketStocks_callsExpectedEndpointAndMapsToDomain() async throws {
        let repo = DIContainer.shared.container.resolve(StockRepository.self, name: "mockMarketStocksAPI")
        let stocks = try await repo?.fetchMarketStocks()

        XCTAssertEqual(stocks?.first?.symbol, "^GSPC")
        XCTAssertFalse(stocks?.isEmpty ?? true)
    }

    func test_fetchStockDetails_withMockedResponse_returnsWebsite() async throws {
        
        let stock = Stock(symbol: "^GSPC", name: "S&P 500", price: 4000.0, changePercentage: 1.25)
        let repo = DIContainer.shared.container.resolve(StockRepository.self, name: "mockStockDetailsAPI")
        let details = try await repo?.fetchStockDetails(stock: stock)
        XCTAssertEqual(details?.website, "https://www.amarincorp.com")
    }
}

