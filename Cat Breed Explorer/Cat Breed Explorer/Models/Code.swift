//
//  Code.swift
//  Cat Breed Explorer
//
//  Created by Manazir Ali on 2026-11-20.
//

import SwiftUI
import Observation

// MARK: - 1. Constants
enum APIConstants {
    static let breedsURL = "https://api.thecatapi.com/v1/breeds"
    static let imageBaseURL = "https://cdn2.thecatapi.com/images/"
    static let imageExtension = ".jpg"
}

enum StorageKeys {
    static let hasSeenOnboarding = "hasSeenOnboarding"
    static let userName = "userName"
}

// MARK: - 2. Data Model
struct CatBreed: Codable, Identifiable {
    let id: String
    let name: String
    let origin: String
    let description: String
    let lifeSpan: String
    let referenceImageId: String? // Optional: some breeds in the API omit this key

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case origin
        case description
        case lifeSpan = "life_span"
        case referenceImageId = "reference_image_id"
    }

    var imageURL: URL? {
        guard let imageId = referenceImageId else { return nil }
        return URL(string: "\(APIConstants.imageBaseURL)\(imageId)\(APIConstants.imageExtension)")
    }
}

// MARK: - 3. ViewModel (Networking & State)
@Observable
@MainActor
final class CatBreedsViewModel {
    var breeds: [CatBreed] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil

    func fetchBreeds() async {
        guard let url = URL(string: APIConstants.breedsURL) else {
            errorMessage = "Invalid API URL."
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: request)

            guard let httpResponse = urlResponse as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                errorMessage = "Server returned an unexpected response."
                return
            }

            let decodedBreeds = try JSONDecoder().decode([CatBreed].self, from: data)
            self.breeds = decodedBreeds
        } catch {
            errorMessage = "Failed to load cat breeds. Please try again."
        }
    }
}

// MARK: - 4. App Entry Point
@main
struct CatBreedsApp: App {
    @AppStorage(StorageKeys.hasSeenOnboarding) private var hasSeenOnboarding: Bool = false

    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                HomeView()
            } else {
                OnboardingView()
            }
        }
    }
}

// MARK: - 5. Onboarding View
struct OnboardingView: View {
    @AppStorage(StorageKeys.hasSeenOnboarding) private var hasSeenOnboarding: Bool = false
    @AppStorage(StorageKeys.userName) private var userName: String = ""

    @State private var nameInput: String = ""

    private var trimmedName: String {
        nameInput.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "cat.fill")
                .font(.system(size: 64))
                .foregroundStyle(.orange)

            Text("Cats App")
                .font(.largeTitle.bold())

            Text("Tell us your name")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            TextField("Enter your name", text: $nameInput)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.done)
                .padding(.horizontal, 32)

            Button("Continue") {
                userName = trimmedName
                hasSeenOnboarding = true
            }
            .buttonStyle(.borderedProminent)
            .disabled(trimmedName.isEmpty)

            Spacer()
        }
        .padding()
    }
}

// MARK: - 6. Home View & Row Component
struct HomeView: View {
    @AppStorage(StorageKeys.userName) private var userName: String = ""
    @State private var viewModel = CatBreedsViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading cat breeds...")
                } else if let errorMessage = viewModel.errorMessage {
                    ContentUnavailableView {
                        Label("Unable to Load", systemImage: "wifi.slash")
                    } description: {
                        Text(errorMessage)
                    } actions: {
                        Button("Retry") {
                            Task { await viewModel.fetchBreeds() }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    List(viewModel.breeds) { breed in
                        CatBreedRow(breed: breed)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Greetings, \(userName)")
            .task {
                if viewModel.breeds.isEmpty {
                    await viewModel.fetchBreeds()
                }
            }
        }
    }
}

struct CatBreedRow: View {
    let breed: CatBreed

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: breed.imageURL) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else if phase.error != nil {
                    Image(systemName: "cat")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                } else {
                    ProgressView()
                }
            }
            .frame(width: 80, height: 80)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(breed.name)
                    .font(.headline)

                Text("\(breed.origin) • \(breed.lifeSpan) yrs")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(breed.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview("Home") {
    HomeView()
}

#Preview("Onboarding") {
    OnboardingView()
}
