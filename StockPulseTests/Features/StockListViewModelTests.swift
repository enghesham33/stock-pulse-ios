import XCTest
@testable import StockPulse
import Swinject

final class StockListViewModelTests: XCTestCase {
    private var mockAPIClient: MockAPIClient?
    private var vm: StockListViewModel?
    
    @MainActor
    override func setUpWithError() throws {
        mockAPIClient = (DIContainer.shared.container
            .resolve(APIClientProtocol.self, name: "mockMarketStocksAPI") as! MockAPIClient)
        mockAPIClient?.mockedData = jsonResponse.data(using: .utf8)
        mockAPIClient?.mockedError = nil
        let repo = StockRepositoryImpl(apiClient: mockAPIClient!)
        vm = StockListViewModel(repository: repo)
    }
    
    override func tearDown() {
        mockAPIClient?.mockedData = nil
        mockAPIClient?.mockedError = nil
        mockAPIClient = nil
        super.tearDown()
    }

    @MainActor
    func test_fetchStocks_success_updatesStocksAndClearsError() async {

        // init triggers an async fetch
        try? await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertFalse(vm?.stocks.isEmpty ?? true)
        XCTAssertEqual(vm?.stocks.first?.symbol, "^GSPC")
        XCTAssertNil(vm?.errorMessage)
        XCTAssertFalse(vm?.isLoading ?? false)
    }

    @MainActor
    func test_fetchStocks_failure_setsErrorMessageAndStopsLoading() async {
        struct DummyError: LocalizedError {
            var errorDescription: String? { "No internet" }
        }
        mockAPIClient?.mockedError = DummyError()
        let repo = StockRepositoryImpl(apiClient: mockAPIClient!)
        let vm = StockListViewModel(repository: repo)

        // init triggers an async fetch
        try? await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertEqual(vm.stocks.count, 0)
        XCTAssertEqual(vm.errorMessage, "No internet")
        XCTAssertFalse(vm.isLoading ?? false)
    }

    @MainActor
    func test_filteredStocks_whenSearchTextEmpty_returnsAllStocks() {
        
        mockAPIClient?.mockedData = jsonResponse.data(using: .utf8)
        mockAPIClient?.mockedError = nil
        
        vm?.stocks = [
            Stock(symbol: "A", name: "Apple", price: 1, changePercentage: 1),
            Stock(symbol: "B", name: "Tesla", price: 1, changePercentage: 1)
        ]

        vm?.searchText = ""
        XCTAssertEqual(vm?.filteredStocks.count ?? 0, 2)
    }

    @MainActor
    func test_filteredStocks_filtersByName_caseInsensitive() {
        mockAPIClient?.mockedData = jsonResponse.data(using: .utf8)
        mockAPIClient?.mockedError = nil

        
        vm?.stocks = [
            Stock(symbol: "A", name: "Apple", price: 1, changePercentage: 1),
            Stock(symbol: "B", name: "Tesla", price: 1, changePercentage: 1)
        ]

        vm?.searchText = "app"
        XCTAssertEqual(vm?.filteredStocks.map(\.symbol), ["A"])
    }
}

