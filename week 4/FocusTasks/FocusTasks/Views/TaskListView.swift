import SwiftUI
import SwiftData

struct TaskListView: View {
        // @Query automatically fetches our tasks from SwiftData and keeps this list
        // instantly updated whenever the database changes. No manual refreshing needed!
    @Query(sort: \FocusTask.createdAt, order: .reverse)
    private var tasks: [FocusTask]

        // SwiftData's built-in scratchpad for making and saving changes.
    @Environment(\.modelContext)
    private var modelContext

        // Our custom database manager, passed down from the App file.
    @Environment(DatabaseManager.self)
    private var dbManager

        // Holds the user input logic specifically for this screen.
    @State private var viewModel = TaskListViewModel()

        // Controls whether the Categories popup sheet is visible.
    @State private var showingCategories = false

    var body: some View {
            // @Bindable lets us pass our @Observable dbManager into UI elements
            // that require a binding (like the error alert).
        @Bindable var dbManager = dbManager

        return NavigationStack {
            List {
                if tasks.isEmpty {
                        // Show a friendly placeholder if there are no tasks yet.
                    ContentUnavailableView(
                        "No Tasks",
                        systemImage: "checklist",
                        description: Text("Add a task to get started.")
                    )
                } else {
                        // Loop through the fetched tasks to create a row for each one.
                    ForEach(tasks) { task in
                        TaskRow(task: task) {
                            viewModel.toggleCompletion(task, dbManager: dbManager, context: modelContext)
                        }
                    }
                        // Enables standard swipe-to-delete behavior.
                    .onDelete { offsets in
                        for index in offsets {
                            viewModel.deleteTask(tasks[index], dbManager: dbManager, context: modelContext)
                        }
                    }
                }
            }
            .navigationTitle("FocusTasks")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Categories") {
                        showingCategories = true
                    }
                }
            }
                // Pins our custom "Add Task" bar to the bottom of the screen.
            .safeAreaInset(edge: .bottom) {
                addBar
            }
                // Presents the CategoryListView when showingCategories is toggled to true.
            .sheet(isPresented: $showingCategories) {
                CategoryListView()
            }
                // Listens to dbManager and shows an alert if a database save fails.
            .alert("Persistence Error", isPresented: $dbManager.showError) {
                Button("OK") { }
            } message: {
                Text(dbManager.errorMessage ?? "An unexpected error occurred.")
            }
        }
    }

        // Extracted into a separate variable to keep the main `body` clean and readable.
    private var addBar: some View {
            // @Bindable lets the TextField update the ViewModel's text property directly.
        @Bindable var viewModel = viewModel

        return HStack(spacing: 12) {
            TextField("New task", text: $viewModel.newTaskTitle)
                .textFieldStyle(.roundedBorder)

            Button {
                viewModel.addTask(dbManager: dbManager, context: modelContext)
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
            }
                // Prevent tapping "+" if the text field is empty or just spaces.
            .disabled(viewModel.newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
        .background(.bar) // Gives the background a slightly blurred, frosted glass look.
    }
}

#Preview("Tasks") {
        // Sets up a temporary, memory-only database so the Xcode preview doesn't crash.
    let container = PreviewSupport.makeContainer()
    PreviewSupport.seedIfNeeded(container: container)

    return TaskListPreviewHost(container: container)
}
