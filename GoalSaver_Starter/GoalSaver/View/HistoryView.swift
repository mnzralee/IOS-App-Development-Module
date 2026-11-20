//
//  HistoryView.swift
//  GoalSaver
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    
    // TASK 11 – HINT: How do you fetch records from SwiftData and sort them by timestamp, newest first?
    // @Query(...) private var allRecords: [SavingsRecord]
    @Query(sort: \SavingsRecord.timestamp, order: .reverse) private var allRecords: [SavingsRecord]
    
    enum FilterOption: String, CaseIterable {
        case all = "All"
        case fixed = "Fixed"
        case regular = "Regular"
    }
    
    @State private var selectedFilter: FilterOption = .all
    
    // TASK 11 – HINT: Create a computed property `filteredRecords` that returns [SavingsRecord].
    // Use a `switch` statement on `selectedFilter` to filter `allRecords`.
    var filteredRecords: [SavingsRecord] {
        if selectedFilter == .all {
            return allRecords
        } else {
            return allRecords.filter{ $0.type.rawValue == selectedFilter.rawValue }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // --- FILTER PILLS ---
                // TASK 11 – HINT: Create a Picker bound to `selectedFilter`.
                // Loop through FilterOption.allCases and use the `.segmented` picker style.
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(FilterOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                // --- LIST OF RECORDS ---
                List {
                    ForEach(filteredRecords) { record in
                        VStack(alignment: .leading, spacing: 6) {
                            
                            // TASK 12 – HINT: Build your row UI here.
                            // Top row: type + date. Second row: goal, term and rate + starting amount.
                            // Bottom row: the projected balance.
                            
                            // CRITICAL HINT: Regular records have a Monthly Deposit and a Monthly Boost.
                            // Fixed records DO NOT. Use `if let` to safely unwrap those optionals.
                            // If they exist, display them in the row.
                            HStack {
                                
                                Text(record.type.rawValue)
                                    .font(.headline)
                                Spacer()
                                Text(record.timestamp.formatted(.dateTime.day().month()))
                                    .font(.caption2)
                            }
                            
                            HStack {
                                Text(record.goalName)
                                Text("/")
                                Text("\(record.months) mo")
                                Text("/")
                                Text("\(record.rate, specifier: "%.1f")%")
                                Spacer()
                            }
                            .font(.caption2)
                            
                            HStack {
                                
                                if let deposit = record.monthlyDeposit {
                                    Text("Deposit \(deposit, format: .currency(code: "GBP").precision(.fractionLength(2)))/mo")
                                } else {
                                    Text("Start \(record.startAmount, format: .currency(code: "GBP").precision(.fractionLength(2)))")
                                }
                                
                                Spacer()
                                VStack{
                                    Text("Projected Balance")
                                        .foregroundStyle(.secondary)
                                        .fontWeight(.bold)
                                    Text("\(record.projectedBalance, format: .currency(code: "GBP").precision(.fractionLength(2)))")
                                        .fontWeight(.bold)
                                        .foregroundStyle(.green)
                                        .font(.headline)
                                }
                            }
                            .font(.caption2)
                            
                        }
                        .padding(.vertical, 4)
                    }
                    // TASK 13 – HINT: Attach the onDelete modifier so users can swipe to delete.
                    // .onDelete(perform: deleteItems)
                    .onDelete(perform: deleteItems)
                    
                }
            }
            .navigationTitle("History")
        }
                
    }
    // TASK 13 – HINT: Implement the delete function here
    // Careful: the offsets refer to the array you are DISPLAYING. Which array is that?
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(filteredRecords[index])
            }
        }
    }
}



#Preview {
    HistoryView()
    // HINT (after Task 8): @Query needs a container, or the preview will fail:
     .modelContainer(for: SavingsRecord.self, inMemory: true)
}
