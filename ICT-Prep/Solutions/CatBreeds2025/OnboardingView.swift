//
//  OnboardingView.swift
//  Cat Breeds Explorer (reference solution)
//
//  Data Persistence (5 marks): @AppStorage for the name and the "seen onboarding" flag.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage(AppConstants.StorageKeys.userName) private var userName = ""
    @AppStorage(AppConstants.StorageKeys.hasCompletedOnboarding) private var hasCompletedOnboarding = false

    // Local draft. Only saved to AppStorage when the user confirms.
    @State private var nameInput = ""

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

            TextField("Name", text: $nameInput)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .submitLabel(.done)
                .onSubmit(completeOnboarding)

            Button("Continue", action: completeOnboarding)
                .buttonStyle(.borderedProminent)
                .disabled(trimmedName.isEmpty)   // validation: no empty names

            Spacer()
        }
        .padding()
    }

    private func completeOnboarding() {
        guard !trimmedName.isEmpty else { return }
        userName = trimmedName
        hasCompletedOnboarding = true   // RootView sees this change and swaps to HomeView
    }
}

#Preview {
    OnboardingView()
}
