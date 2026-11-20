import Foundation
import SwiftData
import Observation

@MainActor
@Observable
final class AddMovieViewModel {

        // Form fields (unchanged from Part 2)
    var title         = ""
    var selectedGenre = Genre.action
    var rating        = 5.0
    var year          = Calendar.current.component(.year, from: Date())
    var synopsis      = ""
    var duration      = 120

    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !synopsis.trimmingCharacters(in: .whitespaces).isEmpty &&
        duration > 0
    }

        // Builds the @Model object and delegates the insert to DatabaseManager
    func saveMovie(dbManager: DatabaseManager, context: ModelContext) {
        let newMovie = Movie(
            title:    title,    genre:    selectedGenre,
            rating:   rating,   year:     year,
            synopsis: synopsis, duration: duration
        )
        dbManager.insert(newMovie, context: context)
    }
}

