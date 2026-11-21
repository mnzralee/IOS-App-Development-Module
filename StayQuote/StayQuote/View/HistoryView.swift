//
//  HistoryView.Swift
//  StayQuote
//
//  Created by Manazir Ali on 2026-11-20.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \StayRecord.timestamp, order: .reverse) private var records: [StayRecord]
    
    @State private var selectedFilter: HistoryFilter = .all
    @State private var searchText: String = ""
    
    var filteredRecords: [StayRecord] {
        let byType: [StayRecord]
        switch selectedFilter {
        case .all:
            byType = records
        case .solo:
            byType = records.filter{ $0.stayType == .solo }
        case .group:
            byType = records.filter{ $0.stayType == .group }
        }
        
        if !searchText.isEmpty {
            return byType.filter{ $0.stayName.localizedCaseInsensitiveContains(searchText)
            }
        }
        return byType

    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Picker("Filter Picker", selection: $selectedFilter) {
                    ForEach(HistoryFilter.allCases, id: \.self) {
                        Text($0.rawValue.capitalized)
                            .tag($0)
                    }
                }
                .pickerStyle(.segmented)
                .searchable(text: $searchText, prompt: "Search stays")
                .padding(.horizontal)
                
                // TODO (Tasks 12 & 13): Check !filteredRecords.isEmpty, List rows with units & if let, and filtered .onDelete
                if !filteredRecords.isEmpty {
                    List {
                        ForEach(filteredRecords) { record in
                            VStack (alignment: .leading, spacing: 6) {
                                HStack {
                                    Label(record.stayType.rawValue.capitalized, systemImage: record.stayType.symbolName)
                                        .foregroundColor(record.stayType.tintColor)
                                        .font(.headline)
                                        .padding(.trailing, 10)
                                    Spacer()
                                    Text(record.timestamp, format: .dateTime.day().month(.abbreviated))
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                                HStack {
                                    Text("\(record.stayName) · \(record.nights) nights · £\(record.nightlyRate, specifier: "%.2f")/night")
                                        .font(.subheadline)
                                        .foregroundStyle(.primary)
                                }
                                HStack {
                                    if let addon = record.addonPerNight, let discount = record.groupDiscount {
                                        Text("Add-on £\(addon, specifier: "%.2f") · \(discount, specifier: "%.0f")% off")
                                            .font(.footnote)
                                    } else {
                                        Text("Cleaning £\(record.cleaningFee, specifier: "%.2f")")
                                            .font(.footnote)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack {
                                        Text("Total Quote")
                                            .foregroundStyle(.secondary)
                                        Text("£\(record.totalQoute, specifier: "%.2f")")
                                            .font(.subheadline)
                                            .foregroundStyle(.primary)
                                            .fontWeight(.bold)
                                    }
                                    
                                }
                            }
                        }
                        .onDelete(perform: deleteRecords)
                    }
                } else {
                    ContentUnavailableView(
                        "No Quotes Saved",
                        systemImage: "clock.fill",
                        description: Text("Calculated stay quotes will appear here.")
                    )
                }
                
            }
            .navigationTitle("History")
            // TODO (Task 11): Attach .searchable(text: $searchText, prompt: "Search stays")
        }
        
    }
    func deleteRecords(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredRecords[index])
        }
    }
}


#Preview {
    HistoryView()
}
