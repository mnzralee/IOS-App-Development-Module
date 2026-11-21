//
//  HistoryView.swift
//  RoadCost
//
//  Created by Manazir Ali on 2026-11-19.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext

    // TODO (Task 11): Add @Query sorted by timestamp, newest first
    @Query(sort: \TripRecord.timestamp, order: .reverse) private var records: [TripRecord]
    
    @State private var selectedFilter: HistoryFilter = .all

    // TODO (Task 11): Add computed property `filteredRecords`
    var filteredRecords: [TripRecord] {
        switch selectedFilter {
        case .all:
            return records
        case .standard:
            return records.filter{ $0.tripType == .standard }
        case .express:
            return records.filter{ $0.tripType == .express }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                // TODO (Task 11): Segmented Picker for HistoryFilter
                Picker("Filter Picker", selection: $selectedFilter) {
                    ForEach(HistoryFilter.allCases, id:\.self) {
                        Text($0.rawValue.capitalized)
                            .tag($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // TODO (Tasks 12 & 13): List of filteredRecords with custom rows and filtered .onDelete
                if !records.isEmpty {
                    List {
                        ForEach(filteredRecords) { record in
                            VStack {
                                HStack {
                                    Image(systemName: record.tripType.symbolString)
                                        .foregroundStyle(record.tripType.tintColor)
                                    Text(record.tripType.rawValue)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text(record.timestamp, style: .date)
                                        .font(.footnote)
                                }
                                HStack {
                                    Text(record.tripName)
                                    Text("・")
                                    Text(record.distanceKm, format: .number)
                                    Text("・")
                                    Text(record.efficiency, format: .number)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.callout)
                                
                                HStack {
                                    if let tollFee = record.tollFee, let ecoDiscount = record.ecoDiscount {
                                        Text("\(tollFee, format: .currency(code: "GBP"))")
                                        Text("・")
                                        Text(ecoDiscount, format: .currency(code: "GBP"))
                                    } else {
                                        Text("Rate £\(record.unitPrice)/unit")
                                    }
                                    Spacer()
                                    VStack {
                                        Text("Estimated Cost")
                                        Text(record.estimatedCost, format: .currency(code: "GBP"))
                                    }
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.orange)
                                }
                                .font(.callout)
                                
                            }
                        }
                        .onDelete { offsets in
                            for index in offsets {
                                modelContext.delete(filteredRecords[index])
                            }
                        }
                    }
                    
                } else {
                    ContentUnavailableView(
                        "No Trips Saved",
                        systemImage: "clock.fill",
                        description: Text("Calculated trips will appear here.")
                    )
                }
            }
            .navigationTitle("History")
        }
    }
}

#Preview {
    ContentView()
}
