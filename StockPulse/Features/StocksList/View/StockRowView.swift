//
//  StockRowView.swift
//  StockPulse
//
//  Created by Hesham Khaled on 26/03/2026.
//

import Foundation
import SwiftUI

struct StockRowView: View {
    
    let stock: Stock
    
    var body: some View {
        HStack {
            
            // Left Side (Name + Symbol)
            VStack(alignment: .leading, spacing: 4) {
                Text(stock.name)
                    .font(.headline)
                
                Text(stock.symbol)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Right Side (Price + Change %)
            VStack(alignment: .trailing, spacing: 4) {
                Text(formattedPrice)
                    .font(.headline)
                
                Text(formattedChange)
                    .font(.subheadline)
                    .foregroundColor(changeColor)
            }
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Helpers
private extension StockRowView {
    
    var formattedPrice: String {
        String(format: "%.2f", stock.price)
    }
    
    var formattedChange: String {
        String(format: "%.2f%%", stock.changePercentage)
    }
    
    var changeColor: Color {
        stock.changePercentage >= 0 ? .green : .red
    }
}
