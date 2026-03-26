import XCTest
@testable import StockPulse
import Swinject

final class MockAPIClientTests: XCTestCase {

    private func resolveMockMarketClient() -> MockAPIClient {
        DIContainer.shared.container
            .resolve(APIClientProtocol.self, name: "mockMarketStocksAPI") as! MockAPIClient
    }

    private func resolveMockDetailsClient() -> MockAPIClient {
        DIContainer.shared.container
            .resolve(APIClientProtocol.self, name: "mockStockDetailsAPI") as! MockAPIClient
    }

    func test_request_decodesResponse() async throws {
        let client = resolveMockMarketClient()
        client.mockedData = jsonResponse.data(using: .utf8)
        client.mockedError = nil

        let endpoint = Endpoint(path: "/any")

        let decoded: MarketSummaryResponseDTO = try await client.request(endpoint)
        let firstSymbol = decoded.marketSummaryAndSparkResponse.result?.first?.symbol
        XCTAssertEqual(firstSymbol, "^GSPC")
    }

    func test_request_throwsInjectedError() async {
        let client = resolveMockMarketClient()
        client.mockedData = jsonResponse.data(using: .utf8)
        client.mockedError = NetworkError.apiError("boom")

        let endpoint = Endpoint(path: "/any")

        do {
            let _: MarketSummaryResponseDTO = try await client.request(endpoint)
            XCTFail("Expected error")
        } catch let error as NetworkError {
            switch error {
            case .apiError(let message):
                XCTAssertEqual(message, "boom")
            default:
                XCTFail("Unexpected NetworkError: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_request_withoutData_throwsInvalidResponse() async {
        let client = resolveMockDetailsClient()
        client.mockedData = nil
        client.mockedError = nil

        let endpoint = Endpoint(path: "/any")

        do {
            let _: StockProfileResponseDTO = try await client.request(endpoint)
            XCTFail("Expected error")
        } catch let error as NetworkError {
            switch error {
            case .invalidResponse:
                XCTAssertTrue(true)
            default:
                XCTFail("Unexpected NetworkError: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_request_withBadJSON_throwsDecodingError() async {
        let client = resolveMockDetailsClient()
        client.mockedData = Data("not json".utf8)
        client.mockedError = nil

        let endpoint = Endpoint(path: "/any")

        do {
            let _: StockProfileResponseDTO = try await client.request(endpoint)
            XCTFail("Expected error")
        } catch let error as NetworkError {
            switch error {
            case .decodingError:
                XCTAssertTrue(true)
            default:
                XCTFail("Unexpected NetworkError: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}

