import Foundation

// MARK: - Sendable seed data
// Part 3 no longer shares SwiftData @Model instances across actors.
// Seed data contains only value types so it can safely cross isolation boundaries.
struct MovieSeed: Sendable {
    let title: String
    let genreRawValue: String
    let rating: Double
    let year: Int
    let synopsis: String
    let duration: Int
    let isWatched: Bool
}

// MARK: - Centralised Seed Data
// The static property is explicitly nonisolated so the @ModelActor seeder
// can read it even though the project uses MainActor as its default isolation.
enum MockDataStore {
    nonisolated static let movies: [MovieSeed] = [
        MovieSeed(title: "Oppenheimer", genreRawValue: "Drama", rating: 8.9, year: 2023,
                  synopsis: "The story of J. Robert Oppenheimer's role in the development of the atomic bomb during WWII, and the political aftermath that followed.",
                  duration: 180, isWatched: false),

        MovieSeed(title: "Dune: Part Two", genreRawValue: "Sci-Fi", rating: 8.6, year: 2024,
                  synopsis: "Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family.",
                  duration: 166, isWatched: true),

        MovieSeed(title: "The Dark Knight", genreRawValue: "Action", rating: 9.0, year: 2008,
                  synopsis: "Batman faces the Joker, a criminal mastermind who plunges Gotham City into anarchy and forces Batman to question everything he believes.",
                  duration: 152, isWatched: true),

        MovieSeed(title: "Parasite", genreRawValue: "Thriller", rating: 8.5, year: 2019,
                  synopsis: "A poor family schemes to become employed by a wealthy family by posing as unrelated, highly qualified individuals.",
                  duration: 132, isWatched: false),

        MovieSeed(title: "Interstellar", genreRawValue: "Sci-Fi", rating: 8.7, year: 2014,
                  synopsis: "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival as Earth faces catastrophe.",
                  duration: 169, isWatched: false),

        MovieSeed(title: "Mad Max: Fury Road", genreRawValue: "Action", rating: 8.1, year: 2015,
                  synopsis: "In a post-apocalyptic wasteland, a woman rebels against a tyrannical ruler in search of her homeland with the help of a group of female prisoners.",
                  duration: 120, isWatched: true),

        MovieSeed(title: "Knives Out", genreRawValue: "Thriller", rating: 7.9, year: 2019,
                  synopsis: "A detective investigates the death of a patriarch of an eccentric, combative family. A clever whodunit that keeps you guessing.",
                  duration: 130, isWatched: false),

        MovieSeed(title: "The Grand Budapest Hotel", genreRawValue: "Comedy", rating: 8.1, year: 2014,
                  synopsis: "A writer encounters the owner of an aging European hotel between the wars, who tells him of his years serving as a lobby boy.",
                  duration: 99, isWatched: true),

        MovieSeed(title: "Arrival", genreRawValue: "Sci-Fi", rating: 7.9, year: 2016,
                  synopsis: "A linguist works with the military to communicate with alien lifeforms after twelve mysterious spacecraft appear around the world.",
                  duration: 116, isWatched: false)
    ]
}
