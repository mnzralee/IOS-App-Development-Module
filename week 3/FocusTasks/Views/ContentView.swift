    //  ContentView.swift
    //  FocusTasks
    //
    //  Created by Girish Lukka on 18/09/2026.
    //

import SwiftUI

    // The main view of the app containing a tab bar for navigation between Tasks and Settings
struct ContentView: View {
    var body: some View {
        TabView {
                // First tab: Displays the main task list
            TaskListView()
                .tabItem {
                    Label("Tasks", systemImage: "checklist")
                }

                // Second tab: Displays the app settings
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

    // Preview provider using a helper container to render the view with sample data
#Preview("ContentView") {
    PreviewContainer()
}
