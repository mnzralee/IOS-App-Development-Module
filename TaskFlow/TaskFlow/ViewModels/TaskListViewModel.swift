//
//  TaskListViewModel.swift
//  TaskFlow
//
//  Created by Girish Lukka on 18/09/2026.
//
import Observation

    // @Observable is the modern state management framework; SwiftUI
    // automatically tracks property reads and updates views efficiently.
    // It's a class so multiple views share a single source of truth.
@Observable
final class TaskListViewModel {
    var tasks: [TaskItem]

        // Active filter selections for priorities and categories.
    var selectedPriorities: Set<Priority> = []
    var selectedCategories: Set<Category> = []

    init(tasks: [TaskItem] = TaskItem.sampleTasks) {
        self.tasks = tasks
    }

        // Computed property that dynamically returns tasks matching current filters.
    var filteredTasks: [TaskItem] {
        tasks.filtered(
            priorities: selectedPriorities,
            categories: selectedCategories
        )
    }

        // Finds and toggles a task's completion state in the primary tasks array.
    func toggleDone(_ task: TaskItem) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].toggleDone()
    }

        // Clears all active priority and category filters.
    func clearFilters() {
        selectedPriorities.removeAll()
        selectedCategories.removeAll()
    }
}
