//
//  CatAPIService.swift
//  Cat Breed Explorer
//
//  Created by Manazir Ali on 2026-11-16.
//
//  SERVICE: talks to the server. Ask, wait, check, then decode (Lecture 5).
//  Knows nothing about SwiftUI or the screen.
//  Marks: "Networking: async/await, URLSession call, error handling, decoding logic" (15)
//

import Foundation

// All API text in ONE place ("Code Quality: constants usage, minimal hardcoding").
// Stored as Strings so the service builds the URL safely with `guard` (no force unwrap `!`).
enum APIConstants {
    static let breedsURL = "https://api.thecatapi.com/v1/breeds"
    static let imageBaseURL = "https://cdn2.thecatapi.com/images/"
    static let imageExtension = ".jpg"

    // TheCatAPI now answers 403 without a key. Paste a free key from thecatapi.com
    // here to make the app load real data. Empty = no header is sent.
    static let apiKey = ""
    static let apiKeyHeader = "x-api-key"
}

// Every way the request can fail, with a message the user can read.
// LocalizedError + errorDescription -> `error.localizedDescription` returns these texts.
enum CatAPIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case badStatus(Int)          // carries the status code, e.g. 403, 404, 500
    case decodingError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The breed URL is invalid."
        case .invalidResponse:
            return "The server sent an unexpected response."
        case .badStatus(let code):
            return "The server returned status \(code)."
        case .decodingError:
            return "The breed data could not be read."
        }
    }
}

struct CatAPIService {

    // async  -> waits for the network without freezing the UI
    // throws -> can fail; the caller must use `try`
    // [CatBreed] -> /v1/breeds returns a JSON ARRAY: [ {...}, {...} ]
    func fetchBreeds() async throws -> [CatBreed] {

        // 1. BUILD the request
        // URL(string:) returns an optional, so unwrap it or leave early.
        guard let url = URL(string: APIConstants.breedsURL) else {
            throw CatAPIError.invalidURL
        }
        var request = URLRequest(url: url)
        if !APIConstants.apiKey.isEmpty {
            request.setValue(APIConstants.apiKey, forHTTPHeaderField: APIConstants.apiKeyHeader)
        }

        // 2. ASK and WAIT
        // `await` suspends here until the server replies. `try` because no internet / timeout throws.
        // data = raw JSON bytes, response = status code + headers.
        let (data, response) = try await URLSession.shared.data(for: request)

        // 3. CHECK the reply
        // URLSession does NOT throw for 403/404/500, so check the status ourselves.
        // Without this you'd try to decode an error message as cats and get a confusing error.
        guard let httpResponse = response as? HTTPURLResponse else {
            throw CatAPIError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw CatAPIError.badStatus(httpResponse.statusCode)
        }

        // 4. DECODE the JSON into [CatBreed] using the CodingKeys
        do {
            return try JSONDecoder().decode([CatBreed].self, from: data)
        } catch {
            // The real reason (keyNotFound / typeMismatch / valueNotFound) goes to the console for you.
            // The user gets the friendly message from CatAPIError.
            print("Decoding error: \(error)")
            throw CatAPIError.decodingError
        }
    }
}
