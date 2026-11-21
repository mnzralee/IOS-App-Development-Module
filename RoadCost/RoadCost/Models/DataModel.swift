//
//  DataModel.swift
//  RoadCost
//
//  Created by Manazir Ali on 2026-11-19.
//
import Foundation
import SwiftUI
import SwiftData


enum TripType: String, CaseIterable, Codable {
    case standard = "Standard Route"
    case express = "Express Route"
    
    var symbolString: String {
        switch self {
        case .standard:
            return "car.fill"
        case .express:
            return "bolt.car.fill"
        }
    }
    
    var tintColor: Color {
        switch self {
        case .standard:
            return .blue
        case .express:
            return .orange
        }
    }
}

enum HistoryFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case standard = "Standard"
    case express = "Express"

    
    var id: String { rawValue }
    
}

// TODO (Task 8): Implement @Model final class TripRecord
@Model
final class TripRecord: Identifiable {
    var id: UUID
    var tripType: TripType
    var tripName: String
    var distanceKm: Int
    var unitPrice: Double
    var efficiency: Double
    var estimatedCost: Double
    var timestamp: Date
    var tollFee: Double?
    var ecoDiscount: Double?
    
    init(tripType: TripType, tripName: String, distanceKm: Int, unitPrice: Double, efficiency: Double, estimatedCost: Double, timestamp: Date = Date(), tollFee: Double? = nil, ecoDiscount: Double? = nil) {
        self.id = UUID()
        self.tripType = tripType
        self.tripName = tripName
        self.distanceKm = distanceKm
        self.unitPrice = unitPrice
        self.efficiency = efficiency
        self.estimatedCost = estimatedCost
        self.timestamp = timestamp
        self.tollFee = tollFee
        self.ecoDiscount = ecoDiscount
    }
}
