//
//  TaskListView2.swift
//  FocusTasks
//
//  Created by girish lukka on 19/09/2026.
//

import SwiftUI
import SwiftData

struct TaskListView2: View {
    @Query(sort: \FocusTask.createdAt, order: .reverse)
    private var tasks: [FocusTask]

        // 1. Fetch categories so we can display them as options in our picker
    @Query(sort: \TaskCategory.name)
    private var categories: [TaskCategory]

    @Environment(\.modelContext)
    private var modelContext

    @Environment(DatabaseManager.self)
    private var dbManager

    @State private var viewModel = TaskListViewModel()
    @State private var showingCategories = false

        // 2. Track which category the user wants to assign to the new task
    @State private var selectedCategory: TaskCategory? = nil

    var body: some View {
        @Bindable var dbManager = dbManager

        return NavigationStack {
            List {
                if tasks.isEmpty {
                    ContentUnavailableView(
                        "No Tasks",
                        systemImage: "checklist",
                        description: Text("Add a task to get started.")
                    )
                } else {
                    ForEach(tasks) { task in
                        TaskRow(task: task) {
                            viewModel.toggleCompletion(task, dbManager: dbManager, context: modelContext)
                        }
                    }
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
            .safeAreaInset(edge: .bottom) {
                addBar
            }
            .sheet(isPresented: $showingCategories) {
                CategoryListView()
            }
            .alert("Persistence Error", isPresented: $dbManager.showError) {
                Button("OK") { }
            } message: {
                Text(dbManager.errorMessage ?? "An unexpected error occurred.")
            }
        }
    }

    private var addBar: some View {
        @Bindable var viewModel = viewModel

        return HStack(spacing: 12) {
            TextField("New task", text: $viewModel.newTaskTitle)
                .textFieldStyle(.roundedBorder)

                // The category picker is now much more visible
            Menu {
                Button("No Category") { selectedCategory = nil }
                Divider()
                ForEach(categories) { category in
                    Button(category.name) {
                        selectedCategory = category
                    }
                }
            } label: {
                if let selected = selectedCategory {
                        // Show a nice blue pill with the category name when selected
                    Text(selected.name)
                        .font(.footnote)
                        .fontWeight(.medium)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.15))
                        .foregroundStyle(.blue)
                        .clipShape(Capsule())
                } else {
                        // Show an explicit "add folder" icon when nothing is selected
                    Image(systemName: "folder.badge.plus")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
            }

            Button {
                viewModel.addTask(category: selectedCategory, dbManager: dbManager, context: modelContext)
                selectedCategory = nil
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
            }
            .disabled(viewModel.newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
        .background(.bar)
    }
}

#Preview("Tasks") {
    let container = PreviewSupport.makeContainer()
    PreviewSupport.seedIfNeeded(container: container)

    return TaskListPreviewHost(container: container)
}
