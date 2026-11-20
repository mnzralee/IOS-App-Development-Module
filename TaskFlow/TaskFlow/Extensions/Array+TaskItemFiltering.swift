//
//  Array+TaskItemFiltering.swift
//  TaskFlow
//
//  Created by Girish Lukka on 18/09/2026.
//
import Foundation

    // Extends arrays specifically containing TaskItems with custom filtering.
extension Array where Element == TaskItem {

        /// Filters tasks by priority and category.
        /// An empty set for either means no filter is applied for that dimension.
    func filtered(
        priorities: Set<Priority>,
        categories: Set<Category>
    ) -> [TaskItem] {
            // Uses standard library filter with O(1) Set lookups for performance.
        filter { task in
            (priorities.isEmpty || priorities.contains(task.priority)) &&
            (categories.isEmpty || categories.contains(task.category))
        }
    }
}
