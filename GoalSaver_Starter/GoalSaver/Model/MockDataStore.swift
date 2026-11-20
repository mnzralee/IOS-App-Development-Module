//
//  MockDataStore.swift
//  GoalSaver
//
//  Created by Manazir Ali on 2026-11-19.
//

import Foundation

struct MockDataStore {
    static let records: [SavingsRecord] = [
        SavingsRecord(type: .regular, goalName: "Retirement", startAmount: 100000, rate: 0.07, months: 120, projectedBalance: 100000, monthlyDeposit: 1000, monthlyBoost: 1000),
        SavingsRecord(type: .fixed, goalName: "Emergency Fund", startAmount: 10000, rate: 0.05, months: 12, projectedBalance: 10000),
    ]
}
