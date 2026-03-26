//
//  StockDetailView.swift
//  StockPulse
//
//  Created by Hesham Khaled on 25/03/2026.
//

import Foundation
import SwiftUI

struct StockDetailView: View {
    
    @StateObject var viewModel: StockDetailsViewModel
    
    var body: some View {
        ScrollView {
            if let error = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    
                    Text(error)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.red)
                }
                .padding()
            } else if let details = viewModel.details {
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text(details.name)
                            .font(.title2)
                            .bold()
                        
                        Text(details.symbol ?? "")
                            .foregroundColor(.gray)
                    }
                    
                    // Price Section
                    HStack {
                        Text(String(format: "%.2f", details.price ?? 0.0))
                            .font(.title)
                            .bold()
                        Spacer()
                        Text(String(format: "%.2f%%", details.changePercentage ?? 0.0))
                            .font(.subheadline)
                            .foregroundColor((details.changePercentage ?? 0.0) >= 0 ? .green : .red)
                    }
                    
                    Divider()
                    
                    // Company Info
                    VStack(alignment: .leading, spacing: 8) {
                        infoRow(title: "Sector", value: details.sector ?? "-")
                        infoRow(title: "Industry", value: details.industry ?? "-")
                    }
                    
                    // Website
                    if !(details.website?.isEmpty ?? true) {
                        Link("Visit Website", destination: URL(string: details.website ?? "")!)
                            .font(.subheadline)
                    }
                    
                    Divider()
                    
                    // Description
                    Text("About")
                        .font(.headline)
                    
                    Text(details.description ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .padding(.top)
                    }
                }
                .padding()
                
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchDetails()
        }
    }
    
    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
        }
    }
}
