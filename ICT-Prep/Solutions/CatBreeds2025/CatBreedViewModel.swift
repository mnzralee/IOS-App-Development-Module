//
//  CatBreedViewModel.swift
//  Cat Breeds Explorer (reference solution)
//
//  ViewModel Logic (20 marks): owns screen state (breeds, loading, error) and actions.
//  Does NOT import SwiftUI, does NOT decode JSON (that is the service's job).
//

import Foundation
import Observation

@MainActor          // UI state is only mutated on the main thread
@Observable         // views that read these properties redraw when they change
final class CatBreedViewModel {

    // private(set): views can read, only the ViewModel can write
    private(set) var breeds: [CatBreed] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    // A default-argument init (`init(service: CatAPIService = CatAPIService())`) warns in
    // new Xcode projects (MainActor by default), so create the service directly.
    private let service = CatAPIService()

    /// Called from .task: avoids refetching every time the screen reappears.
    func loadIfNeeded() async {
        guard breeds.isEmpty else { return }
        await loadBreeds()
    }

    /// Called from pull-to-refresh and the Try Again button.
    func loadBreeds() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }   // runs on every exit path

        do {
            breeds = try await service.fetchBreeds()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
