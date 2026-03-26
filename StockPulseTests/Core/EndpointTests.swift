import XCTest
@testable import StockPulse

final class EndpointTests: XCTestCase {
    func test_url_buildsExpectedURL_withoutQueryItems() {
        let endpoint = Endpoint(path: getMarketSummaryApiPath)

        XCTAssertEqual(endpoint.url.scheme, urlScheme)
        XCTAssertEqual(endpoint.url.host, apiHost)
        XCTAssertEqual(endpoint.url.path, getMarketSummaryApiPath)
        XCTAssertNil(URLComponents(url: endpoint.url, resolvingAgainstBaseURL: false)?.queryItems)
    }

    func test_url_buildsExpectedURL_withQueryItems() {
        let endpoint = Endpoint(
            path: getStockDetailsApiPath,
            queryItems: [
                URLQueryItem(name: "symbol", value: "AAPL"),
                URLQueryItem(name: "region", value: "US")
            ]
        )

        let components = URLComponents(url: endpoint.url, resolvingAgainstBaseURL: false)
        XCTAssertEqual(components?.scheme, urlScheme)
        XCTAssertEqual(components?.host, apiHost)
        XCTAssertEqual(components?.path, getStockDetailsApiPath)

        let queryItems = components?.queryItems ?? []
        XCTAssertTrue(queryItems.contains(URLQueryItem(name: "symbol", value: "AAPL")))
        XCTAssertTrue(queryItems.contains(URLQueryItem(name: "region", value: "US")))
    }

    func test_headers_includeRapidAPIHostAndKey() {
        let endpoint = Endpoint(path: getMarketSummaryApiPath, method: .GET)
        let headers = endpoint.headers

        XCTAssertEqual(headers["X-RapidAPI-Host"], apiHost)
        XCTAssertNotNil(headers["X-RapidAPI-Key"])
        XCTAssertNil(headers["Content-Type"])
    }

    func test_headers_includeContentType_forNonGET() {
        let endpoint = Endpoint(path: "/anything", method: .POST)
        let headers = endpoint.headers

        XCTAssertEqual(headers["Content-Type"], contentType)
    }
}

