//
//  CatAPIService.swift
//  Cat Breeds Explorer (reference solution)
//
//  Networking (15 marks): URLSession + async/await, status check, error handling, decoding.
//  Lecture 5 rule: "Ask, wait, check, then decode".
//  The service owns networking + decoding. The ViewModel never touches JSON.
//

import Foundation

enum CatAPIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case badStatus(Int)
    case decodingFailed

    // What the user sees (error.localizedDescription uses this).
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The breeds URL is invalid."
        case .invalidResponse:
            return "The server sent an unexpected response."
        case .badStatus(let code):
            return "The server returned status \(code)."
        case .decodingFailed:
            return "The breed data could not be read."
        }
    }
}

struct CatAPIService {

    func fetchBreeds() async throws -> [CatBreed] {
        // 1. Build the request
        guard let url = URL(string: AppConstants.API.breedsURL) else {
            throw CatAPIError.invalidURL
        }
        var request = URLRequest(url: url)
        if !AppConstants.API.apiKey.isEmpty {
            request.setValue(AppConstants.API.apiKey, forHTTPHeaderField: AppConstants.API.apiKeyHeader)
        }

        // 2. Ask and wait (suspends, does not block the main thread)
        let (data, response) = try await URLSession.shared.data(for: request)

        // 3. Check: a reply is not automatically a SUCCESSFUL reply
        guard let httpResponse = response as? HTTPURLResponse else {
            throw CatAPIError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw CatAPIError.badStatus(httpResponse.statusCode)
        }

        // 4. Decode: the top level of /v1/breeds is a JSON ARRAY, so decode [CatBreed]
        do {
            return try JSONDecoder().decode([CatBreed].self, from: data)
        } catch {
            print("Decoding error: \(error)")   // keyNotFound / typeMismatch tells you which key broke
            throw CatAPIError.decodingFailed
        }
    }
}


//struct newService {
//    func fetchAPI() async throws -> [CatBreed] {
//        guard let url = URL(string:"www.testapi.com/breeds") else {
//            throw "Invalid URL"
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        
//        let (data, res) = try await URLSession.share.data(for: request)
//        
//        guard let httpResponse = res as? HTTPURLResponse else {
//            throw "Invalid response"
//        }
//        
//        guard (200...299).contains(httpResponse.statusCode) else {
//            throw "Bad status code"
//        }
//        
//        do {
//            let decodedBreeds = try JSONDecoder().decode([CatBreed].self, from: data)
//            self.breeds = decodedBreeds
//        }
//        
//                
//    }
//}
