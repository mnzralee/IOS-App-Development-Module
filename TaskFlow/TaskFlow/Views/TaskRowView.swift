//
//  TaskRowView.swift
//  TaskFlow
//
//  Created by Girish Lukka on 18/09/2026.
//
import SwiftUI

    // Displays an individual task row with a checkbox, title, category, priority, and status badge.
struct TaskRowView: View {
    let task: TaskItem

        // A closure callback (`() -> Void`) executed when the user taps the completion button.
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(task.isDone ? LectureTheme.mintInk : LectureTheme.muted)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.body.weight(.medium))
                    .foregroundStyle(task.isDone ? LectureTheme.muted : LectureTheme.ink)
                    .strikethrough(task.isDone)

                HStack(spacing: 8) {
                    Label(task.category.label, systemImage: task.category.symbolName)
                        .font(.caption)
                        .foregroundStyle(task.category.tint)

                    Image(systemName: task.priority.symbolName)
                        .font(.caption)
                        .foregroundStyle(task.priority.tint)

                    statusBadge(for: task)
                }
            }

            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 6)
    }

        // @ViewBuilder helper function for conditional status badge rendering.
    @ViewBuilder
    private func statusBadge(for task: TaskItem) -> some View {
        if task.isDone {
            Text("Done")
                .font(.caption)
                .foregroundStyle(LectureTheme.muted)
        } else if task.isOverdue {
            Text("Overdue")
                .font(.caption.weight(.semibold))
                .foregroundStyle(LectureTheme.peachInk)
        } else {
            Text(task.statusDescription)
                .font(.caption)
                .foregroundStyle(LectureTheme.muted)
        }
    }
}

#Preview {
    List {
        TaskRowView(task: TaskItem.sampleTasks[0], onToggle: {})
        TaskRowView(task: TaskItem.sampleTasks[3], onToggle: {})
    }
}
