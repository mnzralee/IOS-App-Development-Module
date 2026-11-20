//
//  FilterBarView.swift
//  TaskFlow
//
//  Created by Girish Lukka on 18/09/2026.
//
import SwiftUI

    // Displays filter chips for both priorities and categories,
    // plus a dynamic "Clear filters" button when filters are active.
struct FilterBarView: View {
        // @Bindable creates two-way bindings ($) for properties inside an @Observable view model.
    @Bindable var viewModel: TaskListViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Priority", systemImage: "flag.fill")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(LectureTheme.lavenderInk)

                // Reusable generic chip group for priorities.
            FilterChipGroup(
                items: Priority.allCases,
                selection: $viewModel.selectedPriorities
            )

            Label("Category", systemImage: "square.grid.2x2.fill")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(LectureTheme.blueInk)

                // Reusable generic chip group for categories.
            FilterChipGroup(
                items: Category.allCases,
                selection: $viewModel.selectedCategories
            )

                // Only displays the clear button when filters are actively applied.
            if !viewModel.selectedPriorities.isEmpty ||
                !viewModel.selectedCategories.isEmpty {
                Button("Clear filters") {
                    viewModel.clearFilters()
                }
                .font(.footnote.weight(.medium))
                .foregroundStyle(LectureTheme.blueInk)
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(LectureTheme.blueSurface.opacity(0.55))
                .clipShape(Capsule())
            }
        }
        .padding(14)
        .background(LectureTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(LectureTheme.line, lineWidth: 1)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
    }
}

#Preview {
    FilterBarView(viewModel: TaskListViewModel())
}
