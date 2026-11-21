//
//  CatBreed.swift
//  Cat Breed Explorer
//
//  Created by Manazir Ali on 2026-11-16.
//
//  MODEL: describes ONE breed exactly as the JSON sends it.
//  Marks: "Data Model: correct use of Codable, matching JSON keys" (5)
//

import Foundation

// Codable      -> JSONDecoder can turn JSON into this struct
// Identifiable -> List / ForEach can tell rows apart (uses `id`)
// Hashable     -> NavigationLink(value:) can push it to a detail screen
struct CatBreed: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let origin: String
    let description: String
    let lifeSpan: String              // JSON sends "14 - 15" (text), so String, not Int
    let referenceImageId: String?     // OPTIONAL: a few breeds have no image id.
                                      // Non-optional + one missing key = the WHOLE array fails to decode.

    // The bridge between Swift names (camelCase) and JSON names (snake_case).
    // Once you write CodingKeys you must list EVERY property you want decoded.
    // Keys you leave out of the struct (weight, temperament...) are simply ignored.
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case origin
        case description
        case lifeSpan = "life_span"
        case referenceImageId = "reference_image_id"   // was "reference_image" (silent bug: always nil)
    }

    // COMPUTED property: derived from stored data, never decoded or stored itself.
    // https://cdn2.thecatapi.com/images/{reference_image_id}.jpg
    var imageURL: URL? {
        guard let referenceImageId else { return nil }   // no id -> no URL -> row shows a placeholder
        return URL(string: APIConstants.imageBaseURL + referenceImageId + APIConstants.imageExtension)
    }
}

// Fake data for #Previews, so previews never need the network.
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
