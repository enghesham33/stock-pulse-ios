//
//  StockListView.swift
//  StockPulse
//
//  Updated by Hesham Khaled on 26/03/2026.
//

import SwiftUI
import Swinject

struct StockListView: View {
    
    @StateObject var viewModel: StockListViewModel
    @State private var path: [Stock] = []

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                // Search Bar
                TextField("Search stocks...", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                // Stocks List
                if viewModel.isLoading && viewModel.stocks.isEmpty {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    List(viewModel.filteredStocks) { stock in
                        StockRowView(stock: stock)
                            .contentShape(Rectangle()) // Make entire row tappable
                            .onTapGesture {
                                viewModel.stopTimer()
                                path.append(stock)
                            }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Stocks")
            .onAppear {
                Task { await viewModel.fetchStocks() }
                viewModel.startTimer()
            }
            // Resume timer when returning from detail screen
            .onChange(of: path) { _, newPath in
                if newPath.isEmpty {
                    viewModel.startTimer()
                }
            }
            // Navigation destination
            .navigationDestination(for: Stock.self) { stock in
                let vm = DIContainer.shared.container.resolve(
                    StockDetailsViewModel.self,
                    argument: stock
                )!
                StockDetailView(viewModel: vm)
            }
        }
    }
}

