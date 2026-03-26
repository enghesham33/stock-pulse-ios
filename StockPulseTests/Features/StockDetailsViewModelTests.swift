import XCTest
@testable import StockPulse
import Swinject

final class StockDetailsViewModelTests: XCTestCase {
    private var mockAPIClient: MockAPIClient?
    private var stock: Stock?
    private var vm: StockDetailsViewModel?

    @MainActor
    override func setUpWithError() throws {
        stock = Stock(symbol: "^GSPC", name: "S&P 500", price: 4000.0, changePercentage: 1.25)

        mockAPIClient = (DIContainer.shared.container
            .resolve(APIClientProtocol.self, name: "mockStockDetailsAPI") as! MockAPIClient)
        mockAPIClient?.mockedData = stockDetailsJson.data(using: .utf8)
        mockAPIClient?.mockedError = nil

        let repo = StockRepositoryImpl(apiClient: mockAPIClient!)
        vm = StockDetailsViewModel(stock: stock!, repository: repo)
    }

    override func tearDown() {
        mockAPIClient?.mockedData = nil
        mockAPIClient?.mockedError = nil
        mockAPIClient = nil
        stock = nil
        super.tearDown()
    }

    @MainActor
    func test_init_seedsDetailsFromStock() {
        XCTAssertEqual(vm?.details?.name, stock?.name)
        XCTAssertEqual(vm?.details?.symbol, stock?.symbol)
        XCTAssertEqual(vm?.details?.price, stock?.price)
        XCTAssertEqual(vm?.details?.changePercentage, stock?.changePercentage)
        XCTAssertNil(vm?.details?.website)
        XCTAssertNil(vm?.errorMessage)
    }

    @MainActor
    func test_fetchDetails_success_mergesAPIProfileIntoSeededDetails() async {
        await vm?.fetchDetails()

        XCTAssertEqual(vm?.details?.symbol, stock?.symbol)
        XCTAssertEqual(vm?.details?.price, stock?.price) // keeps list price
        XCTAssertEqual(vm?.details?.changePercentage, stock?.changePercentage)
        XCTAssertEqual(vm?.details?.website, "https://www.amarincorp.com")
        XCTAssertNil(vm?.errorMessage)
        XCTAssertFalse(vm?.isLoading ?? false)
    }

    @MainActor
    func test_fetchDetails_whenNetworkApiError_setsMessageFromError() async {
        mockAPIClient?.mockedData = nil
        mockAPIClient?.mockedError = NetworkError.apiError("Rate limit")

        await vm?.fetchDetails()

        XCTAssertEqual(vm?.errorMessage, "Rate limit")
        XCTAssertFalse(vm?.isLoading ?? false)
    }

    @MainActor
    func test_fetchDetails_whenOtherNetworkError_setsGenericMessage() async {
        mockAPIClient?.mockedData = nil
        mockAPIClient?.mockedError = NetworkError.invalidResponse

        await vm?.fetchDetails()

        XCTAssertEqual(vm?.errorMessage, "Something went wrong")
        XCTAssertFalse(vm?.isLoading ?? false)
    }
}

