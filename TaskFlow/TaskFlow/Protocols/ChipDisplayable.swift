//
//  ChipDisplayable.swift
//  TaskFlow
//
//  Created by Girish Lukka on 18/09/2026.
//
import SwiftUI

    // A protocol defining a contract for anything that can be displayed as a filter chip.
    // Inherits from Hashable, Identifiable, and CaseIterable so generic views can
    // easily manage selection states and loop through cases.
    // Marked @MainActor to satisfy Swift 6 concurrency requirements for UI-related types.
@MainActor
protocol ChipDisplayable: Hashable, Identifiable, CaseIterable {
    var label: String { get }
    var tint: Color { get }
    var symbolName: String { get }
}
