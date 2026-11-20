//
//  Priority.swift
//  TaskFlow
//
//  Created by Girish Lukka on 18/09/2026.
//
import SwiftUI

    // An enum with safe, named cases instead of raw strings.
enum Priority: String, CaseIterable, Identifiable, Hashable {
    case low, medium, high

        // Required for Identifiable conformance; uses the case itself as its unique ID.
    var id: Self { self }

    var label: String {
            // Exhaustive switch: if a new case is added, the compiler forces you to handle it here.
        switch self {
        case .low: "Low"
        case .medium: "Medium"
        case .high: "High"
        }
    }
}

    // Separate extension for UI display logic to keep the core model clean.
extension Priority: @MainActor ChipDisplayable {
    var tint: Color {
        switch self {
        case .low: LectureTheme.mintInk
        case .medium: LectureTheme.peachInk
        case .high: LectureTheme.lavenderInk
        }
    }

    var symbolName: String {
        switch self {
        case .low: "flag"
        case .medium: "flag.fill"
        case .high: "flag.fill"
        }
    }
}
