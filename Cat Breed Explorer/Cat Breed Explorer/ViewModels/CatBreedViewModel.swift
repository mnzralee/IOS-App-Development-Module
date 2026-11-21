//
//  CatBreedViewModel.swift
//  Cat Breed Explorer
//
//  Created by Manazir Ali on 2026-11-16.
//
//  VIEWMODEL: owns the SCREEN'S state (breeds, loading, error) and the actions that change it.
//  Does NOT import SwiftUI. Does NOT decode JSON (the service does that).
//  Marks: "ViewModel Logic: state management, clean separation of concerns" (20)
//

import Foundation
import Observation

@MainActor      // its properties drive the UI, and UI state must change on the main thread
@Observable     // any view that READS a property here redraws when that property changes
final class CatBreedViewModel {

    // private(set): views can READ these, only the ViewModel can WRITE them.
    // One controlled path for every change.
    private(set) var breeds: [CatBreed] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?      // nil = no error

    // The ViewModel USES the service but doesn't know how networking works.
    // (In a bigger app you'd pass this in through init: "dependency injection".)
    private let service = CatAPIService()

    /// Used by `.task`: only fetch the first time, not every time the screen reappears
    /// (e.g. coming back from the detail screen).
    func loadIfNeeded() async {
        guard breeds.isEmpty else { return }
        await loadBreeds()
    }

    /// Used by pull-to-refresh and the "Try Again" button.
    func loadBreeds() async {
        guard !isLoading else { return }      // ignore double taps while a request is running

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }           // `defer` runs when the function exits, success OR failure

        do {
            breeds = try await service.fetchBreeds()
        } catch {
            // CatAPIError's errorDescription becomes the text shown on screen
            errorMessage = error.localizedDescription
        }
    }
}
