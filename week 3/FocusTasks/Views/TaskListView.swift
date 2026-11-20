    //  TaskListView.swift
    //  FocusTasks
    //
    //  Created by Girish Lukka on 18/09/2026.
    //

import SwiftUI

    // Displays the main list of tasks along with search, filter toggles, and delete controls
struct TaskListView: View {
    @Environment(TaskListViewModel.self) private var viewModel

    var body: some View {
            // Creates a bindable wrapper so we can use $ with the @Observable view model properties
        @Bindable var viewModel = viewModel

        NavigationStack {
            List {
                    // Search field bound to the view model's search text
                SearchField(text: $viewModel.searchText)

                    // Toggle switch to show or hide completed tasks
                Toggle(
                    "Show Completed",
                    isOn: $viewModel.showCompleted
                )

                    // Section header showing real-time completion progress count
                Section(
                    "\(viewModel.completedCount) of \(viewModel.totalCount) complete"
                ) {
                        // Loop through the filtered/sorted tasks from the view model
                    ForEach(viewModel.visibleTasks) { task in
                        TaskRowView(task: task) {
                            viewModel.toggleComplete(task)
                        }
                    }
                        // Handles swiping to delete tasks from the list
                    .onDelete { offsets in
                        for index in offsets {
                            let task = viewModel.visibleTasks[index]
                            viewModel.delete(task)
                        }
                    }
                }
            }
            .navigationTitle("FocusTasks")
        }
    }
}

    // Preview provider using a helper container to render the view with sample data
#Preview("TaskListView") {
    PreviewContainer()
}
