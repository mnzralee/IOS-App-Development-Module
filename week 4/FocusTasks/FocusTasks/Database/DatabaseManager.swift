import Foundation
import Observation
import SwiftData

    // @MainActor ensures all database actions happen on the main thread, keeping our UI safe.
    // @Observable lets SwiftUI views watch this class and react to changes (like showing errors).
@MainActor
@Observable
final class DatabaseManager {

        // Properties to help our views display alerts if a database save fails.
    var errorMessage: String?
    var showError = false

        // MARK: - Create

    func insert(_ task: FocusTask, context: ModelContext) {
            // Tell the context (SwiftData's scratchpad) about the new task, then save it to disk.
        context.insert(task)
        save(context: context)
    }

    func insert(_ category: TaskCategory, context: ModelContext) {
        context.insert(category)
        save(context: context)
    }

        // MARK: - Update

    func toggleCompletion(_ task: FocusTask, context: ModelContext) {
            // Modify the task's data and immediately save the change.
        task.isCompleted.toggle()
        save(context: context)
    }

        // MARK: - Delete

    func delete(_ task: FocusTask, context: ModelContext) {
            // Tell the context to remove this item, then save to make the deletion permanent.
        context.delete(task)
        save(context: context)
    }

    func delete(_ category: TaskCategory, context: ModelContext) {
        context.delete(category)
        save(context: context)
    }

        // MARK: - Save

        // A reusable helper function so we don't have to repeat error-handling everywhere.
    func save(context: ModelContext) {
            // Efficiency check: only try to save if there are actual changes pending.
        guard context.hasChanges else { return }

        do {
                // Attempt to write the changes to the device's storage.
            try context.save()
        } catch {
                // If something goes wrong, catch the error so the app doesn't crash.
            record(error)
        }
    }

        // Stores the error details so our SwiftUI views can display a warning alert.
    func record(_ error: Error) {
        errorMessage = "Failed to save: \(error.localizedDescription)"
        showError = true
    }
}
