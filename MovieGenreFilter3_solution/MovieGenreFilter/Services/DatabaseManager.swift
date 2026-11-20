import Foundation
import Observation
import SwiftData

@MainActor
@Observable
final class DatabaseManager {

    var errorMessage: String?
    var showError = false

    func insert(_ movie: Movie, context: ModelContext) {
        context.insert(movie)
        save(context: context)
    }

    func delete(_ movie: Movie, context: ModelContext) {
        context.delete(movie)
        save(context: context)
    }

    func markWatched(_ movie: Movie, context: ModelContext) {
        movie.isWatched = true
        save(context: context)
    }

    func save(context: ModelContext) {
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            record(error)
        }
    }

    func record(_ error: Error) {
        errorMessage = "Failed to save: \(error.localizedDescription)"
        showError = true
    }
}
