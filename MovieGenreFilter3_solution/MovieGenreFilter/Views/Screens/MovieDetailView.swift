import SwiftUI
import SwiftData

struct MovieDetailView: View {
    let movie: Movie

    @Environment(\.modelContext) private var modelContext
    @Environment(DatabaseManager.self) private var dbManager
    @Environment(\.dismiss) private var dismiss

    @State private var showRemoveAlert = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                MovieDetailHeaderView(movie: movie)
                MovieDetailMetaView(movie: movie)
                MovieDetailSynopsisView(movie: movie)
                actionButtons
            }
            .padding()
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.large)
        .alert("Remove from Watchlist?", isPresented: $showRemoveAlert) {
            Button("Remove", role: .destructive) {
                dbManager.delete(movie, context: modelContext)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently remove \"\(movie.title)\".")
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            if !movie.isWatched {
                Button {
                    dbManager.markWatched(movie, context: modelContext)
                } label: {
                    Label("Mark as Watched", systemImage: "checkmark.circle")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .font(.headline)
                }
            }

            Button(role: .destructive) {
                showRemoveAlert = true
            } label: {
                Label("Remove from Watchlist", systemImage: "trash")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .foregroundColor(.red)
                    .cornerRadius(12)
                    .font(.headline)
            }
        }
    }
}

#Preview("Movie Detail") {
    NavigationStack {
        MovieDetailView(movie: PreviewSupport.sampleMovie)
    }
    .environment(DatabaseManager())
    .modelContainer(PreviewSupport.container)
}

#Preview("Movie Detail - Watched") {
    NavigationStack {
        MovieDetailView(movie: PreviewSupport.watchedMovie)
    }
    .environment(DatabaseManager())
    .modelContainer(PreviewSupport.container)
}

struct MovieDetailHeaderView: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: 12) {
            GenreBadgeView(genre: movie.genre, size: 64, iconSize: 28)

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.genre.rawValue.uppercased())
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(movie.genre.color)
                    .tracking(1.2)

                RatingView(rating: movie.rating, showOutOfTen: true)
                    .font(.title3)
            }

            Spacer()

            if movie.isWatched {
                VStack(spacing: 2) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)

                    Text("Watched")
                        .font(.caption2)
                        .foregroundColor(.green)
                }
            }
        }
    }
}

#Preview("Detail Header") {
    MovieDetailHeaderView(movie: PreviewSupport.sampleMovie)
        .padding()
}

#Preview("Detail Header - Watched") {
    MovieDetailHeaderView(movie: PreviewSupport.watchedMovie)
        .padding()
}

struct MovieDetailMetaView: View {
    let movie: Movie

    var formattedDuration: String {
        let hours = movie.duration / 60
        let minutes = movie.duration % 60
        return hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes)m"
    }

    var body: some View {
        HStack(spacing: 0) {
            MetaInfoTileView(
                icon: "calendar",
                label: "Year",
                value: String(movie.year)
            )

            Divider().frame(height: 36)

            MetaInfoTileView(
                icon: "clock",
                label: "Duration",
                value: formattedDuration
            )
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview("Detail Metadata") {
    MovieDetailMetaView(movie: PreviewSupport.sampleMovie)
        .padding()
}

struct MovieDetailSynopsisView: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Synopsis")
                .font(.headline)

            Text(movie.synopsis)
                .font(.body)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
    }
}

#Preview("Synopsis") {
    MovieDetailSynopsisView(movie: PreviewSupport.sampleMovie)
        .padding()
}
