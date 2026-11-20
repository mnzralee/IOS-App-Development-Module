//
//  CalculateView.swift
//  ParcelCost (reference solution)
//
//  Pattern: state -> conditional UI -> validate (guard) -> calculate -> show -> save.
//

import SwiftUI
import SwiftData

struct CalculateView: View {
    // (2) The context is where you insert / delete records.
    @Environment(\.modelContext) private var modelContext

    // Remembered across relaunch -> @AppStorage (simple values only).
    @AppStorage("weight") private var weight: Double = 10.0
    @AppStorage("length") private var length: Double = 10.0
    @AppStorage("width") private var width: Double = 10.0
    @AppStorage("height") private var height: Double = 10.0

    // Screen-only state -> @State.
    @State private var isInsured = false
    @State private var insuranceAmount: Double = 0
    @State private var cost: Double = 0
    @State private var showResults = false
    @State private var showInvalidInput = false

    // Derived -> computed properties (never stored twice).
    private var parcelType: ParcelType { isInsured ? .business : .personal }
    private var volume: Double { length * width * height }

    private var inputsAreValid: Bool {
        let allPositive = weight > 0 && length > 0 && width > 0 && height > 0
        guard parcelType == .business else { return allPositive }
        return allPositive
            && weight <= ParcelPricing.maxInsuredWeight
            && max(length, width, height) <= ParcelPricing.maxInsuredDimension
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Parcel Setup") {
                    // Label, icon and colour all follow the state.
                    Toggle(isOn: $isInsured) {
                        Label(parcelType.title, systemImage: parcelType.symbolName)
                            .foregroundStyle(parcelType.color)
                    }
                    .tint(.purple)

                    // Conditional UI: `if` REMOVES the view. opacity(0) would only hide it
                    // (still takes space, still interactive for VoiceOver).
                    if parcelType == .business {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Insurance Cover")
                                Spacer()
                                Text(insuranceAmount, format: .currency(code: "GBP"))
                                    .bold()
                            }
                            Slider(value: $insuranceAmount, in: 0...100, step: 5)
                        }
                    }
                }

                Section("Dimensions & Weight") {
                    // One reusable row, four uses (DRY).
                    DimensionInput(title: "Weight (kg)", value: $weight)
                    DimensionInput(title: "Length (cm)", value: $length)
                    DimensionInput(title: "Width (cm)", value: $width)
                    DimensionInput(title: "Height (cm)", value: $height)
                }

                Section {
                    Button(action: calculateCost) {
                        Text("Calculate Cost")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .fontWeight(.semibold)
                    }
                }

                if showResults {
                    Section("Results") {
                        HStack {
                            Text("Total Cost")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(cost, format: .currency(code: "GBP"))
                                .bold()
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .navigationTitle("Parcel Cost")
            // A stale result after switching mode would be wrong, so hide it.
            .onChange(of: isInsured) {
                showResults = false
            }
            .alert("Invalid Input", isPresented: $showInvalidInput) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please ensure all dimensions and weights are greater than 0. For insured parcels, maximum weight is 30kg and maximum dimension is 150cm.")
            }
        }
    }

    // MARK: - Actions

    private func calculateCost() {
        // 1. Validate first, leave early. Nothing below runs on bad input.
        guard inputsAreValid else {
            showResults = false
            showInvalidInput = true
            return
        }

        // 2. Calculate for the selected service
        let total: Double
        switch parcelType {
        case .personal:
            total = ParcelPricing.personalCost(weight: weight, volume: volume)
        case .business:
            total = ParcelPricing.businessCost(weight: weight, volume: volume, insurance: insuranceAmount)
        }

        // 3. Show
        cost = total
        showResults = true

        // 4. Save
        saveRecord(cost: total)
    }

    private func saveRecord(cost: Double) {
        let record = ParcelData(
            type: parcelType,
            weight: weight,
            volume: volume,
            cost: cost,
            insuranceAmount: parcelType == .business ? insuranceAmount : nil
        )
        modelContext.insert(record)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save parcel: \(error)")
        }
    }
}

/// Reusable row: title on the left, editable right-aligned number on the right.
/// @Binding works with a parent's @State OR @AppStorage property.
struct DimensionInput: View {
    let title: String
    @Binding var value: Double

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            // value: + format: -> a numeric binding. The TextField converts text <-> Double.
            TextField("0.0", value: $value, format: .number)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    CalculateView()
        .modelContainer(for: ParcelData.self, inMemory: true)
}
