    //  SearchField.swift
    //  FocusTasks
    //
    //  Created by Girish Lukka on 18/09/2026.
    //

import SwiftUI

    // A reusable search bar component that binds to a text string in the parent view
struct SearchField: View {
    @Binding var text: String

    var body: some View {
        HStack {
                // Search icon on the left
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

                // Text input field for typing search queries
            TextField("Search tasks", text: $text)

                // Clear button appears only when there is text typed in
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(10)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 10))
    }
}

    // Preview provider for the search field
#Preview("SearchField") {
    SearchFieldPreview()
}

    // Helper struct to provide local state for testing the search field in previews
private struct SearchFieldPreview: View {
    @State private var text = "swift"

    var body: some View {
        SearchField(text: $text)
            .padding()
    }
}
