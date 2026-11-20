//
//  OnboardingView.swift
//  GoalSaver
//
//  Created by Manazir Ali on 2026-11-19.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("userName") private var savedName = ""

    // Use local @State while typing so partial input isn't persisted prematurely
    @State private var name = ""
    @State private var email = ""

    private var isFormValid: Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedName.isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Tell us about yourself") {
                    TextField("Full Name", text: $name)
                        .textContentType(.name)
                        .autocorrectionDisabled()
                }

                Section {
                    Button("Continue") {
                        savedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
                        hasCompletedOnboarding = true
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("Welcome")
        }
    }
}

#Preview {
    OnboardingView()
}
