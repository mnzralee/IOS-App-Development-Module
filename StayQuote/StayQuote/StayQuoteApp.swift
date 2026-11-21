//
//  StayQuoteApp.swift
//  StayQuote
//
//  Created by Manazir Ali on 2026-11-20.
//

import SwiftUI
import SwiftData

@main
struct StayQuoteApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: StayRecord.self)
    }
}

