//
//  EstimateView.swift
//  RoadCost
//
//  Created by Manazir Ali on 2026-11-19.
//

import SwiftUI
import SwiftData

struct EstimateView: View {
    // TODO (Task 9): Access modelContext from @Environment
    @Environment(\.modelContext) private var modelContext

    // TODO (Task 1): Add @State properties for shared inputs, Express inputs, mode, results, and alert
    @State private var tripName: String = "Highland Loop"
    @State private var distance: Int = 300
    @State private var unitPrice: Double = 1.5
    @State private var efficiency: Double = 15.0
    @State private var tollFee: Double = 12.50
    @State private var discount: Double = 0.0
    
    @State private var isExpressMode: Bool = false
    @State private var estimatedCost: Double = 0.0
    @State private var showResult: Bool = false
    @State private var showAlert: Bool = false
    
    @State private var alertMessage: String = ""
        

    private var tripType: TripType {
        // TODO (Task 2): Return .express when isExpressMode is true, else .standard
        isExpressMode ? .express : .standard
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("JOURNEY DETAILS") {
                    // TODO (Task 3): Shared input rows (Trip Name, Distance, Price, Efficiency)
                    HStack {
                        Label("Trip Name ", systemImage: "map")
                        TextField("", text: $tripName)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Label("Distance (km)", systemImage: "road.lanes")
                        TextField("300", value: $distance, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                    
                    HStack {
                        Label("Fuel/Energy Price (£)", systemImage: "sterlingsign.circle")
                        TextField("1.5", value: $unitPrice, format: .currency(code: "GBP"))
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                    
                    HStack {
                        Label("Efficiency (km/unit)", systemImage: "gauge.with.needle")
                        TextField("15.0", value: $efficiency, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)

                    }
                    
                    
                    // TODO (Task 2): Mode Toggle bound to $isExpressMode
                    Toggle(isOn: $isExpressMode) {
                        HStack {
                            Image(systemName: tripType.symbolString )
                                .foregroundStyle(tripType.tintColor)
                            Text("\(tripType.rawValue.capitalized)")
                        }
                    }
                    .tint(tripType.tintColor)
                    
                    
                    // TODO (Task 4): Conditional Express-only Toll Fee & Eco Discount Slider
                    if isExpressMode {
                        HStack {
                            Label("Toll Fee (£)", systemImage: "ticket")
                            TextField("12.50", value: $tollFee, format: .currency(code: "GBP"))
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                        }
                        
                        VStack {
                            HStack {
                                Label("Eco Discount (%)", systemImage: "leaf.fill")
                                Spacer()
                                Text("\(discount, specifier: "%.0f")%")
                            }
                            Slider(value: $discount, in: 0...30, step: 5)
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

                // TODO (Task 6): Results Section (shown only when showResults is true)
                if showResult {
                    HStack {
                        Text("Estimated Cost ")
                            .fontWeight(.bold)
                        Spacer()
                        Text(estimatedCost, format: .currency(code: "GBP").precision(.fractionLength(2)))
                        
                        
                    }
                }
            }
            .navigationTitle("Road Cost")
            // TODO (Task 2): .onChange(of: isExpressMode) to hide previous result
            .onChange(of: isExpressMode) {
                showResult = false
            }
            // TODO (Task 7): .alert for invalid inputs
            .alert("Invalid Input", isPresented: $showAlert) {
                Button("Got it!", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }

    private func calculateAndSave() {
        // TODO (Task 7): Validate distanceKm, efficiency, unitPrice, and Express tollFee
        guard distance > 0 &&
                efficiency > 0 &&
                unitPrice >= 0 &&
                (!isExpressMode || tollFee >= 0)
        else {
            showResult = false
            alertMessage = "Please enter valid values, and try again."
            showAlert = true
            return
        }

        //TODO (Task 5): Uncomment this block once state properties exist and complete the marked lines
        let unitsNeeded = Double(distance) / efficiency
        let baseCost = unitsNeeded * unitPrice

        var finalCost = baseCost
        var savedTollFee: Double? = nil
        var savedEcoDiscount: Double? = nil

        if tripType == .express {
            // Assign savedTollFee and savedEcoDiscount here
            savedTollFee = tollFee
            savedEcoDiscount = discount

            let discountMultiplier = 1.0 - (discount / 100.0)
            finalCost = (baseCost * discountMultiplier) + tollFee
        }

        // Assign estimatedCost and showResults here
        estimatedCost = finalCost
        showResult = true

        // TODO (Task 9): Create TripRecord and insert into modelContext
        let tripRecord = TripRecord(tripType: tripType, tripName: tripName, distanceKm: distance, unitPrice: unitPrice, efficiency: efficiency, estimatedCost: estimatedCost, timestamp: .now, tollFee: isExpressMode ? savedTollFee : nil, ecoDiscount: isExpressMode ? savedEcoDiscount : nil)
        
        modelContext.insert(tripRecord)
        try? modelContext.save()
    }
}

#Preview {
    EstimateView()
}

