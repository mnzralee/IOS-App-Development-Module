//
//  CatBreedsExplorerApp.swift
//  Cat Breeds Explorer (reference solution)
//

import SwiftUI

@main
struct CatBreedsExplorerApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

/// Decides which screen to show. Onboarding appears ONCE because the flag is persisted.
struct RootView: View {
    @AppStorage(AppConstants.StorageKeys.hasCompletedOnboarding)
    private var hasCompletedOnboarding = false

    var body: some View {
        if hasCompletedOnboarding {
            HomeView()
        } else {
            OnboardingView()
        }
    }
}
