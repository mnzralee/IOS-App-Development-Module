//
//  CatBreed.swift
//  Cat Breeds Explorer (reference solution)
//
//  Data Model (5 marks): Codable + JSON keys matched with CodingKeys.
//  Only the 5 fields the spec asks for (+ id for Identifiable). Extra JSON keys are ignored.
//

import Foundation

struct CatBreed: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let origin: String
    let description: String
    let lifeSpan: String              // JSON gives a STRING like "14 - 15", not a number
    let referenceImageId: String?     // OPTIONAL: some breeds have no image id

    // Swift camelCase  <->  JSON snake_case.
    // Once you write CodingKeys, list EVERY property you want decoded.
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case origin
        case description
        case lifeSpan = "life_span"
        case referenceImageId = "reference_image_id"
    }

    /// https://cdn2.thecatapi.com/images/{reference_image_id}.jpg  (nil when there is no id)
    var imageURL: URL? {
        guard let referenceImageId else { return nil }
        let urlString = AppConstants.API.imageBaseURL + referenceImageId + AppConstants.API.imageExtension
        return URL(string: urlString)
    }
}

// Sample for #Previews (no network needed).
extension CatBreed {
    static let sample = CatBreed(
        id: "abys",
        name: "Abyssinian",
        origin: "Egypt",
        description: "The Abyssinian is easy to care for, and a joy to have in your home. They are affectionate cats and love both people and other animals.",
        lifeSpan: "14 - 15",
        referenceImageId: "0XYvRd7oD"
    )
}
