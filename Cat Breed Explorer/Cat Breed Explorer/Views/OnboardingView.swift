//
//  OnboardingView.swift
//  Cat Breed Explorer
//
//  Created by Manazir Ali on 2026-11-16.
//
//  ONBOARDING: ask for the user's name once, save it, then never show again.
//  Spec 1.1 + wireframe 1 ("Cats App / tell us your name").
//

import SwiftUI

struct OnboardingView: View {
    // Saved values (UserDefaults). Writing them here is what makes onboarding "once only".
    @AppStorage(StorageKeys.userName) private var userName = ""
    @AppStorage(StorageKeys.hasCompletedOnboarding) private var hasCompletedOnboarding = false

    // Local draft while typing. Only copied into AppStorage when the user confirms.
    @State private var nameInput = ""

    // Computed: "  Pubudu " -> "Pubudu"
    private var trimmedName: String {
        nameInput.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "cat.fill")
                .font(.system(size: 72))
                .foregroundStyle(.orange)

            Text("Cats App")
                .font(.largeTitle)
                .bold()

            Text("Tell us your name")
                .foregroundStyle(.secondary)

            // $nameInput = a Binding: the TextField writes what the user types into the @State
            TextField("Name", text: $nameInput)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .submitLabel(.done)
                .onSubmit(completeOnboarding)        // keyboard "Done" also continues

            Button("Continue", action: completeOnboarding)
                .buttonStyle(.borderedProminent)
                .disabled(trimmedName.isEmpty)       // can't continue with an empty name

            Spacer()
        }
        .padding()
    }

    private func completeOnboarding() {
        guard !trimmedName.isEmpty else { return }
        userName = trimmedName              // saved: HomeView reads the same key for "Greetings, ..."
        hasCompletedOnboarding = true       // saved: RootView redraws and swaps to HomeView
    }
}

#Preview {
    OnboardingView()
}
