import Foundation
import Observation
import SwiftData

    // Manages the logic for our categories screen, keeping UI updates safe on the main thread (@MainActor)
    // and allowing SwiftUI views to automatically update when the data changes (@Observable).
@MainActor
@Observable
final class CategoryListViewModel {

        // Temporary storage for the text field while the user is typing a new category name.
    var newCategoryName = ""

        // Validates the user's input before asking the database manager to save it.
    func addCategory(
        dbManager: DatabaseManager,
        context: ModelContext
    ) {
            // Remove any accidental spaces at the start or end of the text.
        let name = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)

            // Stop here if the user left it blank or just typed spaces.
        guard !name.isEmpty else {
            return
        }

            // Create the new category, save it to the database, and clear the text field.
        dbManager.insert(TaskCategory(name: name), context: context)
        newCategoryName = ""
    }

        // A simple middleman function to handle swipe-to-delete actions from the view.
    func deleteCategory(
        _ category: TaskCategory,
        dbManager: DatabaseManager,
        context: ModelContext
    ) {
        dbManager.delete(category, context: context)
    }
}
