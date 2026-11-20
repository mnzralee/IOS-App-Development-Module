//
//  ExtensionExample.swift
//  TaskFlow
//
//  Created by Girish Lukka on 18/09/2026.
//


import Foundation
import Playgrounds

#Playground {
        // 1. Create some sample tasks
    let now = Date.now
    let day: TimeInterval = 86_400
    let tasks =   [
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
            priority: .high,
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


        // 2. Set up our filters
    let selectedPriorities: Set<Priority> = [.high]
    let selectedCategories: Set<Category> = [.work, .health]

        // 3. Call the custom extension method
    let filteredTasks = tasks.filtered(priorities: selectedPriorities, categories: selectedCategories)

        // Result:
        // filteredTasks will contain only:
        // - "Finish homework" (.high, .work)
        // - "Fix bug in app" (.high, .work)
        // ("Buy groceries" is excluded because its priority and category don't match)

}


import Foundation
import Playgrounds

#Playground {
        // 1. Create a brand new task using our custom initializer
        // (Notice we don't need to pass a UUID or `isDone` because the defaults handle it!)
    var myTask = TaskItem(
        title: "Finish SwiftUI assignment",
        priority: .high,
        category: .work,
        dueDate: Calendar.current.date(byAdding: .day, value: 2, to: .now)!
    )

        // 2. Check initial status properties
    print("Title: \(myTask.title)")                  // Finish SwiftUI assignment
    print("Status: \(myTask.statusDescription)")      // Due in 2 days
    print("Is Overdue? \(myTask.isOverdue)")          // false
    print("Is Done? \(myTask.isDone)")                // false

        // 3. Toggle completion state using the mutating method
    myTask.toggleDone()

        // 4. Check the status after completing the task
    print("--- After completing the task ---")
    print("Is Done? \(myTask.isDone)")                // true
    print("Status: \(myTask.statusDescription)")      // Done
}

import Foundation
import Playgrounds

#Playground {
        // 1. Create a task with a deadline in the past (yesterday)
    let pastDate = Calendar.current.date(byAdding: .day, value: -1, to: .now)!

    var overdueTask = TaskItem(
        title: "Submit tax report",
        priority: .high,
        category: .work,
        dueDate: pastDate,
        isDone: false
    )

        // 2. Check if it's overdue
    print(overdueTask.isOverdue)
        // Output: true
        // (Because isDone is false, and dueDate is earlier than .now)

        // 3. Mark the task as done
    overdueTask.toggleDone()

        // 4. Check if it's overdue again
    print(overdueTask.isOverdue)
        // Output: false
        // (Even though the date is still in the past, !isDone is now false, so the task is no longer considered overdue)
}


import Foundation
import Playgrounds

#Playground {
    // 1. Create a few sample tasks out of order
    let tasks = [
        TaskItem(title: "Zebra project", priority: .medium, category: .work, dueDate: .now),
        TaskItem(title: "Apple report", priority: .high, category: .work, dueDate: Calendar.current.date(byAdding: .day, value: 5, to: .now)!),
        TaskItem(title: "Middle management meeting", priority: .low, category: .work, dueDate: Calendar.current.date(byAdding: .day, value: 2, to: .now)!)
    ]

        // 2. Sort the tasks using the `SortOption.title` comparator closure
    let sortedByTitle = tasks.sorted(by: SortOption.title.comparator)

    print("--- Sorted by Title ---")
    for task in sortedByTitle {
        print(task.title)
    }
        // Output:
        // Apple report
        // Middle management meeting
        // Zebra project

        // 3. Sort the tasks using the `SortOption.dueDate` comparator closure
    let sortedByDate = tasks.sorted(by: SortOption.dueDate.comparator)

    print("\n--- Sorted by Due Date ---")
    for task in sortedByDate {
        print("\(task.title) (Due in: \(task.statusDescription))")
    }
}

