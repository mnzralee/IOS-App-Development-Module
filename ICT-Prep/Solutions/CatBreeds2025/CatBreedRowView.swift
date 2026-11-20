//
//  CatBreedRowView.swift
//  Cat Breeds Explorer (reference solution)
//
//  Each row: image, name, origin, life span, short description (spec section 2).
//

import SwiftUI

struct CatBreedRowView: View {
    let breed: CatBreed

    private let imageSize: CGFloat = 80

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            BreedImageView(url: breed.imageURL)
                .frame(width: imageSize, height: imageSize)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            // Text hierarchy: headline > subheadline > caption
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
                    .lineLimit(3)          // "short" description
            }
        }
        .padding(.vertical, 4)
    }
}

/// Reusable image loader. Handles every AsyncImage phase + the "no image id" case.
struct BreedImageView: View {
    let url: URL?

    var body: some View {
        // AsyncImage with a nil URL stays in .empty forever (endless spinner),
        // so handle nil BEFORE creating it.
        if let url {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    placeholder
                @unknown default:
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

/// Small extra for "SwiftUI navigation" marks.
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

                Text(breed.description)
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle(breed.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    List {
        CatBreedRowView(breed: .sample)
    }
}
