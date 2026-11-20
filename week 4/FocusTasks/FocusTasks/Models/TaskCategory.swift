import Foundation
import SwiftData // Needed for @Model and @Relationship

    // @Model turns this standard Swift class into a data model that
    // SwiftData can save, search, and automatically watch for changes.
@Model
final class TaskCategory {
    var name: String

        // Defines a one-to-many relationship (one category has many tasks).
        // deleteRule: .cascade means if we delete this category, SwiftData
        // will automatically clean up and delete all the tasks inside it.
    @Relationship(
        deleteRule: .cascade,
        inverse: \FocusTask.category
    )
    var tasks: [FocusTask] = []

        // Initializes a new category with a name. The tasks array
        // starts empty by default.
    init(name: String) {
        self.name = name
    }
}
