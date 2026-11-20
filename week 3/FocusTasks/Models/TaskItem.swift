    //  TaskItem.swift
    //  FocusTasks
    //
    //  Created by Girish Lukka on 18/09/2026.
    //

import Foundation

    // Represents a single task. Identifiable lets SwiftUI track each item uniquely, and Equatable allows us to compare tasks.
struct TaskItem: Identifiable, Equatable {
    let id: UUID
    var title: String
    var priority: Priority
    var isComplete: Bool

        // Defines priority levels and assigns a numeric value to easily sort tasks by importance
    enum Priority: String, CaseIterable {
        case low, medium, high

        var sortOrder: Int {
            switch self {
            case .low: 0
            case .medium: 1
            case .high: 2
            }
        }
    }

        // Custom initializer with helpful default values (medium priority, not completed yet)
    init(
        id: UUID = UUID(),
        title: String,
        priority: Priority = .medium,
        isComplete: Bool = false
    ) {
        self.id = id
        self.title = title
        self.priority = priority
        self.isComplete = isComplete
    }
}
