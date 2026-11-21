//
//  HomeView.swift
//  Cat Breed Explorer
//
//  Created by Manazir Ali on 2026-11-16.
//
//  HOME: "Greetings, {name}" + the breed list. Shows one of three states: loading, error, list.
//  Marks: "SwiftUI UI Design: state management, List layout, AsyncImage, text hierarchy" (30)
//

import SwiftUI

struct HomeView: View {
    // Reads the name saved by OnboardingView (same key = same value)
    @AppStorage(StorageKeys.userName) private var userName = ""

    // The view OWNS its ViewModel. @State keeps the SAME instance alive across redraws
    // (without @State a new ViewModel would be created every time the body runs).
    @State private var viewModel = CatBreedViewModel()

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Greetings, \(userName)")
                // Where a tapped NavigationLink(value: breed) goes
                .navigationDestination(for: CatBreed.self) { breed in
                    CatBreedDetailView(breed: breed)
                }
                // .task = async work tied to the view: starts when it appears,
                // cancelled automatically when it disappears.
                .task {
                    await viewModel.loadIfNeeded()
                }
        }
    }

    // @ViewBuilder lets a computed property return DIFFERENT views from if / else branches.
    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.breeds.isEmpty {
            // 1. LOADING (first load only; on refresh the old list stays visible)
            ProgressView("Loading breeds...")

        } else if let message = viewModel.errorMessage, viewModel.breeds.isEmpty {
            // 2. ERROR (e.g. "The server returned status 403.") with a retry button
            ContentUnavailableView {
                Label("Could not load breeds", systemImage: "wifi.exclamationmark")
            } description: {
                Text(message)
            } actions: {
                Button("Try Again") {
                    // A Button action is not async, so start a Task to call the async function
                    Task { await viewModel.loadBreeds() }
                }
            }

        } else {
            // 3. THE LIST: one reusable row per breed (List uses `id` from Identifiable)
            List(viewModel.breeds) { breed in
                NavigationLink(value: breed) {
                    CatBreedRowView(breed: breed)
                }
            }
            .listStyle(.plain)
            .refreshable {                       // pull down to reload
                await viewModel.loadBreeds()
            }
        }
    }
}

#Preview {
    HomeView()
}
