//
//  EncoreApp.swift
//  Encore
//
//  Created by Manazir Ali on 2026-11-07.
//

import SwiftUI
import SwiftData

@main
struct EncoreApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: Show.self)
    }
}
