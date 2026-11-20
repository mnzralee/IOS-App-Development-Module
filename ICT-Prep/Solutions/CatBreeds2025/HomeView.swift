//
//  HomeView.swift
//  Cat Breeds Explorer (reference solution)
//
//  SwiftUI UI Design (30 marks): greeting, List, loading / error / content states, navigation.
//

import SwiftUI

struct HomeView: View {
    @AppStorage(AppConstants.StorageKeys.userName) private var userName = ""

    // The View OWNS its ViewModel: @State keeps the same instance across redraws.
    @State private var viewModel = CatBreedViewModel()

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Greetings, \(userName)")
                .navigationDestination(for: CatBreed.self) { breed in
                    CatBreedDetailView(breed: breed)
                }
                .task {
                    // Starts when the view appears, auto-cancelled when it disappears.
                    await viewModel.loadIfNeeded()
                }
        }
    }

    // Three UI states: loading, error, list.
    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.breeds.isEmpty {
            ProgressView("Loading breeds...")
        } else if let message = viewModel.errorMessage, viewModel.breeds.isEmpty {
            ContentUnavailableView {
                Label("Could not load breeds", systemImage: "wifi.exclamationmark")
            } description: {
                Text(message)
            } actions: {
                Button("Try Again") {
                    Task { await viewModel.loadBreeds() }
                }
            }
        } else {
            List(viewModel.breeds) { breed in
                NavigationLink(value: breed) {
                    CatBreedRowView(breed: breed)
                }
            }
            .listStyle(.plain)
            .refreshable {
                await viewModel.loadBreeds()
            }
        }
    }
}

#Preview {
    HomeView()
}
