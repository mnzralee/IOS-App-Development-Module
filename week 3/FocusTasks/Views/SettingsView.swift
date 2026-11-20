    //  SettingsView.swift
    //  FocusTasks
    //
    //  Created by Girish Lukka on 18/09/2026.
    //

import SwiftUI

    // Displays app preferences and summary statistics using the environment task store
struct SettingsView: View {
        // Access the shared task store and system color scheme from the environment
    @Environment(TaskStore.self) private var store
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            Form {
                    // Section showing task counts from the shared store
                Section("Shared TaskStore") {
                    LabeledContent("Total", value: "\(store.tasks.count)")
                    LabeledContent("Completed", value: "\(store.tasks.count(where: \.isComplete))")
                }

                    // Section showing device settings or environment state
                Section("System Environment") {
                    LabeledContent(
                        "Appearance",
                        value: colorScheme == .dark ? "Dark" : "Light"
                    )
                }
            }
            .navigationTitle("Settings")
        }
    }
}

    // Preview provider using a helper container to render the view with sample data
#Preview("SettingsView") {
    PreviewContainer()
}
