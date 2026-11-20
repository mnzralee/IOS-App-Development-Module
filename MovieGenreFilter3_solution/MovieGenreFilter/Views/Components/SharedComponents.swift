import SwiftUI

// MARK: - Genre Badge
// A coloured square tile showing the genre's SF Symbol.
// Used in both MovieRowView (small) and MovieDetailView (large).
struct GenreBadgeView: View {
    let genre: Genre
    let size: CGFloat
    let iconSize: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.25)
                .fill(genre.color.opacity(0.15))
                .frame(width: size, height: size)

            Image(systemName: genre.icon)
                .font(.system(size: iconSize))
                .foregroundColor(genre.color)
        }
    }
}
#Preview("Genre Badge") {
    VStack(spacing: 20) {
        GenreBadgeView(
            genre: .action,
            size: 44,
            iconSize: 18
        )

        GenreBadgeView(
            genre: .scifi,
            size: 64,
            iconSize: 28
        )

        GenreBadgeView(
            genre: .comedy,
            size: 80,
            iconSize: 36
        )
    }
    .padding()
}

// MARK: - Rating View
// A star + numeric rating. showOutOfTen adds the "/ 10" suffix.
struct RatingView: View {
    let rating: Double
    var showOutOfTen: Bool = false

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)

            Text(String(format: "%.1f", rating))
                .fontWeight(.bold)

            if showOutOfTen {
                Text("/ 10")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        }
    }
}
#Preview("Rating") {
    VStack(spacing: 20) {
        RatingView(rating: 8.5)

        RatingView(
            rating: 9.2,
            showOutOfTen: true
        )

        RatingView(
            rating: 5.0,
            showOutOfTen: true
        )
    }
    .padding()
}

// MARK: - Meta Info Tile
// Displays a small icon + label + value block.
// Used in the detail screen for Year and Duration.
struct MetaInfoTileView: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.secondary)

            VStack(alignment: .leading, spacing: 1) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
#Preview("Meta Info Tile") {
    HStack {
        MetaInfoTileView(
            icon: "calendar",
            label: "Year",
            value: "2024"
        )

        Divider()
            .frame(height: 40)

        MetaInfoTileView(
            icon: "clock",
            label: "Duration",
            value: "2h 46m"
        )
    }
    .padding()
}
