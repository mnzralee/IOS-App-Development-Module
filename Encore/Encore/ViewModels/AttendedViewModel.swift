//
//  AttendedViewModel.swift
//  Encore
//
//  Created by Manazir Ali on 2026-11-07.
//

import Foundation
import SwiftData

@Observable
final class AttendedViewModel {
    var searchedText = ""
    var showingAddSheet = false
    
    func filteredShows(_ shows: [Show]) -> [Show] {
        let attended = shows.filter({ $0.status == .attended })
        guard !searchedText.isEmpty else { return attended }
        return attended.filter {
            $0.artistName.localizedCaseInsensitiveContains(searchedText) || $0.venueName.localizedCaseInsensitiveContains(searchedText) || $0.city.localizedCaseInsensitiveContains(searchedText)
        }
    }
    
    func delete(_ show: Show, context: ModelContext) {
        context.delete(show)
    }
    
}
