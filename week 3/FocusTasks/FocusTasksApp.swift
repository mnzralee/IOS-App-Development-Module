    //  FocusTasksApp.swift
    //  FocusTasks
    //
    //  Created by Girish Lukka on 18/09/2026.
    //

import SwiftUI

    // Marks this struct as the entry point where the app starts running
@main
struct FocusTasksApp: App {
        // State properties to hold our app's core data and view logic
    @State private var taskStore: TaskStore
    @State private var taskListViewModel: TaskListViewModel

    init() {
            // Set up the shared task store and pass it into the view model
        let store = TaskStore()
        _taskStore = State(initialValue: store)
        _taskListViewModel = State(
            initialValue: TaskListViewModel(store: store)
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                // Inject the store and view model into the environment so all child views can access them
                .environment(taskStore)
                .environment(taskListViewModel)
        }
    }
}
