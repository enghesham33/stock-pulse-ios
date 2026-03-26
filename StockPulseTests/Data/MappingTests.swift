import XCTest
@testable import StockPulse

final class MappingTests: XCTestCase {
    func test_quoteDTO_toDomain_calculatesChangePercent() throws {
        let data = try XCTUnwrap(jsonResponse.data(using: .utf8))
        let decoded = try JSONDecoder().decode(MarketSummaryResponseDTO.self, from: data)
        let firstQuote = try XCTUnwrap(decoded.marketSummaryAndSparkResponse.result?.first)

        let stock = firstQuote.toDomain()

        let price = firstQuote.regularMarketPrice?.raw ?? 0
        let previousClose = firstQuote.regularMarketPreviousClose?.raw ?? 0
        let expected = previousClose != 0 ? ((price - previousClose) / previousClose) * 100 : 0

        XCTAssertEqual(stock.symbol, "^GSPC")
        XCTAssertEqual(stock.name, "S&P 500")
        XCTAssertEqual(stock.price, price)
        XCTAssertEqual(stock.changePercentage, expected)
    }

    func test_quoteDTO_toDomain_whenPreviousCloseZero_setsChangePercentToZero() throws {
        let json = """
        {
          "fullExchangeName": null,
          "symbol": "ABC",
          "shortName": null,
          "regularMarketPrice": { "raw": 110, "fmt": null },
          "regularMarketPreviousClose": { "raw": 0, "fmt": null },
          "spark": null
        }
        """
        let dto = try JSONDecoder().decode(QuoteDTO.self, from: Data(json.utf8))

        let stock = dto.toDomain()
        XCTAssertEqual(stock.changePercentage, 0)
    }

    func test_summaryProfileDTO_toDomain_buildsFullAddressOnlyWhenAllPartsPresent() throws {
        let data = try XCTUnwrap(stockDetailsJson.data(using: .utf8))
        let decoded = try JSONDecoder().decode(StockProfileResponseDTO.self, from: data)
        let profile = try XCTUnwrap(decoded.quoteSummary?.result?.first?.summaryProfile)

        let stock = Stock(symbol: "A", name: "Name", price: 1, changePercentage: 2)
        let details = profile.toDomain(stock: stock)

        XCTAssertEqual(details.address, "One Central Plaza, 8th Floor 36 Dame Street, Dublin D02 K7K5")
        XCTAssertNotNil(details.description)
    }

    func test_stockProfileResponseDTO_toDomain_whenAPIError_throwsNetworkErrorApiError() throws {
        let json = """
        {
          "quoteSummary": {
            "result": null,
            "error": { "code": "Bad", "description": "Nope" }
          }
        }
        """
        let dto = try JSONDecoder().decode(StockProfileResponseDTO.self, from: Data(json.utf8))

        do {
            _ = try dto.toDomain(with: Stock(symbol: "A", name: "N", price: 1, changePercentage: 1))
            XCTFail("Expected error")
        } catch let error as NetworkError {
            switch error {
            case .apiError(let message):
                XCTAssertEqual(message, "Nope")
            default:
                XCTFail("Unexpected NetworkError: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_stockProfileResponseDTO_toDomain_whenMissingProfile_throwsApiError() throws {
        let json = """
        {
          "quoteSummary": {
            "result": [],
            "error": null
          }
        }
        """
        let dto = try JSONDecoder().decode(StockProfileResponseDTO.self, from: Data(json.utf8))

        do {
            _ = try dto.toDomain(with: Stock(symbol: "A", name: "N", price: 1, changePercentage: 1))
            XCTFail("Expected error")
        } catch let error as NetworkError {
            switch error {
            case .apiError(let message):
                XCTAssertEqual(message, "No profile data available")
            default:
                XCTFail("Unexpected NetworkError: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}

