# MovieGenreFilter — Part 3 Solution

Final solution for the **SwiftData Persistence** stage.

- Swift 6.0
- Xcode 26.x project metadata
- SwiftUI
- SwiftData
- MVVM
- Modern Observation (`@Observable`)
- Top-level `Genre`
- `@Query` for live reads
- `DatabaseManager` for writes
- `@ModelActor` for first-launch seeding
- In-memory `PreviewSupport` container

The project preserves the Part 2 UI architecture while replacing the in-memory movie collection with SwiftData persistence.
