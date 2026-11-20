//
//  SectionCard_ViewBuilder_Demo.swift
//  TaskFlow
//
//  Created by Girish Lukka on 18/09/2026.
//
import SwiftUI

    /// Optional lecture demo showing a generic container that accepts custom content via @ViewBuilder.
    /// Not part of the core app, but used as a teaching example for building custom containers.
struct SectionCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)

                // Inserts the caller's custom view content dynamically.
            content
        }
        .padding()
        .background(LectureTheme.soft, in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    VStack {
            // Reusing the same SectionCard component with entirely different view bodies.
        SectionCard(title: "Filters") {
            Text("Any SwiftUI content can go here.")
        }

        SectionCard(title: "Another example") {
            Text("Any SwiftUI content can go here.")
            HStack {
                Image(systemName: "line.3.horizontal.decrease.circle")
                Text("Filter controls")
            }
        }
    }
    .padding()
}

