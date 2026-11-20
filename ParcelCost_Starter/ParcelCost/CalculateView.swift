//
//  CalculateView.swift
//  ParcelCost (Starter)
//
//  A working but minimal Calculate screen: one input -> one result -> one saved record.
//  Extend it step by step. Run the app after every change.
//

import SwiftUI
import SwiftData

struct CalculateView: View {
    // Access the SwiftData context so we can save records
    @Environment(\.modelContext) private var modelContext

    // @State holds data that can change; changing it re-draws the view
    @AppStorage("weight") private var weight: Double = 10.0
    @State private var cost: Double = 0.0
    @State private var showResults: Bool = false

    // TODO (Experiment 3): add length, width, height and a computed `volume`
    @AppStorage("length") private var length: Double = 10.0
    @AppStorage("width") private var width: Double = 10.0
    @AppStorage("height") private var height: Double = 10.0
    
    private var volume: Double {
        length * width * height
    }
    
    // TODO (Experiment 5): add the toggle state, insurance amount and a computed `parcelType`
    @State private var toggleState: Bool = false
    @State private var insurance: Double = 0.0
    
    private var parcelType: ParcelType {
        toggleState ? .business : .personal
    }
    
    // TODO (Experiment 6): add state for the "Invalid Input" alert and a computed `inputsAreValid`
    @State private var invalidInputAlert: Bool = false
    
    private var inputsAreValid: Bool {
        let allPositive = length > 0 && width > 0 && height > 0 && weight > 0
        
        if parcelType == .business {
            return allPositive
            && weight <= 30.0
            && length <= 150.0
            && width <= 150.0
            && height <= 150.0
        }
        return allPositive
    }
    
    // TIP: should the four measurements be @State or @AppStorage? See Section 3.1 of the spec.

    var body: some View {
        NavigationStack {
            Form {
                
                // TODO (Experiment 5): "Parcel Setup" section with the Personal/Business toggle,
                //                      and the insurance slider (Business only)
                Section("Parcel Setup") {
                    Toggle(isOn: $toggleState) {
                        HStack {
                            if toggleState {
                                Image(systemName: "briefcase.fill")
                                    .foregroundStyle(.purple)
                                    .font(.system(size: 20))
                                Text("Business (Insured)")
                            } else {
                                Image(systemName: "person.fill")
                                    .foregroundStyle(.blue)
                                    .font(.system(size: 20))
                                Text("Personal (Uninsured)")
                            }
                            
                        }
                    }
                    .tint(.purple)
                    
                    if toggleState {
                        VStack {
                            HStack {
                                Text("Insurance Cover")
                                Spacer()
                                Text(insurance, format: .currency(code: "GBP"))
                                    .bold()
                                
                            }
                            Slider(value: $insurance, in: 0...100, step: 5)
                                .padding(.bottom, 10)
                        }
                    }
                }

                Section("Dimensions & Weight") {
                    DimensionInput(title: "Weight (kg)", value: $weight)
                    // TODO (Experiment 3): Length, Width, Height rows
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

                // Only shown once a calculation has succeeded
                if showResults {
                    Section("Results") {
                        HStack {
                            Text("Total Cost").fontWeight(.semibold)
                            Spacer()
                            Text(cost, format: .currency(code: "GBP"))
                                .bold()
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .navigationTitle("Parcel Cost")
            
            .onChange(of: toggleState) {
                showResults = false
            }
            
            // TODO (Experiment 6): .alert("Invalid Input", ...) here
            .alert("Invalid Input", isPresented: $invalidInputAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please ensure all dimensions and weights are greater than 0. For insured parcels, maximum weight is 30kg and maximum dimension is 150cm.")
            }
        }
    }

    
    // MARK: - Calculation

    private func calculateCost() {
        // TODO (Experiment 6): guard that the inputs are valid before calculating
        guard inputsAreValid else {
            showResults = false
            invalidInputAlert = true
            return
        }
        

        // PLACEHOLDER: not the real pricing rule! Replace it (Experiments 4 and 5).
        let totalCost = (parcelType == .personal) ? calculatePersonalCost() : calculateBusinessCost()
            

        cost = totalCost
        showResults = true
        saveRecord(calculatedCost: totalCost)
    }

    // TODO (Experiment 4): replace with calculatePersonalCost() using the rules in Section 4
    private func calculatePersonalCost() -> Double {
        let rawCost = 3.00 + (weight * 0.50) + ((volume / 1000) * 0.10)
        return max(rawCost, 4.00)
    }
    
    // TODO (Experiment 5): add calculateBusinessCost() and choose between them
    private func calculateBusinessCost() -> Double {
        5.00 + (weight * 1.50) + ((volume / 1000) * 0.75) + insurance
    }
    

    // MARK: - Persistence

    private func saveRecord(calculatedCost: Double) {
        // PLACEHOLDER: always saves as Personal. Fix this in Experiments 5 and 7.
        let newRecord = ParcelData(
            type: parcelType,
            cost: calculatedCost,
            weight: weight,
            volume: volume,
            insuranceCover:toggleState ? insurance : nil
        )

        modelContext.insert(newRecord)
        try? modelContext.save()
    }
}

// A small reusable row: a title on the left and an editable number on the right.
// @Binding connects this subview to the @State (or @AppStorage) property in its parent.
struct DimensionInput: View {
    let title: String
    @Binding var value: Double

    var body: some View {
        HStack {
            Text(title)
            Spacer()
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
