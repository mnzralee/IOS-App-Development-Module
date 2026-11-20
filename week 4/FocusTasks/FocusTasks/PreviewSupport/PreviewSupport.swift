import SwiftUI
import SwiftData

    // A helper dedicated to making Xcode Previews work smoothly with SwiftData.
@MainActor
enum PreviewSupport {

        // Creates a temporary database that only lives in memory.
        // This stops our dummy preview data from accidentally saving to the user's real app!
    static func makeContainer() -> ModelContainer {
        do {
            let configuration = ModelConfiguration(
                isStoredInMemoryOnly: true
            )

            return try ModelContainer(
                for: TaskCategory.self,
                FocusTask.self,
                configurations: configuration
            )
        } catch {
            fatalError("Preview container failed: \(error)")
        }
    }

        // Injects some dummy data into our preview so the canvas isn't empty while we design.
    static func seedIfNeeded(
        container: ModelContainer
    ) {
        let context = container.mainContext

        do {
                // Check if we already have tasks so we don't duplicate them every time the preview reloads.
            let existing = try context.fetch(
                FetchDescriptor<FocusTask>()
            )

            guard existing.isEmpty else { return }

                // Create our dummy categories and tasks...
            let study = TaskCategory(name: "Study")
            let personal = TaskCategory(name: "Personal")

            context.insert(study)
            context.insert(personal)

            context.insert(
                FocusTask(
                    title: "Explain @Query",
                    category: study
                )
            )

            context.insert(
                FocusTask(
                    title: "Trace the CRUD path",
                    category: study
                )
            )

            context.insert(
                FocusTask(
                    title: "Take a short walk",
                    isCompleted: true,
                    category: personal
                )
            )

                // Save the dummy data to our temporary in-memory database.
            try context.save()
        } catch {
            fatalError("Preview seed failed: \(error)")
        }
    }

        // Used by the actual app (in FocusTasksApp.swift) to provide some
        // friendly starter data the very first time a user downloads and opens the app.
    static func seedProductionIfNeeded(
        database: DatabaseManager,
        container: ModelContainer
    ) {
        let context = container.mainContext

        do {
            let tasks = try context.fetch(
                FetchDescriptor<FocusTask>()
            )

            guard tasks.isEmpty else { return }

            let study = TaskCategory(name: "Study")
            let personal = TaskCategory(name: "Personal")

            database.insert(study, context: context)
            database.insert(personal, context: context)

            database.insert(
                FocusTask(
                    title: "Review SwiftData",
                    category: study
                ),
                context: context
            )

            database.insert(
                FocusTask(
                    title: "Plan next lecture",
                    category: personal
                ),
                context: context
            )

            database.save(context: context)
        } catch {
            fatalError("Initial data failed: \(error)")
        }
    }
}

    // Xcode previews can't use the @main App file, so this acts as a mini-app
    // just for the canvas, making sure our view gets the database manager it expects.
//@MainActor
//struct TaskListPreviewHost: View {
//    let container: ModelContainer
//    @State private var database = DatabaseManager()
//
//    var body: some View {
//        TaskListView()
//            .environment(database)
//            .modelContainer(container)
//    }
//}
@MainActor
struct TaskListPreviewHost: View {
    let container: ModelContainer
    @State private var database = DatabaseManager()

    var body: some View {
        TaskListView2()
            .environment(database)
            .modelContainer(container)
    }
}

    // Does the same setup as above, but specifically for testing the Categories screen.
@MainActor
struct CategoryListPreviewHost: View {
    let container: ModelContainer
    @State private var database = DatabaseManager()

    var body: some View {
        CategoryListView()
            .environment(database)
            .modelContainer(container)
    }
}
