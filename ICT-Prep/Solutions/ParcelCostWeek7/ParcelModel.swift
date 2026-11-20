//
//  ParcelModel.swift
//  ParcelCost (reference solution)
//
//  The stored data. Rule of thumb: store what History must DISPLAY, nothing more.
//

import Foundation
import SwiftData

// A closed set of choices: an enum, never a free-text String (no typos possible).
enum ParcelType: String, Codable, CaseIterable {
    case personal = "Personal"
    case business = "Business"
}

// @Model turns this class into a SwiftData table. Must be a CLASS.
@Model
final class ParcelData {
    var type: ParcelType
    var weight: Double              // kg, shown as "Weight: 10.00 kg"
    var volume: Double              // cm3, converted to litres only when DISPLAYED
    var cost: Double                // GBP
    var insuranceAmount: Double?    // nil for Personal. NOT 0: "no insurance" != "insured for 0"
    var timestamp: Date             // makes "newest first" sorting possible (Date, not String)

    init(type: ParcelType,
         weight: Double,
         volume: Double,
         cost: Double,
         insuranceAmount: Double? = nil,
         timestamp: Date = .now) {
        self.type = type
        self.weight = weight
        self.volume = volume
        self.cost = cost
        self.insuranceAmount = insuranceAmount
        self.timestamp = timestamp
    }
}
