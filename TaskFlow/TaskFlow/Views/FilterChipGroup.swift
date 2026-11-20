//
//  FilterChipGroup.swift
//  TaskFlow
//
//  Created by Girish Lukka on 18/09/2026.
//
import SwiftUI

    // A generic view that works with any type conforming to ChipDisplayable.
struct FilterChipGroup<Item: ChipDisplayable>: View {
    let items: [Item]

        // @Binding allows this view to read and update selection state back to the caller.
    @Binding var selection: Set<Item>

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(items) { item in
                    chip(for: item)
                }
            }
        }
    }

    private func chip(for item: Item) -> some View {
        let isSelected = selection.contains(item)

        return Label(item.label, systemImage: item.symbolName)
            .font(.footnote.weight(.medium))
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(
                isSelected
                ? item.tint.opacity(0.18)
                : LectureTheme.soft
            )
            .foregroundStyle(isSelected ? LectureTheme.ink : LectureTheme.muted)
            .clipShape(Capsule())
            .overlay {
                Capsule()
                    .stroke(isSelected ? item.tint.opacity(0.75) : LectureTheme.line, lineWidth: 1)
            }
            .onTapGesture {
                toggle(item)
            }
    }

    private func toggle(_ item: Item) {
        if selection.contains(item) {
            selection.remove(item)
        } else {
            selection.insert(item)
        }
    }
}

#Preview {
        // @Previewable allows previews to manage their own local state inline.
    @Previewable @State var selection: Set<Priority> = [.high]

    FilterChipGroup(
        items: Priority.allCases,
        selection: $selection
    )
    .padding()
}
