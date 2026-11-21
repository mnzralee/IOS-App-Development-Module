//
//  CatBreedRowView.swift
//  Cat Breed Explorer
//
//  Created by Manazir Ali on 2026-11-16.
//
//  ROW: image, name, origin, life span, short description (spec section 2).
//  Also: a reusable image view and a small detail screen (extra "SwiftUI navigation" marks).
//

import SwiftUI

struct CatBreedRowView: View {
    let breed: CatBreed      // plain `let`: the row only DISPLAYS data, it never changes it

    private let imageSize: CGFloat = 80     // named constant instead of a magic number

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            BreedImageView(url: breed.imageURL)
                .frame(width: imageSize, height: imageSize)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            // TEXT HIERARCHY: headline (most important) > subheadline > caption
            VStack(alignment: .leading, spacing: 4) {
                Text(breed.name)
                    .font(.headline)

                Label(breed.origin, systemImage: "globe")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Label("\(breed.lifeSpan) years", systemImage: "heart")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(breed.description)
                    .font(.caption)
                    .lineLimit(3)            // "short description": cut after 3 lines
            }
        }
        .padding(.vertical, 4)
    }
}

/// Reusable image loader, used by the row AND the detail screen (DRY).
struct BreedImageView: View {
    let url: URL?

    var body: some View {
        // AsyncImage with a nil URL stays in .empty forever (endless spinner),
        // so deal with "no image id" BEFORE creating it.
        if let url {
            // AsyncImage downloads the image itself and reports its progress as a `phase`
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:                    // still downloading
                    ProgressView()
                case .success(let image):       // downloaded
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:                  // download failed
                    placeholder
                @unknown default:               // future cases Apple might add
                    placeholder
                }
            }
        } else {
            placeholder
        }
    }

    private var placeholder: some View {
        ZStack {
            Color.secondary.opacity(0.15)
            Image(systemName: "photo")
                .foregroundStyle(.secondary)
        }
    }
}

/// Pushed by NavigationLink(value:) in HomeView.
struct CatBreedDetailView: View {
    let breed: CatBreed

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                BreedImageView(url: breed.imageURL)
                    .frame(height: 260)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                Text(breed.name)
                    .font(.largeTitle)
                    .bold()

                Label("Origin: \(breed.origin)", systemImage: "globe")
                Label("Life span: \(breed.lifeSpan) years", systemImage: "heart")

                Text(breed.description)    // full text here, no lineLimit
            }
            .padding()
        }
        .navigationTitle(breed.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Previews use the fake `sample`, so they work with no network.
#Preview("Row") {
    List {
        CatBreedRowView(breed: .sample)
    }
}

#Preview("Detail") {
    NavigationStack {
        CatBreedDetailView(breed: .sample)
    }
}
