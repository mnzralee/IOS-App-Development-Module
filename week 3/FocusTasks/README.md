# FocusTasks — Lecture 3 final demo

This reduced demo is aligned with the final Lecture 3 architecture: **State, Data Flow & MVVM**.

## What it demonstrates

- **Single Source of Truth:** `TaskStore` owns the task collection.
- **Modern Observation:** `TaskStore` and `TaskListViewModel` use `@Observable`.
- **@State:** the App owns the lifetime of the Store and ViewModel references.
- **@Binding:** `SearchField` receives read/write access to `searchText`.
- **@Bindable:** `TaskListView` creates bindings to properties on its observable ViewModel.
- **@Environment:** shared application objects are injected from the App composition root; `SettingsView` also reads the system `colorScheme`.
- **Dependency Injection:** the App creates the Store, connects the ViewModel to that exact Store instance, then injects both.
- **MVVM:** Model describes data, Store owns mutable truth, ViewModel owns screen logic, View owns presentation.

## Architecture

```text
FocusTasksApp  — composition root
      │
      ├── TaskStore                 ← SSOT
      │
      └── TaskListViewModel(store)  ← screen logic
               │
               └── same TaskStore instance

      inject both through Environment
              ↓
      ┌───────────────┬───────────────┐
      ↓                               ↓
 TaskListView                    SettingsView
      │                               │
 @Bindable                       @Environment
      │                               │
 View → ViewModel → Store       reads same Store
```

## Suggested live-demo sequence

1. **Ownership:** open `TaskStore.swift` and ask who owns `tasks`.
2. **Observation:** toggle a task and observe the UI update without `@Published`.
3. **@Binding:** open `SearchField.swift` and ask who owns `text`.
4. **@Bindable:** open `TaskListView.swift` and trace `$viewModel.searchText`.
5. **MVVM:** open `TaskListViewModel.swift` and identify filtering, sorting and actions.
6. **Composition root:** open `FocusTasksApp.swift` and identify CREATE → CONNECT → INJECT.
7. **Environment:** open `SettingsView.swift` and show that it reads the same Store without prop drilling.
8. **SSOT payoff:** toggle a task in Tasks, then switch to Settings and observe the shared count.

## Previews

`SearchField`, `TaskRowView`, `TaskListView`, `SettingsView` and the complete app have SwiftUI `#Preview` examples.

## Deliberately excluded

- SwiftData persistence
- networking
- add/edit workflows
- detail screens
- unnecessary services
- legacy `ObservableObject`/Combine architecture

The aim is to make data ownership and data flow visible. Persistence is intentionally deferred to Week 4.

## Xcode setup

An Xcode project is included. Open `FocusTasks_Lecture3.xcodeproj` in Xcode 26.x. It targets iOS 18+ and uses Swift 6 with complete strict concurrency checking. The project contains the supplied Swift files and previews.

## Xcode 26 / iOS 26 launch-screen configuration

The project uses Xcode-generated `UILaunchScreen` metadata. This is required for a current SwiftUI iPhone target and avoids legacy/compatibility presentation on current simulators.
