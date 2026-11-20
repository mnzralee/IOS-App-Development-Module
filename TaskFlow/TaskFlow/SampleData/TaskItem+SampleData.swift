//
//  TaskItem+SampleData.swift
//  TaskFlow
//
//  Created by Girish Lukka on 18/09/2026.
//
import Foundation

// Sample data lives in its own extension file, separate from the
// TaskItem declaration itself — the model doesn't need to know it's
// sometimes used for previews and first-run content.
extension TaskItem {
    static var sampleTasks: [TaskItem] {
        let now = Date.now
        let day: TimeInterval = 86_400

        // Due dates are expressed relative to "now" (some in the
        // past, to exercise isOverdue; one already marked isDone, to
        // exercise the "Done" branch of statusDescription) so this
        // data stays meaningful no matter when the app is actually run.
        return [
            TaskItem(
                title: "Finish SwiftUI lecture slides",
                priority: .high,
                category: .work,
                dueDate: now.addingTimeInterval(-day)
            ),
            TaskItem(
                title: "Read Ch.4 — Protocols",
                priority: .medium,
                category: .study,
                dueDate: now.addingTimeInterval(day)
            ),
            TaskItem(
                title: "Grade CineTrack submissions",
                priority: .high,
                category: .work,
                dueDate: now.addingTimeInterval(2 * day)
            ),
            TaskItem(
                title: "Morning run",
                priority: .low,
                category: .health,
                dueDate: now,
                isDone: true
            ),
            TaskItem(
                title: "Book dentist appointment",
                priority: .low,
                category: .personal,
                dueDate: now.addingTimeInterval(5 * day)
            ),
            TaskItem(
                title: "Prepare closures tutorial demo",
                priority: .medium,
                category: .work,
                dueDate: now.addingTimeInterval(3 * day)
            )
        ]
    }
}
