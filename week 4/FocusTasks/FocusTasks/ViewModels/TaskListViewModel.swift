import Foundation
import Observation
import SwiftData

    // @MainActor keeps UI updates safe, and @Observable lets the view watch this class for changes.
    // This ViewModel handles the logic for our screen, so the View can just focus on layout.
@MainActor
@Observable
final class TaskListViewModel {

        // Temporary storage for what the user is typing in the text field.
        // This isn't saved to the database until they actually hit "Add".
    var newTaskTitle = ""

        // Takes the user's input, validates it, and hands it off to the database manager.
    func addTask(
        category: TaskCategory? = nil,
        dbManager: DatabaseManager,
        context: ModelContext
    ) {
            // Remove accidental extra spaces at the beginning or end of the text.
        let title = newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines)

            // Stop here if the user tried to submit an empty string.
        guard !title.isEmpty else {
            return
        }

            // Create the new task and tell the database manager to save it.
        let task = FocusTask(title: title, category: category)
        dbManager.insert(task, context: context)

            // Clear the text field so the user can type a new task right away.
        newTaskTitle = ""
    }

        // These next two functions act as simple middlemen, passing the user's actions
        // (tapping a checkbox or swiping to delete) straight to the database manager.

    func toggleCompletion(
        _ task: FocusTask,
        dbManager: DatabaseManager,
        context: ModelContext
    ) {
        dbManager.toggleCompletion(task, context: context)
    }

    func deleteTask(
        _ task: FocusTask,
        dbManager: DatabaseManager,
        context: ModelContext
    ) {
        dbManager.delete(task, context: context)
    }
}
