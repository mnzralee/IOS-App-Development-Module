import SwiftUI
import SwiftData

    // Because we set `deleteRule: .cascade` on TaskCategory, deleting a category
    // here automatically deletes all of its tasks. SwiftData handles this for us,
    // and any other screens showing those tasks will update automatically!
struct CategoryListView: View {
        // @Query automatically fetches data from SwiftData and keeps the view
        // updated if the data changes. Here, we're sorting alphabetically.
    @Query(sort: \TaskCategory.name)
    private var categories: [TaskCategory]

        // SwiftData's built-in scratchpad for saving and deleting data.
    @Environment(\.modelContext)
    private var modelContext

        // Our custom database manager that was injected in FocusTasksApp.
    @Environment(DatabaseManager.self)
    private var dbManager

        // Holds the logic (like adding and deleting) for this specific screen.
    @State private var viewModel = CategoryListViewModel()

        // A built-in SwiftUI tool to close this view when it's presented as a sheet.
    @Environment(\.dismiss)
    private var dismiss

    var body: some View {
        NavigationStack {
            List {
                    // Loop through our fetched categories to build the list rows
                ForEach(categories) { category in
                    VStack(alignment: .leading) {
                        Text(category.name)
                            .font(.headline)
                        Text("\(category.tasks.count) task(s)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                    // Enables the standard "swipe-to-delete" gesture on our list rows
                .onDelete { offsets in
                    for index in offsets {
                        viewModel.deleteCategory(categories[index], dbManager: dbManager, context: modelContext)
                    }
                }
            }
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done") { dismiss() } // Closes the sheet
                }
            }
                // Pins our custom "Add Category" bar to the bottom of the screen,
                // above the safe area (like the home indicator or keyboard).
            .safeAreaInset(edge: .bottom) {
                    // @Bindable lets SwiftUI write text directly into our ViewModel's properties.
                @Bindable var viewModel = viewModel

                HStack {
                        // The $ prefix creates a two-way connection to the ViewModel
                    TextField("New category", text: $viewModel.newCategoryName)
                        .textFieldStyle(.roundedBorder)

                    Button("Add") {
                        viewModel.addCategory(dbManager: dbManager, context: modelContext)
                    }
                        // Prevent tapping "Add" if the text field is empty or just spaces
                    .disabled(viewModel.newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()
                .background(.bar) // Gives the background a nice blurred glass effect
            }
        }
    }
}

#Preview("Categories") {
        // Sets up a temporary, memory-only database just for the Xcode canvas
    let container = PreviewSupport.makeContainer()
    PreviewSupport.seedIfNeeded(container: container)

    return CategoryListPreviewHost(container: container)
}
