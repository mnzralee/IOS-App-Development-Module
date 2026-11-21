//
//  ShowRowView.swift
//  Encore
//
//  Created by Manazir Ali on 2026-11-09.
//

import SwiftUI

struct ShowRowView: View {
    let show: Show
        
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(show.artistName)
                .font(.headline)
            
            HStack(spacing: 4) {
                Text(show.venueName)
                Text("-")
                Text(show.city)
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            
            HStack {
                Text(show.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                if let rating = show.rating {
                    Spacer()
                    HStack(spacing: 2) {
                        ForEach(0...5, id: \.self) { star in
                            Image(systemName: star <= rating ? "star.fill" : "star")
                                .font(.caption2)
                                .foregroundStyle(star <= rating ? Color.yellow : .secondary)
                            
                        }
                    }
                }
                
            }
        }
        .padding()
        


    }
}

#Preview {
    ShowRowView(show: Show(artistName: "My Artist", venueName: "Some Venue", city: "Some City", date: .now, status: .attended))
}
