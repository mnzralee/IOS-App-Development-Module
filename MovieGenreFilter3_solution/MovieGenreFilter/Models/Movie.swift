import Foundation
import SwiftData
import SwiftUI

@Model
final class Movie {

    // @Attribute(.unique) prevents duplicate entries with the same id
    @Attribute(.unique) var id: UUID
    var title: String
    var genreRawValue: String    // stored primitive for SwiftData
    var rating: Double
    var year: Int
    var synopsis: String
    var duration: Int
    var isWatched: Bool

    // Typed computed accessor - callers use movie.genre, not movie.genreRawValue
    var genre: Genre {
        get { Genre(rawValue: genreRawValue) ?? .drama }
        set { genreRawValue = newValue.rawValue }
    }

    init(title: String, genre: Genre, rating: Double,
         year: Int, synopsis: String, duration: Int,
         isWatched: Bool = false) {
        self.id = UUID()
        self.title = title
        self.genreRawValue = genre.rawValue
        self.rating = rating
        self.year = year
        self.synopsis = synopsis
        self.duration = duration
        self.isWatched = isWatched
    }
}

// Genre is a top-level reusable domain type, unchanged from Parts 1 and 2.
enum Genre: String, CaseIterable, Codable {
    case action = "Action"
    case drama = "Drama"
    case thriller = "Thriller"
    case scifi = "Sci-Fi"
    case comedy = "Comedy"

    var icon: String {
        switch self {
        case .action: return "flame.fill"
        case .drama: return "theatermasks.fill"
        case .thriller: return "eye.trianglebadge.exclamationmark.fill"
        case .scifi: return "sparkles"
        case .comedy: return "face.smiling.fill"
        }
    }

    var color: Color {
        switch self {
        case .action: return .red
        case .drama: return .purple
        case .thriller: return .orange
        case .scifi: return .blue
        case .comedy: return .yellow
        }
    }
}
