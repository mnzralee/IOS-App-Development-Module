
RoadCostApp.swift
// ============================================================
// MARK: - 1. RoadCostApp.swift
// ============================================================

import SwiftUI
import SwiftData

@main
struct RoadCostApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: TripRecord.self)
    }
}


// ============================================================
// MARK: - 2. Model/DataModel.swift
// ============================================================

import Foundation
import SwiftUI
import SwiftData

enum TripType: String, CaseIterable, Codable {
    case standard = "Standard Route"
    case express = "Express Route"

    var symbolName: String {
        switch self {
        case .standard: return "car.fill"
        case .express: return "bolt.car.fill"
        }
    }

    var tintColor: Color {
        switch self {
        case .standard: return .blue
        case .express: return .orange
        }
    }
}

enum HistoryFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case standard = "Standard"
    case express = "Express"

    var id: String { rawValue }
}

@Model
final class TripRecord {
    var tripType: TripType
    var tripName: String
    var distanceKm: Int
    var unitPrice: Double
    var efficiency: Double
    var estimatedCost: Double
    var timestamp: Date
    var tollFee: Double?
    var ecoDiscount: Double?

    init(
        tripType: TripType,
        tripName: String,
        distanceKm: Int,
        unitPrice: Double,
        efficiency: Double,
        estimatedCost: Double,
        timestamp: Date = .now,
        tollFee: Double? = nil,
        ecoDiscount: Double? = nil
    ) {
        self.tripType = tripType
        self.tripName = tripName
        self.distanceKm = distanceKm
        self.unitPrice = unitPrice
        self.efficiency = efficiency
        self.estimatedCost = estimatedCost
        self.timestamp = timestamp
        self.tollFee = tollFee
        self.ecoDiscount = ecoDiscount
    }
}


// ============================================================
// MARK: - 3. View/ContentView.swift
// ============================================================

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            EstimateView()
                .tabItem {
                    Label("Estimate", systemImage: "function")
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }
        }
        .tint(.blue)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TripRecord.self, inMemory: true)
}


// ============================================================
// MARK: - 4. View/EstimateView.swift
// ============================================================

import SwiftUI
import SwiftData

struct EstimateView: View {
    @Environment(\.modelContext) private var modelContext

    // Shared inputs
    @State private var tripName: String = "Highland Loop"
    @State private var distanceKm: Int = 300
    @State private var unitPrice: Double = 1.50
    @State private var efficiency: Double = 15.0

    // Express-only inputs
    @State private var tollFee: Double = 12.50
    @State private var ecoDiscount: Double = 0.0

