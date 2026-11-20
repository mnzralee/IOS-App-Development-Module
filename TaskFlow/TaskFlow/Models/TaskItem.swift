//
//  TaskItem.swift
//  TaskFlow
//
//  Created by Girish Lukka on 18/09/2026.
//
import Foundation

    // A value type (struct). SwiftUI uses structs because they create
    // independent copies, preventing accidental shared state bugs.
struct TaskItem: Identifiable, Hashable {
    let id: UUID
    var title: String
    var priority: Priority
    var category: Category
    var dueDate: Date
    var isDone: Bool

        // Custom initializer with sensible defaults (auto-generates an ID and defaults to not done).
    init(
        id: UUID = UUID(),
        title: String,
        priority: Priority,
        category: Category,
        dueDate: Date,
        isDone: Bool = false
    ) {
        self.id = id
        self.title = title
        self.priority = priority
        self.category = category
        self.dueDate = dueDate
        self.isDone = isDone
    }

        // `mutating` is required because this method modifies the struct's properties.
    mutating func toggleDone() {
        isDone.toggle()
    }

        // Computed property: evaluated fresh each time, preventing data sync issues.
    var isOverdue: Bool {
        !isDone && dueDate < .now
    }

        // Computed property: combines existing state into a friendly, human-readable status message.
    var statusDescription: String {
        if isDone { return "Done" }
        if isOverdue { return "Overdue" }

        let days = Calendar.current.dateComponents(
            [.day], from: .now, to: dueDate
        ).day ?? 0

        switch days {
        case 0: return "Due today"
        case 1: return "Due tomorrow"
        default: return "Due in \(days) days"
        }
    }
}
