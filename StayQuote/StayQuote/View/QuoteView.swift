//
//  QuoteView.swift
//  StayQuote
//
//  Created by Manazir Ali on 2026-11-20.
//

import SwiftUI
import SwiftData

struct QuoteView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var stayName: String = "Seaside Villa"
    @State private var nightlyRate: Double = 120.0
    @State private var nights: Int = 4
    @State private var cleaningFee: Double = 35.0
    @State private var addOnPerNight: Double = 25.0
    @State private var groupDiscount: Double = 0.0
    
    @State private var isGroupMode: Bool = false
    @State private var totalQuote: Double = 0.0
    @State private var showResults: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    private var stayType: StayType {
        isGroupMode ? .group : .solo
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("STAY DETAILS") {

                    HStack {
                        Label("Stay Name", systemImage: "house.fill")
                        TextField("", text: $stayName)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Label("Nightly Rate", systemImage: "sterlingsign.circle")
                        TextField("", value: $nightlyRate, format: .currency(code: "GBP"))
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                    
                    HStack {
                        Label("Nights", systemImage: "moon.stars.fill")
                        TextField("", value: $nights, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                    
                    HStack {
                        Label("Cleaning Fee", systemImage: "sparkles")
                        TextField("", value: $cleaningFee, format: .currency(code: "GBP"))
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                    
                    
                    
                    
                    Toggle(isOn: $isGroupMode) {
                        Label(stayType.rawValue.capitalized, systemImage: stayType.symbolName)
                    }
                    
                    
                    if isGroupMode {
                        HStack {
                            Label("Hosted Add-On (£/night)", systemImage: "cup.and.saucer.fill")
                            TextField("", value: $addOnPerNight, format: .currency(code: "GBP"))
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                        }
                        
                        VStack {
                            HStack {
                                Label("Group Discount", systemImage: "percent")
                                Spacer()
                                Text("\(Int(groupDiscount))%")
                            }

                            Slider(value: $groupDiscount, in: 0...25, step: 5)
                        }
                    }
                    
                    
                }

                Section {
                    Button {
                        calculateAndSave()
                    } label: {
                        Label("Calculate Quote", systemImage: "equal.circle.fill")
                            .frame(maxWidth: .infinity)
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(.borderedProminent)
                    .listRowInsets(EdgeInsets())
                }


                if showResults {
                    Section ("RESULT"){
                        HStack {
                            Text("Total Quote")
                            Spacer()
                            Text("£\(totalQuote, specifier: "%.2f")")
                                .fontWeight(.bold)
                                .foregroundStyle(.green)
                        }
                    }
                }
            }
            .navigationTitle("Stay Quote")
            .onChange(of: isGroupMode) {
                showResults = false
            }
            .alert("Invalid Inputs", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            
        }
    }

    private func calculateAndSave() {

        guard nights > 0, nightlyRate > 0, cleaningFee >= 0, (!isGroupMode || addOnPerNight >= 0) else {
            showResults = false
            showAlert = true
            alertMessage = "The vlues for Nights, Nightly Rate and Cleaning Fee must be greater than 0"
            return
        }


        let roomSubtotal = nightlyRate * Double(nights)
        var finalTotal = roomSubtotal + cleaningFee
        var savedAddonPerNight: Double? = nil
        var savedGroupDiscount: Double? = nil

        if stayType == .group {
            savedAddonPerNight = addOnPerNight
            savedGroupDiscount = groupDiscount

            let grossGroupTotal = roomSubtotal + (addOnPerNight * Double(nights)) + cleaningFee
            let discountFactor = 1.0 - (groupDiscount / 100.0)
            finalTotal = grossGroupTotal * discountFactor
        }

        totalQuote = finalTotal
        showResults = true
        
        let stayRecord = StayRecord(stayType: stayType, stayName: stayName.trimmingCharacters(in: .whitespaces).isEmpty ? "Untitled Stay" : stayName, nightlyRate: nightlyRate, nights: nights, cleaningFee: cleaningFee, totalQoute: totalQuote, addonPerNight: isGroupMode ? savedAddonPerNight : nil, groupDiscount: isGroupMode ? savedGroupDiscount : nil)
        
        modelContext.insert(stayRecord)
        try? modelContext.save()
    }
}

#Preview {
    QuoteView()
}
