    //  PreviewContainer.swift
    //  FocusTasks
    //
    //  Created by Girish Lukka on 18/09/2026.
    //

import SwiftUI

    // A helper container used in SwiftUI previews to supply sample data and environment objects to our views
struct PreviewContainer: View {
    @State private var store: TaskStore
    @State private var viewModel: TaskListViewModel

    init() {
            // Initialize a mock store and view model for previewing purposes
        let store = TaskStore()
        _store = State(initialValue: store)
        _viewModel = State(initialValue: TaskListViewModel(store: store))
    }

    var body: some View {
        ContentView()
            // Inject the preview store and view model into the child views
            .environment(store)
            .environment(viewModel)
    }
}

    // Global preview entry point for the entire app layout
#Preview("FocusTasks") {
    PreviewContainer()
}
