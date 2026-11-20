//
//  DataModel.swift
//  GoalSaver
//

import Foundation
import SwiftData

// MARK: - Data Models

enum SavingsType: String, Codable, CaseIterable {
    case fixed = "Fixed"
    case regular = "Regular"
    
}

// TASK 8 – HINT: What macro is required here to make this class work with SwiftData?
@Model
class SavingsRecord {

    // HINT: Define your properties here.
    // Think carefully: a Fixed Deposit DOES NOT have a monthly deposit or a monthly boost.
    // How should you declare those two properties so they can safely hold "no value"?

    // var type: SavingsType
    // var goalName: ...
    // ...

    /*
     init(...) {
     // Initialise every property here.
     // HINT: give the two optional parameters a default value of nil.
     }
     */
    var type: SavingsType
    var goalName: String
    var startAmount: Double
    var rate: Double
    var months: Int
    var projectedBalance: Double
    var timestamp: Date
    var monthlyDeposit: Double?
    var monthlyBoost: Double?
    
    init(type: SavingsType,
         goalName: String,
         startAmount: Double,
         rate: Double,
         months: Int,
         projectedBalance: Double,
         timestamp: Date = .now,
         monthlyDeposit: Double? = nil,
         monthlyBoost: Double? = nil)
    {
        self.type = type
        self.goalName = goalName
        self.startAmount = startAmount
        self.rate = rate
        self.months = months
        self.projectedBalance = projectedBalance
        self.timestamp = timestamp
        self.monthlyDeposit = monthlyDeposit
        self.monthlyBoost = monthlyBoost
    }
    
    
}
