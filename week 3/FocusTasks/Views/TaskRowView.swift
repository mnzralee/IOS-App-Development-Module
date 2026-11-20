    //  TaskRowView.swift
    //  FocusTasks
    //
    //  Created by Girish Lukka on 18/09/2026.
    //

import SwiftUI

    // Displays a single row in the task list with a checkbox, title, and priority badge
struct TaskRowView: View {
    let task: TaskItem
    let onToggle: () -> Void // Closure triggered when the user taps the completion button

    var body: some View {
        HStack {
                // Checkbox button that changes appearance depending on completion status
            Button(action: onToggle) {
                Image(
                    systemName: task.isComplete
                    ? "checkmark.circle.fill"
                    : "circle"
                )
                .foregroundStyle(task.isComplete ? .green : .secondary)
            }
            .buttonStyle(.plain)

                // Task title text; adds a strikethrough effect when completed
            Text(task.title)
                .strikethrough(task.isComplete)

            Spacer()

                // Displays the priority level badge on the right side
            Text(task.priority.rawValue.capitalized)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

    // Preview provider for testing an individual task row
#Preview("TaskRowView") {
    TaskRowView(
        task: TaskItem(title: "Example task", priority: .high),
        onToggle: {}
    )
    .padding()
}
