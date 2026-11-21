//
//  DataModel.swift
//  StayQuote
//
//  Created by Manazir Ali on 2026-11-20.
//

import Foundation
import SwiftData
import SwiftUI

enum StayType: String, Codable, CaseIterable {
    case solo = "Solo Stay"
    case group = "Group Stay"

    var symbolName: String {
        switch self {
        case .solo: return "person.fill"
        case .group: return "person.3.fill"
        }
    }

    var tintColor: Color {
        switch self {
        case .solo: return .blue
        case .group: return .purple
        }
    }
}

enum HistoryFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case solo = "Solo"
    case group = "Group"

    var id: String { rawValue }
}

@Model
final class StayRecord: Identifiable {
    var id: UUID
    var stayType: StayType
    var stayName: String
    var nightlyRate: Double
    var nights: Int
    var cleaningFee: Double
    var totalQoute: Double
    var timestamp: Date
    // Group-only
    var addonPerNight: Double?
    var groupDiscount: Double?
    
    init(stayType: StayType, stayName: String, nightlyRate: Double, nights: Int, cleaningFee: Double, totalQoute: Double, timestamp: Date = .now, addonPerNight: Double? = nil, groupDiscount: Double? = nil) {
        self.id = UUID()
        self.stayType = stayType
        self.stayName = stayName
        self.nightlyRate = nightlyRate
        self.nights = nights
        self.cleaningFee = cleaningFee
        self.totalQoute = totalQoute
        self.timestamp = timestamp
        self.addonPerNight = addonPerNight
        self.groupDiscount = groupDiscount
    }
    
    
}
