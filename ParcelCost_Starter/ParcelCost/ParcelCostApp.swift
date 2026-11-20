//
//  ParcelCostApp.swift
//  ParcelCost (Starter)
//

import SwiftUI
import SwiftData

// @main marks this as the starting point of the application
@main
struct ParcelCostApp: App {
    // The database container: it knows which model(s) SwiftData should store
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for: ParcelData.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Makes the database available to every view in the app
        .modelContainer(container)
    }
}
