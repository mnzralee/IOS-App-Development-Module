//
//  ParcelRowView.swift
//  ParcelCost
//
//  Created by Manazir Ali on 2026-11-17.
//

import SwiftUI
import SwiftData

struct ParcelRowView: View {
    let record: ParcelData
    var isPersonal: Bool {
        record.type == .personal
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                isPersonal ?
                Image(systemName: "person.fill")
                    .foregroundStyle(.blue) :
                Image(systemName: "briefcase.fill")
                    .foregroundStyle(.purple)
                
                Text(record.type.rawValue)
                    .font(.headline)
                    .foregroundStyle(isPersonal ? .blue : .purple)
                    .bold()
                Spacer()
                Text(record.timestamp.formatted(.dateTime.day().month(  .abbreviated).year().locale(Locale(identifier: "en_GB"))))
                    .foregroundStyle(.secondary)
                    .font(.footnote)
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("Weight: \(record.weight, specifier: "%.2f") kg")
                        .font(.callout)
                        .foregroundStyle(.primary)
                    
                    
                    Text("Volume: \(record.volume/1000, specifier: "%.1f") L")
                        .font(.callout)
                        .foregroundStyle(.primary)
                                            
                    
                }
                
                Spacer()
                
                VStack (alignment: .trailing){
                    
                    Text("Cost: \(record.cost, format: .currency(code: "GBP"))")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    
                    if let ins = record.insuranceCover {
                            Text("Ins: \(ins, format: .currency(code: "GBP"))")
                                .foregroundStyle(.green)
                                .font(.callout)
                    }
                }
            }
        }
        
        
    }
}

#Preview {
    let container = try! ModelContainer(for: ParcelData.self,
                                        configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let sample = ParcelData(type: .business, cost: 50.75, weight: 10, volume: 1000, insuranceCover: 30.0)
    return List { ParcelRowView(record: sample) }
        .modelContainer(container)
}
