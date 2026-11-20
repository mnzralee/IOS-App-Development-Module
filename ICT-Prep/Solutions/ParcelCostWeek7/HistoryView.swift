//
//  HistoryView.swift
//  ParcelCost (reference solution)
//
//  Pattern: @Query (sorted) -> computed filter -> List -> onDelete on the FILTERED array.
//

import SwiftUI
import SwiftData

enum HistoryFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case personal = "Personal"
    case business = "Business"

    var id: Self { self }
}

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext

    // (3) @Query reads AND observes: insert a record on the other tab, this list updates.
    @Query(sort: \ParcelData.timestamp, order: .reverse) private var records: [ParcelData]

    @State private var selectedFilter: HistoryFilter = .all

    // Computed, not a second stored array: always in sync with @Query.
    private var filteredRecords: [ParcelData] {
        switch selectedFilter {
        case .all: records
        case .personal: records.filter { $0.type == .personal }
        case .business: records.filter { $0.type == .business }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(HistoryFilter.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                List {
                    ForEach(filteredRecords) { record in
                        ParcelRowView(record: record)
                    }
                    .onDelete(perform: deleteRecords)
                }
            }
            .navigationTitle("Parcels History")
        }
    }

    /// Offsets refer to the array the ForEach is showing, so index into filteredRecords.
    private func deleteRecords(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredRecords[index])
        }
    }
}

struct ParcelRowView: View {
    let record: ParcelData

    // "17 Oct 2026" regardless of the device's region setting
    private var dateText: String {
        record.timestamp.formatted(
            .dateTime.day().month(.abbreviated).year().locale(Locale(identifier: "en_GB"))
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Label(record.type.rawValue, systemImage: record.type.symbolName)
                    .foregroundStyle(record.type.color)
                    .font(.headline)
                Spacer()
                Text(dateText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Weight: \(record.weight, specifier: "%.2f") kg")
                    Text("Volume: \(record.volume / 1000, specifier: "%.1f") L")   // cm3 -> L on display
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Cost: \(record.cost, format: .currency(code: "GBP"))")
                        .fontWeight(.semibold)
                    // Optional -> only shown when a value exists
                    if let insurance = record.insuranceAmount {
                        Text("Ins: \(insurance, format: .currency(code: "GBP"))")
                            .foregroundStyle(.green)
                    }
                }
            }
            .font(.subheadline)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: ParcelData.self, inMemory: true)
}
