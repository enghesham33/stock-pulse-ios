#StockPulse iOS App

##App Flow
- User opens the app → sees a list of stocks.
- User selects a stock → navigates to StockDetailsView.
- StockDetailsView fetches detailed info about the selected stock using the Yahoo Finance API.
- ViewModels manage the state and bind data to SwiftUI Views.
- Repositories handle fetching and mapping data from the network layer to domain models.
- APIClient handles HTTP requests and JSON decoding.

##APIs Used
1. Stock List
- Endpoint: /market/v2/get-summary
- Parameters:
    - symbol: Stock symbol (e.g., AAPL, GOOGL)
    - region: US
- Response: JSON with basic stock info, e.g., symbol, price, change, etc.

2. Stock Details
- Endpoint: /stock/v3/get-profile
- Parameters:
    - symbol: Stock symbol
    - region: US
- Response: JSON with quoteSummary.result → summaryProfile, including: address, city, zip, country industry, sector, longBusinessSummary, fullTimeEmployees, companyOfficers and executiveTeam
- Error Handling: If the symbol doesn’t exist, the API returns:
{
  "quoteSummary": {
    "result": null,
    "error": {
      "code": "Not Found",
      "description": "No fundamentals data found for symbol: XYZ"
    }
  }
}

- The app gracefully handles this by showing an error state in the UI.

##Layers & Responsibilities
1. UI Layer
- SwiftUI Views: StockListView, StockRowView, StockDetailsView.
- Observes ViewModels and reacts to state changes.

2. ViewModel Layer
- StockListViewModel → manages list of stocks.
- StockDetailsViewModel → fetches and holds stock profile data.
- Exposes Published properties for SwiftUI views.

3. Domain Layer
- Models: StockSummary, StockDetails.
- Repositories: Interface StockRepository abstracts data fetching.
- Maps DTOs from Data Layer to domain models.

4. Data Layer
- DTOs: StockProfileDTO, StockSummaryDTO.
- Repository Implementation: StockRepositoryImpl calls APIClient, decodes JSON, maps to domain models.

5. Network Layer
- APIClient: Handles all HTTP requests and JSON decoding.
- Can switch between real API and mocked responses for testing.

6. Unit Testing
- ViewModels tested with mock repositories.
- Repositories tested with mock APIClient returning predefined DTOs.
- Ensures proper state management, error handling, and data mapping.

##Communication Flow
- SwiftUI Views
   ↕ bind/observe
- ViewModels
   ↕ call
- Domain Layer (Models + Repository interface)
   ↕ request
- Data Layer (DTOs + RepositoryImpl)
   ↕ fetch
- APIClient → Yahoo Finance API (HTTP/JSON)
- ViewModels don’t call API directly; they rely on Repository.
- Repositories map raw DTOs to domain models.
- APIClient only handles requests and decoding.
- Unit Tests mock Repositories or APIClient to isolate layers.
