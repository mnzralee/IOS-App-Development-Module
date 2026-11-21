//
//  Cat_Breed_ExplorerApp.swift
//  Cat Breed Explorer
//
//  Created by Manazir Ali on 2026-11-16.
//
//  APP ENTRY POINT + the "onboarding once" switch.
//  Marks: "Data Persistence: correct use of AppStorage" (5)
//

import SwiftUI

// @AppStorage keys in one place. The SAME key in two views = the same saved value,
// so a typo would silently create two different values. Constants prevent that.
enum StorageKeys {
    static let userName = "userName"
    static let hasCompletedOnboarding = "hasCompletedOnboarding"
}

@main   // the app starts here
struct Cat_Breed_ExplorerApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

/// Chooses the first screen. @AppStorage saves to UserDefaults, so the flag survives relaunch:
/// first launch -> false -> Onboarding. After "Continue" -> true -> Home, forever.
struct RootView: View {
    @AppStorage(StorageKeys.hasCompletedOnboarding) private var hasCompletedOnboarding = false

    var body: some View {
        if hasCompletedOnboarding {
            HomeView()
        } else {
            OnboardingView()
        }
    }
}
