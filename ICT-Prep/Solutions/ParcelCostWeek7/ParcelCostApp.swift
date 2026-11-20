//
//  ParcelCostApp.swift
//  ParcelCost (reference solution)
//

import SwiftUI
import SwiftData

@main
struct ParcelCostApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // (1) Tell the app which model(s) the database holds. Creates the
        //     ModelContainer once and puts a modelContext into the Environment.
        .modelContainer(for: ParcelData.self)
    }
}

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
        .modelContainer(for: ParcelData.self, inMemory: true)   // previews never touch real data
}
