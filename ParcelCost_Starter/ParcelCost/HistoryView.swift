//
//  HistoryView.swift
//  ParcelCost (Starter)
//
//  A bare History list. It shows every saved record, unsorted and unfiltered.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    // @Query reads ParcelData from the database and keeps the view up to date automatically.
    @Environment(\.modelContext) private var modelContext
    
    // TODO (Experiment 8): sort newest first  ->  @Query(sort: ..., order: ...)
    @Query(sort: \ParcelData.timestamp, order: .reverse) private var records: [ParcelData]

    // TODO (Experiment 8): add state for the selected filter (All / Personal / Business)
    @State private var selectedFilter: String = "All"
    // TODO (Experiment 8): add a computed `filteredRecords` and list that instead of `records`
    private var filteredRecords: [ParcelData] {
        if selectedFilter == "All" {
            return records
        }
        return records.filter{ $0.type.rawValue == selectedFilter }
    }
    
    private func deleteRecords(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredRecords[index])
        }
        try? modelContext.save()
    }

    var body: some View {
        NavigationStack {
            VStack {
                // TODO (Experiment 8): segmented Picker above the list
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(["All", "Personal", "Business"], id: \.self) {
                        Text($0).tag($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                List {
                    // TODO (Experiment 7): replace with a proper row (icon, date, weight, volume, cost, optional insurance)
                    ForEach(filteredRecords) { record in
                        ParcelRowView(record: record)
                    }
                    .onDelete(perform: deleteRecords)
                }
            }
            .navigationTitle("Parcels History")
        }
    }
}


// MARK: - Delete Function





#Preview {
    HistoryView()
        .modelContainer(for: ParcelData.self, inMemory: true)
}
