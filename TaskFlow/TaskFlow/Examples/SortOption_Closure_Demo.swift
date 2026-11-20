//
//  SortOption_Closure_Demo.swift
//  TaskFlow
//
//  Created by Girish Lukka on 18/09/2026.
//
import Foundation

    /// Optional lecture demo showing a computed property that returns a closure.
    /// Functions are values in Swift, so `comparator` returns a comparison function
    /// of type `(TaskItem, TaskItem) -> Bool` ready to pass into `sorted(by:)`.
enum SortOption {
    case dueDate
    case title

    var comparator: (TaskItem, TaskItem) -> Bool {
        switch self {
        case .dueDate:
            { $0.dueDate < $1.dueDate }
        case .title:
            { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        }
    }
}

    // Example usage:
    // let sorted = tasks.sorted(by: SortOption.dueDate.comparator)