    // Mode, result, and alert state
    @State private var isExpressMode: Bool = false
    @State private var estimatedCost: Double = 0.0
    @State private var showResults: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    private var tripType: TripType {
        isExpressMode ? .express : .standard
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("JOURNEY DETAILS") {
                    HStack {
                        Label("Trip Name", systemImage: "map")
                        TextField("Highland Loop", text: $tripName)
                            .multilineTextAlignment(.trailing)
                    }

                    HStack {
                        Label("Distance (km)", systemImage: "road.lanes")
                        TextField("300", value: $distanceKm, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }

                    HStack {
                        Label("Fuel/Energy Price", systemImage: "sterlingsign.circle")
                        TextField("1.50", value: $unitPrice, format: .currency(code: "GBP"))
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }

                    HStack {
                        Label("Efficiency (km/unit)", systemImage: "gauge.with.needle")
                        TextField("15.0", value: $efficiency, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }

                    Toggle(isOn: $isExpressMode) {
                        Label {
                            Text(tripType.rawValue)
                        } icon: {
                            Image(systemName: tripType.symbolName)
                                .foregroundStyle(tripType.tintColor)
                        }
                    }
                    .tint(tripType.tintColor)

                    if isExpressMode {
                        HStack {
                            Label("Toll / Permit Fee", systemImage: "ticket")
                            TextField("12.50", value: $tollFee, format: .currency(code: "GBP"))
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Label("Eco Discount", systemImage: "leaf.fill")
                                Spacer()
                                Text("\(Int(ecoDiscount))%")
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: $ecoDiscount, in: 0...30, step: 5)
                                .tint(.orange)
                        }
                    }
                }

                Section {
                    Button {
                        calculateAndSave()
                    } label: {
                        Label("Estimate Cost", systemImage: "equal.circle.fill")
                            .frame(maxWidth: .infinity)
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(.borderedProminent)
                    .listRowInsets(EdgeInsets())
                }

                if showResults {
                    Section("RESULT") {
                        HStack {
                            Text("Estimated Cost")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(estimatedCost, format: .currency(code: "GBP"))
                                .font(.title2.bold())
                                .foregroundStyle(.green)
                        }
                    }
                }
            }
            .navigationTitle("Road Cost")
            .onChange(of: isExpressMode) {
                showResults = false
            }
            .alert("Invalid Input", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }

    private func calculateAndSave() {
        guard distanceKm > 0,
              efficiency > 0,
              unitPrice >= 0,
              (!isExpressMode || tollFee >= 0) else {
            showResults = false
            alertMessage = "Distance and efficiency must be greater than zero, and prices or tolls cannot be negative."
            showAlert = true
            return
        }

        let unitsNeeded = Double(distanceKm) / efficiency
        let baseCost = unitsNeeded * unitPrice

        var finalCost = baseCost
        var savedTollFee: Double? = nil
        var savedEcoDiscount: Double? = nil

        if tripType == .express {
            savedTollFee = tollFee
            savedEcoDiscount = ecoDiscount

            let discountMultiplier = 1.0 - (ecoDiscount / 100.0)
            finalCost = (baseCost * discountMultiplier) + tollFee
        }

        estimatedCost = finalCost
        showResults = true

        let record = TripRecord(
            tripType: tripType,
            tripName: tripName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Untitled Trip" : tripName,
            distanceKm: distanceKm,
            unitPrice: unitPrice,
            efficiency: efficiency,
            estimatedCost: estimatedCost,
            timestamp: .now,
            tollFee: savedTollFee,
            ecoDiscount: savedEcoDiscount
        )

        modelContext.insert(record)
    }
}

#Preview {
    EstimateView()
        .modelContainer(for: TripRecord.self, inMemory: true)
}


// ============================================================
// MARK: - 5. View/HistoryView.swift
// ============================================================

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TripRecord.timestamp, order: .reverse) private var records: [TripRecord]

    @State private var selectedFilter: HistoryFilter = .all

    private var filteredRecords: [TripRecord] {
        switch selectedFilter {
        case .all:
            return records
        case .standard:
            return records.filter { $0.tripType == .standard }
        case .express:
            return records.filter { $0.tripType == .express }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(HistoryFilter.allCases) { filter in
                        Text(filter.rawValue)
                            .tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                if !filteredRecords.isEmpty {
                    List {
                        ForEach(filteredRecords) { record in
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Image(systemName: record.tripType.symbolName)
                                        .foregroundStyle(record.tripType.tintColor)
                                    Text(record.tripType.rawValue)
                                        .font(.headline)
                                    Spacer()
                                    Text(record.timestamp.formatted(.dateTime.day().month(.abbreviated)))
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }

                                Text("\(record.tripName) · \(record.distanceKm) km · \(record.efficiency, specifier: "%.1f") km/unit")
                                    .font(.callout)
                                    .foregroundStyle(.secondary)

                                HStack(alignment: .bottom) {
                                    if let tollFee = record.tollFee, let ecoDiscount = record.ecoDiscount {
                                        Text("Toll \(tollFee, format: .currency(code: "GBP")) · \(Int(ecoDiscount))% off")
                                            .font(.callout)
                                            .foregroundStyle(.secondary)
                                    } else {
                                        Text("Rate \(record.unitPrice, format: .currency(code: "GBP"))/unit")
                                            .font(.callout)
                                            .foregroundStyle(.secondary)
                                    }

                                    Spacer()

                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text("Estimated Cost")
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                        Text(record.estimatedCost, format: .currency(code: "GBP"))
                                            .font(.headline.bold())
                                            .foregroundStyle(.green)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: deleteRecords)
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

    private func deleteRecords(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredRecords[index])
        }
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: TripRecord.self, inMemory: true)
}
