//
//  TaskListView.swift
//  TaskFlow
//
//  Created by Girish Lukka on 18/09/2026.
//
import SwiftUI

    // The main screen of the app, holding the view model and organizing tasks into a list.
struct TaskListView: View {
        // Owns and initializes the view model instance for the entire screen.
    @State private var viewModel = TaskListViewModel()

    var body: some View {
        NavigationStack {
            List {
                    // Section for filtering options at the top of the list.
                Section {
                    FilterBarView(viewModel: viewModel)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }
                .listSectionSeparator(.hidden)

                    // Section displaying either the filtered task rows or an empty state view.
                Section {
                    if viewModel.filteredTasks.isEmpty {
                        ContentUnavailableView(
                            "No matching tasks",
                            systemImage: "checklist",
                            description: Text("Try clearing a filter.")
                        )
                    } else {
                        ForEach(viewModel.filteredTasks) { task in
                                // Passes a closure handling the toggle action when a task is tapped.
                            TaskRowView(task: task) {
                                viewModel.toggleDone(task)
                            }
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(LectureTheme.card)
                            )
                        }
                    }
                } header: {
                    Label("Tasks", systemImage: "checklist")
                        .font(.headline)
                        .foregroundStyle(LectureTheme.ink)
                        .textCase(nil)
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(LectureTheme.soft)
            .navigationTitle("TaskFlow")
        }
    }
}

#Preview {
    TaskListView()
}
