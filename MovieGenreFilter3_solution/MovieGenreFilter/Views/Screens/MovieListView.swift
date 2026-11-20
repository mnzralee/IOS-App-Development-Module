import SwiftUI
import SwiftData

struct MovieListView: View {

    @Environment(\.modelContext) private var modelContext
    @Environment(UserPreferences.self) private var preferences
    @Environment(DatabaseManager.self) private var dbManager

        // @Query is the SSOT for displayed data. Sorted A→Z by title.
    @Query(sort: \Movie.title) private var movies: [Movie]

    @State private var viewModel   = MovieListViewModel()
    @State private var showAddMovie = false
    @State private var showSettings = false

    private var filteredMovies: [Movie] { viewModel.filter(movies) }

    private var navigationTitle: String {
        preferences.displayName.isEmpty ? "Movie List"
        : "\(preferences.displayName)'s Movies"
    }

    var body: some View {
        @Bindable var vm       = viewModel
        @Bindable var bindableDB = dbManager   // needed for $bindableDB.showError

        NavigationStack {
            List {
                ForEach(filteredMovies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        MovieRowView(movie: movie)
                    }
                }
                .onDelete { offsets in
                    viewModel.deleteMovies(at: offsets, from: movies,
                                           dbManager: dbManager, context: modelContext)
                }
            }
            .listStyle(.plain)
            .searchable(text: $vm.searchText, prompt: "Search movies…")
            .animation(.default, value: filteredMovies.map { $0.id })
            .navigationTitle(navigationTitle)
            .toolbar { toolbarContent }
            .sheet(isPresented: $showAddMovie) { AddMovieView() }
            .sheet(isPresented: $showSettings) { SettingsSheetView() }
                // DatabaseManager surfaces errors via this alert
            .alert("Database Error", isPresented: $bindableDB.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(dbManager.errorMessage ?? "An unexpected error occurred.")
            }
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack(spacing: 16) {
                Button { showAddMovie = true } label: {
                    Image(systemName: "plus")
                        .accessibilityLabel("Add Movie")
                }
                Button { showSettings = true } label: {
                    Image(systemName: "gearshape")
                        .accessibilityLabel("Settings")
                }
            }
        }
    }
}
    // MARK: - Preview
#Preview("Movie List — SwiftData") {
    MovieListView()
        .environment(UserPreferences())
        .environment(DatabaseManager())
        .modelContainer(PreviewSupport.container)
}


