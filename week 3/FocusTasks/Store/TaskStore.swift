    //  TaskStore.swift
    //  FocusTasks
    //
    //  Created by Girish Lukka on 18/09/2026.
    //

import Foundation
import Observation

    // Manages the app's task data and automatically updates UI views when data changes
@MainActor
@Observable
final class TaskStore {
        // The list of tasks, pre-populated with sample data for testing and display
    private(set) var tasks: [TaskItem] = [
        TaskItem(title: "Review lecture notes", priority: .high),
        TaskItem(title: "Build FocusTasks demo", priority: .high),
        TaskItem(title: "Test search field", priority: .medium),
        TaskItem(title: "Read SwiftUI documentation", priority: .low, isComplete: true)
    ]

        // Adds a new task to the collection
    func add(_ task: TaskItem) {
        tasks.append(task)
    }

        // Toggles a specific task's completion status between done and not done
    func toggleComplete(_ task: TaskItem) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].isComplete.toggle()
    }

        // Removes a task from the collection by matching its ID
    func delete(_ task: TaskItem) {
        tasks.removeAll { $0.id == task.id }
    }
}
