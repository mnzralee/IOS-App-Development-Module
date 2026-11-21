//
//  ContentView.swift
//  RoadCost
//
//  Created by Manazir Ali on 2026-11-19.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            EstimateView()
                .tabItem {
                    Label("Estimate", systemImage: "function")
                }
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TripRecord.self, inMemory: true)
}
