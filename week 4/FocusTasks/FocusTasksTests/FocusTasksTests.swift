//
//  FocusTasksTests.swift
//  FocusTasksTests
//
//  Created by girish lukka on 19/09/2026.
//

//import Testing
//
//struct FocusTasksTests {
//
//    @Test func example() async throws {
//        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
//        // Swift Testing Documentation
//        // https://developer.apple.com/documentation/testing
//    }
//
//}
import Testing
import XCTest
import SwiftData
    // @testable gives this test file permission to read your app's internal code
@testable import FocusTasks

    // @MainActor is required because our DatabaseManager and ViewModels are locked to the main thread
@MainActor
final class FocusTasksTests: XCTestCase {

    var container: ModelContainer!
    var context: ModelContext!
    var dbManager: DatabaseManager!
    var viewModel: TaskListViewModel!

        // Replace setUpWithError with the async version
    @MainActor
    override func setUp() async throws {
            // 1. Create a strictly in-memory database configuration for testing
        let config = ModelConfiguration(isStoredInMemoryOnly: true)

            // 2. Initialize the container with our data models
        container = try ModelContainer(
            for: TaskCategory.self,
            FocusTask.self,
            configurations: config
        )

            // 3. Set up our environment objects
        context = container.mainContext
        dbManager = DatabaseManager()
        viewModel = TaskListViewModel()
    }

        // Replace tearDownWithError with the async version
    @MainActor
    override func tearDown() async throws {
        container = nil
        context = nil
        dbManager = nil
        viewModel = nil
    }
        // MARK: - Tests

    func testAddTask_CreatesAndSavesTask() throws {
            // 1. Arrange: Set up our starting conditions
        viewModel.newTaskTitle = "Write Unit Tests"

            // 2. Act: Perform the action we are testing
        viewModel.addTask(dbManager: dbManager, context: context)

            // 3. Assert: Check if the result matches our expectations
        let fetchDescriptor = FetchDescriptor<FocusTask>()
        let savedTasks = try context.fetch(fetchDescriptor)

        XCTAssertEqual(savedTasks.count, 1, "There should be exactly 1 task in the database.")
        XCTAssertEqual(savedTasks.first?.title, "Write Unit Tests", "The task title should match what we typed.")
        XCTAssertTrue(viewModel.newTaskTitle.isEmpty, "The view model's text field should clear after saving.")
    }

    func testAddTask_IgnoresEmptyInput() throws {
        viewModel.newTaskTitle = "   " // Just spaces
        viewModel.addTask(dbManager: dbManager, context: context)

        let fetchDescriptor = FetchDescriptor<FocusTask>()
        let savedTasks = try context.fetch(fetchDescriptor)

        XCTAssertTrue(savedTasks.isEmpty, "The database should still be empty because the title was invalid.")
    }

    func testToggleCompletion_UpdatesDatabase() throws {
            // Arrange
        let task = FocusTask(title: "Learn SwiftData")
        dbManager.insert(task, context: context)
        XCTAssertFalse(task.isCompleted, "Tasks should start incomplete.")

            // Act
        viewModel.toggleCompletion(task, dbManager: dbManager, context: context)

            // Assert
        XCTAssertTrue(task.isCompleted, "Task should be marked as completed after toggling.")
    }

    func testDeleteTask_RemovesFromDatabase() throws {
            // Arrange
        let task = FocusTask(title: "Temporary Task")
        dbManager.insert(task, context: context)

            // Act
        viewModel.deleteTask(task, dbManager: dbManager, context: context)

            // Assert
        let fetchDescriptor = FetchDescriptor<FocusTask>()
        let savedTasks = try context.fetch(fetchDescriptor)

        XCTAssertTrue(savedTasks.isEmpty, "The task should no longer exist in the database.")
    }
}
