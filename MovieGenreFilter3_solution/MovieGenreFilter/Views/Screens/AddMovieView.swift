import SwiftUI
import SwiftData

struct AddMovieView: View {

    @Environment(\.modelContext) private var modelContext
    @Environment(DatabaseManager.self) private var dbManager
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel = AddMovieViewModel()

    var body: some View {
        @Bindable var vm = viewModel

        NavigationStack {
            Form {
                Section("Basic Information") {
                    TextField("Movie Title", text: $vm.title)
                        .textInputAutocapitalization(.words)

                    Picker("Genre", selection: $vm.selectedGenre) {
                        ForEach(Genre.allCases, id: \.self) { genre in
                            Label(genre.rawValue, systemImage: genre.icon)
                                .tag(genre)
                        }
                    }
                }

                Section("Details") {
                    Stepper("Year: \(viewModel.year)", value: $vm.year, in: 1900...2100)

                    VStack(alignment: .leading) {
                        HStack {
                            Text("Rating")
                            Spacer()
                            RatingView(rating: viewModel.rating)
                        }

                        Slider(value: $vm.rating, in: 0...10, step: 0.1)
                            .tint(.yellow)
                    }

                    Stepper(
                        "Duration: \(viewModel.duration) min",
                        value: $vm.duration,
                        in: 1...500
                    )
                }

                Section("Synopsis") {
                    TextEditor(text: $vm.synopsis)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("New Movie")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.saveMovie(
                            dbManager: dbManager,
                            context: modelContext
                        )
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .disabled(!viewModel.isFormValid)
                }
            }
        }
    }
}

#Preview("Add Movie") {
    AddMovieView()
        .environment(DatabaseManager())
        .modelContainer(PreviewSupport.container)
}
