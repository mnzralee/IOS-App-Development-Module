import SwiftUI

    // This view handles the layout for a single row in our list.
    // It just displays the data—it leaves the actual database updating to the parent view.
struct TaskRow: View {
    let task: FocusTask

        // A function passed in from the parent view. When this row is tapped,
        // it calls this closure to tell the parent to update the database.
    let toggle: () -> Void

    var body: some View {
            // Wrapping the row in a Button so the user can tap it to complete the task.
        Button(action: toggle) {
            HStack(spacing: 12) {
                    // Show a filled checkmark if completed, or an empty circle if not.
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)

                VStack(alignment: .leading, spacing: 3) {
                    Text(task.title)
                        // Add a line through the text if it's finished.
                        .strikethrough(task.isCompleted)
                        // Fade the text color a bit if it's finished.
                        .foregroundStyle(task.isCompleted ? .secondary : .primary)

                        // Safely check if this task has a category, and if so, show it.
                    if let category = task.category {
                        Text(category.name)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                    // Pushes all of our text and icons to the left side of the screen.
                Spacer()
            }
                // A handy SwiftUI trick: makes the empty space created by the Spacer()
                // tappable, instead of just the text and image.
            .contentShape(Rectangle())
        }
            // Removes the default blue highlight SwiftUI gives to buttons,
            // so it looks like a normal list row.
        .buttonStyle(.plain)
    }
}

#Preview("Task Row") {
        // Standard preview setup using our mock memory database.
    let container = PreviewSupport.makeContainer()
    PreviewSupport.seedIfNeeded(container: container)

    let task = FocusTask(title: "Explain @Query")

    return TaskRow(task: task) { }
        .padding()
        .modelContainer(container)
}
