//
//  ContentView.swift
//  GoalSaver
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        TabView {
            CalculateView()
                .tabItem {
                    Label("Calculate", systemImage: "function")
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }
        }
        .tint(.blue)
    }
}

#Preview {
    ContentView()
    // HINT (after Task 8): previews that read SwiftData need a container too:
     .modelContainer(for: SavingsRecord.self, inMemory: true)
    
}
