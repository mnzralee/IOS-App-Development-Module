//
//  RoadCostApp.swift
//  RoadCost
//
//  Created by Manazir Ali on 2026-11-19.
//

import SwiftUI
import SwiftData

@main
struct RoadCostApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // TODO (Task 9): Attach .modelContainer(for: TripRecord.self)
        .modelContainer(for: TripRecord.self)
    }
}
