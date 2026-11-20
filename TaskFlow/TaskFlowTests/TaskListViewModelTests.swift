//
//  TaskListViewModelTests.swift
//  TaskFlow
//
//  Created by Girish Lukka on 18/09/2026.
//
//import Foundation
import XCTest
@testable import TaskFlow // Accesses your app module

final class TaskListViewModelTests: XCTestCase {

        // 1. Test that filtering works correctly by priority and category
    @MainActor func testFilteringTasks() {
            // Arrange: Create custom sample tasks
        let task1 = TaskItem(title: "Work High", priority: .high, category: .work, dueDate: .now)
        let task2 = TaskItem(title: "Personal Low", priority: .low, category: .personal, dueDate: .now)
        let viewModel = TaskListViewModel(tasks: [task1, task2])

            // Act: Apply a filter for high priority
        viewModel.selectedPriorities.insert(.high)

            // Assert: Verify only the high priority task is returned in filteredTasks
        XCTAssertEqual(viewModel.filteredTasks.count, 1)
        XCTAssertEqual(viewModel.filteredTasks.first?.title, "Work High")
    }

        // 2. Test toggling a task's completion state
    @MainActor func testToggleDone() {
            // Arrange
        let task = TaskItem(title: "Test Task", priority: .medium, category: .study, dueDate: .now, isDone: false)
        let viewModel = TaskListViewModel(tasks: [task])

            // Act
        viewModel.toggleDone(task)

            // Assert: Check that isDone flipped to true
        XCTAssertTrue(viewModel.tasks.first!.isDone)
    }

        // 3. Test clearing all active filters
    @MainActor func testClearFilters() {
            // Arrange
        let viewModel = TaskListViewModel()
        viewModel.selectedPriorities.insert(.high)
        viewModel.selectedCategories.insert(.work)

            // Act
        viewModel.clearFilters()

            // Assert: Filters should be empty again
        XCTAssertTrue(viewModel.selectedPriorities.isEmpty)
        XCTAssertTrue(viewModel.selectedCategories.isEmpty)
    }
}
