import SwiftData
import SwiftUI

@MainActor
enum PreviewSupport {

    // Preview-only infrastructure. This is separate from MockDataStore,
    // which supplies Sendable seed values for first-launch database seeding.

    static let sampleMovie = Movie(
        title: "The Dark Knight",
        genre: .action,
        rating: 9.0,
        year: 2008,
        synopsis: "Batman faces the Joker.",
        duration: 152,
        isWatched: false
    )

    static let watchedMovie = Movie(
        title: "Dune: Part Two",
        genre: .scifi,
        rating: 8.6,
        year: 2024,
        synopsis: "Paul Atreides joins Chani and the Fremen.",
        duration: 166,
        isWatched: true
    )

    static let container: ModelContainer = {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(
            for: Movie.self,
            configurations: configuration
        )

        let context = container.mainContext
        context.insert(sampleMovie)
        context.insert(watchedMovie)

        return container
    }()
}
