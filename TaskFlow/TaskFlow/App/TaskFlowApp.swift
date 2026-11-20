//
//  TaskFlowApp.swift
//  TaskFlow
//
//  Created by Girish Lukka on 18/09/2026.
//
import SwiftUI

    // Marks this struct as the app's entry point.
@main
struct TaskFlowApp: App {

        // Defines the app's structure and scenes using an opaque return type.
    var body: some Scene {
            // Standard window container holding the root view.
        WindowGroup {
            TaskListView()
        }
    }
}
