# FocusTasks — Lecture 4 Final Demo

SwiftUI • Swift 6.x • Xcode 26.4 • SwiftData • Observation

## Purpose

FocusTasks is the live-code companion to **Lecture 4 — SwiftData & Persistent MVVM**.

The app demonstrates the lecture's central rule:

**READ declaratively. MUTATE deliberately.**

### Read / observation path
`SwiftData → @Query → View`

### Write / command path
`View → ViewModel → DatabaseManager → SwiftData`

## Architecture

- `@Model` defines the persistent domain.
- `ModelContainer` is created once at the App composition root.
- `DatabaseManager` is the mutation boundary; Views supply the shared `ModelContext` when issuing persistence commands.
- `@Observable` ViewModels own commands and transient screen state; they do not store a second data source or the database manager.
- Views use `@Query` for local reads and observation.
- `TaskCategory → FocusTask` demonstrates a one-to-many relationship.
- `.cascade` demonstrates a domain-specific delete rule.
- SwiftUI previews use an in-memory `ModelContainer`.

## Project structure

- `FocusTasksApp.swift` — composition root
- `Models/FocusTask.swift` — persistent task model
- `Models/TaskCategory.swift` — persistent relationship model
- `Database/DatabaseManager.swift` — insert/mutate/delete/save boundary
- `ViewModels/TaskListViewModel.swift` — task commands
- `ViewModels/CategoryListViewModel.swift` — category commands
- `Views/TaskListView.swift` — task UI + `@Query`
- `Views/CategoryListView.swift` — category UI + `@Query`
- `Views/TaskRow.swift` — reusable row
- `PreviewSupport/PreviewSupport.swift` — in-memory preview containers, seed data and preview hosts

## Live demonstration

1. Add a task.
2. Close and relaunch the app — the task persists.
3. Toggle completion.
4. Delete a task.
5. Point out that there is no `loadTasks()` array.
6. Open Categories.
7. Delete a category and observe the cascade.
8. Open a preview and explain the in-memory container.

## Build target

The supplied Xcode project is configured for Swift 6 language mode, strict concurrency checking, iOS 18.0+, and Xcode 26.4 project metadata.


## Preview architecture

Each SwiftUI preview uses:

`in-memory ModelContainer → preview seed data → preview host → shared DatabaseManager → View`

The preview host owns the shared `DatabaseManager` with `@State` and injects it with `environment(...)`, matching the running app's composition root. The preview fixture itself seeds the in-memory `ModelContext` directly so preview setup remains deterministic and does not depend on application commands.
