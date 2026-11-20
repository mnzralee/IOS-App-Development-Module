//
//  ParcelModel.swift
//  ParcelCost (Starter)
//
//  The stored data. This is deliberately incomplete.
//

import Foundation
import SwiftData

// The allowed service types. An enum prevents spelling mistakes.
enum ParcelType: String, Codable, CaseIterable {
    case personal = "Personal"
    case business = "Business"
}

// The @Model macro tells SwiftData to store this class as a database table.
@Model
final class ParcelData {
    var type: ParcelType
    var cost: Double
    
    var weight: Double
    var volume: Double
    var insuranceCover: Double?
    var timestamp: Date
    
    
    init(type: ParcelType,
         cost: Double,
         weight: Double,
         volume: Double,
         insuranceCover: Double? = nil,
         timestamp: Date = .now) {
        
        self.type = type
        self.cost = cost
        self.weight = weight
        self.volume = volume
        self.insuranceCover = insuranceCover
        self.timestamp = timestamp
    }
}
