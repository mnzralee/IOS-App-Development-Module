//
//  ContentView.swift
//  StayQuote
//
//  Created by Manazir Ali on 2026-11-20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            QuoteView()
                .tabItem {
                    Label("Quote", systemImage: "function")
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}

