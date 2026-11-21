//
//  MainTabView.swift
//  Encore
//
//  Created by Manazir Ali on 2026-11-09.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        
        TabView {
            Tab ("Attended", systemImage: "music.mic") {
                AttendedView()
            }
            Tab ("Upcoming", systemImage: "calendar") {
                UpcomingView()
            }
            Tab ("Settings", systemImage: "gear") {
                SettingsView()
            }
        }
        
        
    }
}


//#Preview {
//    MainTabView()
//}
