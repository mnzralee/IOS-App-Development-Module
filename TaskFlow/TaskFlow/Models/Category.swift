//
//  Category.swift
//  TaskFlow
//
//  Created by Girish Lukka on 18/09/2026.
//
import SwiftUI

    // An enum representing different task categories, structured similarly to Priority
    // so they can share the same generic UI components.
enum Category: String, CaseIterable, Identifiable, Hashable {
    case work, personal, study, health

        // Required for Identifiable conformance; uses the case itself as its unique ID.
    var id: Self { self }

    var label: String {
        switch self {
        case .work: "Work"
        case .personal: "Personal"
        case .study: "Study"
        case .health: "Health"
        }
    }
}

    // Separate extension for UI styling and chip display properties.
extension Category: @MainActor ChipDisplayable {
    var tint: Color {
        switch self {
        case .work: LectureTheme.blueInk
        case .personal: LectureTheme.lavenderInk
        case .study: LectureTheme.mintInk
        case .health: LectureTheme.peachInk
        }
    }

    var symbolName: String {
        switch self {
        case .work: "briefcase.fill"
        case .personal: "person.fill"
        case .study: "book.fill"
        case .health: "heart.fill"
        }
    }
}
