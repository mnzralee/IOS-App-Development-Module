//
//  ParcelType+Display.swift
//  ParcelCost (reference solution)
//
//  Extension: add UI-related behaviour without cluttering the model file.
//  Used by BOTH the toggle (Calculate) and the rows (History): one definition, DRY.
//

import SwiftUI

extension ParcelType {
    var title: String {
        switch self {
        case .personal: "Personal (Uninsured)"
        case .business: "Business (Insured)"
        }
    }

    var symbolName: String {
        switch self {
        case .personal: "person.fill"
        case .business: "briefcase.fill"
        }
    }

    var color: Color {
        switch self {
        case .personal: .blue
        case .business: .purple
        }
    }
}

/// Pricing rules as small, pure, named functions (easy to test, easy to explain).
enum ParcelPricing {
    static let personalBase = 3.00
    static let personalPerKg = 0.50
    static let personalPerLitre = 0.10
    static let personalMinimum = 4.00

    static let businessBase = 5.00
    static let businessPerKg = 1.50
    static let businessPerLitre = 0.75

    static let maxInsuredWeight = 30.0       // kg, "must not exceed" so 30 is allowed
    static let maxInsuredDimension = 150.0   // cm, 150 is allowed

    /// 3.00 + weight x 0.50 + (volume / 1000) x 0.10, never below 4.00
    static func personalCost(weight: Double, volume: Double) -> Double {
        let raw = personalBase + weight * personalPerKg + (volume / 1000) * personalPerLitre
        return max(raw, personalMinimum)
    }

    /// 5.00 + weight x 1.50 + (volume / 1000) x 0.75 + insurance, no minimum
    static func businessCost(weight: Double, volume: Double, insurance: Double) -> Double {
        businessBase + weight * businessPerKg + (volume / 1000) * businessPerLitre + insurance
    }
}
