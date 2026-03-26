//
//  StockPulseApp.swift
//  StockPulse
//
//  Created by Hesham Khaled on 25/03/2026.
//

import SwiftUI
import Swinject

@main
struct StockPulseApp: App {
    
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showSplash = false
                            }
                        }
                    }
            } else {
                 let viewModel = DIContainer.shared.container.resolve(StockListViewModel.self)!
                StockListView(viewModel: viewModel)
            }
        }
    }
}
