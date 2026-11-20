    //  TaskListViewModel.swift
    //  FocusTasks
    //
    //  Created by Girish Lukka on 18/09/2026.
    //

import Foundation
import Observation

    // Handles the logic for filtering, searching, and sorting tasks for the UI view
@MainActor
@Observable
final class TaskListViewModel {
    private let store: TaskStore

        // UI state properties for searching and filtering tasks
    var searchText = ""
    var showCompleted = true

    init(store: TaskStore) {
        self.store = store
    }

        // Computes the filtered and sorted list of tasks to show on the screen
    var visibleTasks: [TaskItem] {
        store.tasks
            // Filter out completed tasks if showCompleted is false
            .filter { showCompleted || !$0.isComplete }
            // Filter by search text (ignoring upper/lowercase)
            .filter {
                searchText.isEmpty ||
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
            // Sort tasks: uncompleted tasks first, then sort by priority level
            .sorted { lhs, rhs in
                if lhs.isComplete != rhs.isComplete {
                    return !lhs.isComplete && rhs.isComplete
                }
                return lhs.priority.sortOrder > rhs.priority.sortOrder
            }
    }

        // Returns the number of completed tasks
    var completedCount: Int {
        store.tasks.count(where: \.isComplete)
    }

        // Returns the total number of tasks
    var totalCount: Int {
        store.tasks.count
    }

        // Delegates toggling a task's completion status to the store
    func toggleComplete(_ task: TaskItem) {
        store.toggleComplete(task)
    }

        // Delegates deleting a task to the store
    func delete(_ task: TaskItem) {
        store.delete(task)
    }
}
