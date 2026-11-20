//
//  ContentView.swift
//  ParcelCost (Starter)
//
//  The app shell: two tabs. Nothing to change here.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Calculate", systemImage: "list.bullet") {
                CalculateView()
            }

            Tab("History", systemImage: "calendar") {
                HistoryView()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ParcelData.self, inMemory: true)
}
