//
//  CalculateView.swift
//  GoalSaver
//

import SwiftUI
import SwiftData

struct CalculateView: View {
    // TASK 9 – HINT: How do you access the SwiftData context so you can save records?
    // @Environment(...) private var modelContext
    @Environment(\.modelContext) private var modelContext
    
//    @AppStorag–e("userName") private var userName = ""


    // UI state variables are started for you
    @State private var isRegularMode = false
    @State private var showResults = false
    @State private var projectedBalance: Double = 0.0

    // Computed property to cleanly get the current savings type
    var savingsType: SavingsType {
        isRegularMode ? .regular : .fixed
    }

    // TASK 1 – HINT: Add your shared @State input fields here.
    // Defaults: goal name "Holiday Fund", starting amount 1000, interest rate 4.0 (%), term 24 (months)
    // Think about the right TYPE for each one: String, Double or Int?
    // ...
    @State private var goalName: String = "Holiday Fund"
    @State private var startAmount: Double = 1000.0
    @State private var rate: Double = 4.0
    @State private var months: Int = 24
    

    // TASK 1 – HINT: Add your Regular-only @State input fields here.
    // Defaults: monthly deposit 200, monthly boost 0
    // ...
    @State private var monthlyDeposit: Double = 200.0
    @State private var monthlyBoost: Double = 0.0
    
    private var inputsAreValid: Bool {
        !goalName.isEmpty &&
        startAmount > 0 &&
        rate >= 0 &&
        months > 0 &&
        monthlyDeposit >= 0 &&
        monthlyBoost >= 0
    }
    
