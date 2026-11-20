import Foundation
import Observation
import SwiftData

@MainActor
@Observable
final class MovieListViewModel {

    // UI state belongs here. The live movie collection belongs to @Query.
    var searchText = ""

    func filter(_ movies: [Movie]) -> [Movie] {
        guard !searchText.isEmpty else { return movies }

        return movies.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }

    func deleteMovies(
        at offsets: IndexSet,
        from movies: [Movie],
        dbManager: DatabaseManager,
        context: ModelContext
    ) {
        let filtered = filter(movies)

        for index in offsets {
            dbManager.delete(filtered[index], context: context)
        }
    }
}
