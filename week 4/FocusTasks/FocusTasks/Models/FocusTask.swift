import Foundation
import SwiftData // Needed to use @Model

    // @Model tells SwiftData to save and manage this class in our database.
@Model
final class FocusTask {
    var title: String
    var isCompleted: Bool
    var createdAt: Date

        // The "many" side of our category relationship.
        // It's optional (?) so a task doesn't have to belong to a category right away.
    var category: TaskCategory?

        // Sets up a new task. We provide default values for most properties,
        // so we only *have* to provide a title when creating a new one.
    init(
        title: String,
        isCompleted: Bool = false,
        createdAt: Date = .now,
        category: TaskCategory? = nil
    ) {
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.category = category
    }
}