    @State private var invalidInputAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {

                // --- TOGGLE SECTION ---
                Section {
                    // TASK 2 – HINT: Create a Toggle bound to `isRegularMode`.
                    // Make the Label change between "Fixed Deposit" and "Regular Saver" (text, SF Symbol
                    // AND colour) based on `savingsType`.
                    // EXTRA CREDIT: use `.onChange(of:)` to hide the results when the toggle changes.
                    Toggle(isOn: $isRegularMode) {
                        HStack {
                            if isRegularMode {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .foregroundStyle(.green)
                                Text("Regular Saver")
                            } else {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .foregroundStyle(.blue)
                                Text("Fixed Deposit")
                            }
                        }
                        
                    }
                    .onChange(of: isRegularMode) {
                        showResults = false
                    }
                }
                
                // --- INPUT SECTION ---
                Section("Savings Details") {
                    VStack {
                        // TASK 3 – HINT: Build your shared input fields here.
                        // 1. Goal Name        (String)
                        HStack {
                            Image(systemName: "target")
                                .foregroundStyle(.blue)
                            Text("Goal Name")
                            
                            TextField("Holiday Fund", text: $goalName)
                                .multilineTextAlignment(.trailing)
                        }
                        .padding(.bottom, 10)
                        
                        // 2. Starting Amount  (Double, £)
                        HStack {
                            Image(systemName: "lirasign.circle")
                                .foregroundStyle(.blue)
                            Text("Starting Amount")
                            
                            TextField("1,000", value: $startAmount, format: .currency(code: "GBP"))
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                            
                        }
                        .padding(.bottom, 10)
                        
                        // 3. Interest Rate %  (Double)
                        HStack {
                            Image(systemName: "percent")
                                .foregroundStyle(.blue)
                            Text("Interest Rate")
                            
                            TextField("4.0%", value: $rate, format: .number.precision(.fractionLength(1)))
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                            Text("%")
                        }
                        .padding(.bottom, 10)
                        
                        // 4. Term in Months   (Int)
                        // Each row: a Label with an SF Symbol on the left, the TextField on the right.
                        // Think about the correct keyboard type for each field.
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundStyle(.blue)
                            Text("Term (months)")
                            
                            TextField("24", value: $months, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        
                        // TASK 4 – HINT: REGULAR-ONLY FIELDS
                        // Use an `if` statement checking `savingsType` so these only appear in Regular mode:
                        // - Monthly Deposit TextField
                        // - A `Slider` bound to `monthlyBoost` with a range of 0...50 and a step of 5
                        //   (show the current value next to the label)
                        if savingsType == .regular {
                            HStack {
                                Image(systemName: "plus.circle")
                                    .foregroundStyle(.green)
                                Text("Monthly Deposit")
                                
                                TextField("200", value: $monthlyDeposit, format: .currency(code: "GBP"))
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                            }
                            .padding(.top, 10)
                            
                            VStack {
                                HStack {
                                    Image(systemName: "star")
                                        .foregroundStyle(.green)
                                    Text("Monthly Boost")
                                    Spacer()
                                    Text(monthlyBoost, format: .currency(code: "GBP").precision(.fractionLength(0)))
                                }
                                Slider(value: $monthlyBoost, in: 0...50, step: 5)
                            }
                            .padding(.top, 10)
                            
                        }
                    }
                }
                
                // --- ACTION SECTION ---
                Section {
                    Button(action: calculateAndSave) {
                        HStack {
                            Spacer()
                            Label("Calculate Balance", systemImage: "equal.circle.fill")
                                .font(.headline)
                            Spacer()
                        }
                    }
                }
                
                // --- RESULTS SECTION ---
                if showResults {
                    Section("Results") {
                        // TASK 6 – HINT: Display `projectedBalance` here, formatted to TWO decimal places.
                        VStack{
                            Text("Projected Balance")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(.orange)
                            Text(projectedBalance, format: .currency(code: "GBP").precision(.fractionLength(2)))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.orange)
                        }
                        .frame(maxWidth: .infinity)
                        
                    }
                }
            }
            .navigationTitle("Goal Saver")
            .alert("Inputs are Invalid", isPresented: $invalidInputAlert) {
                Button("OK") { }
            } message: {
                Text("Please check your inputs and try again.")
            }
        }
    }

    private func calculateAndSave() {
        // TASK 5 – CORE MATH PROVIDED – DO NOT EDIT THE MATH FORMULA
        
        guard inputsAreValid else {
            showResults = false
            invalidInputAlert = true
            return
        }

         let monthlyRate = (rate / 100.0) / 12.0
         let doubleMonths = Double(months)

         // Compound growth factor: (1 + r) to the power n
         let growth = pow(1 + monthlyRate, doubleMonths)

         // The starting amount grows with compound interest
         var balance = startAmount * growth

         // HINT: values that only exist in Regular mode must be Optionals so a Fixed record can store nil
         var savedDeposit: Double? = nil
         var savedBoost: Double? = nil

         if savingsType == .regular {
         // Each month the saver pays in the deposit PLUS the boost
         let contribution = monthlyDeposit + monthlyBoost

         // HINT: keep the Regular-only values so you can pass them to your data model later
         // savedDeposit = ...
         // savedBoost = ...
             savedDeposit = monthlyDeposit
             savedBoost = monthlyBoost
             

         // Future value of the monthly contributions
         if monthlyRate > 0 {
         balance += contribution * (growth - 1) / monthlyRate
         } else {
         balance += contribution * doubleMonths
         }
         }

         // HINT: store the result in `projectedBalance`, then reveal the Results section
         // projectedBalance = ...
         // showResults = ...
        projectedBalance = balance
        showResults = true

        // TASK 9 – SWIFTDATA SAVE
        // HINT: 1. Create a new instance of your SavingsRecord.
        // HINT: 2. Insert it into the modelContext.
        let newSavingsRecord = SavingsRecord(type: savingsType, goalName: goalName, startAmount: startAmount, rate: rate, months: months, projectedBalance: projectedBalance, monthlyDeposit: isRegularMode ? savedDeposit : nil, monthlyBoost: isRegularMode ? savedBoost : nil)
        
        modelContext.insert(newSavingsRecord)
        try? modelContext.save()
    }
}


#Preview {
    CalculateView()
    // HINT (after Task 8): previews that use SwiftData need a container too:
    // .modelContainer(for: SavingsRecord.self, inMemory: true)
}
