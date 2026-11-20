//
//  GoalSaverApp.swift
//  GoalSaver
//
//  Tutorial starter – Week 7 practical preparation.
//

import SwiftUI
import SwiftData

@main
struct GoalSaverApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    ContentView()
                } else {
                    OnboardingView()
                }
            }
            .animation(.easeInOut, value: hasCompletedOnboarding)
            // TASK 9 – HINT: Inject your SwiftData model container here so every view can reach it.
            // .modelContainer(...)
            .modelContainer(for: SavingsRecord.self)
        }
    }
}
