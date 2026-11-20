import SwiftUI
import SwiftData // Required for managing our app's persistent data

    // @main tells Swift this is the starting point of our application
@main
struct FocusTasksApp: App {
        // Holds our custom database logic. @State keeps it alive while the app runs.
    @State private var database = DatabaseManager()

        // The core SwiftData object that manages where and how our data is saved.
    let container: ModelContainer

        // The init() function runs immediately when the app launches to set up our data.
    init() {
        do {
                // Tell the container exactly which data models it needs to keep track of.
            container = try ModelContainer(
                for: TaskCategory.self,
                FocusTask.self
            )
        } catch {
                // If the database fails to load, crash safely with an error message we can read.
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            TaskListView2()
                // Makes our database manager available to any child view that asks for it.
                .environment(database)
                // .task runs a background operation right when this view appears.
                .task {
                        // Inject some starter/sample data if the database is currently empty.
                    PreviewSupport.seedProductionIfNeeded(
                        database: database,
                        container: container
                    )
                }
        }
            // Attaches our SwiftData container to the entire app, letting views use @Query.
        .modelContainer(container)
    }
}
