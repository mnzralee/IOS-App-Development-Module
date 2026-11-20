//
//  CartView.swift
//  MNAD23-ICT (reference solution)
//
//  Cart Page: "Your Cart is Empty" OR purchased items + net amount.
//  A new bill is generated every time this page appears.
//

import SwiftUI

struct CartView: View {

    // Read-only input from the Home Page.
    let shopItems: [ShopItem]

    // Same key as ContentView: writing here updates Home's text and survives relaunch.
    @AppStorage(StorageKeys.previousDeal) private var previousDeal: Double = 0.0

    @State private var total: Double = 0.0

    // Derived: only items the user actually picked.
    private var purchasedItems: [ShopItem] {
        shopItems.filter { $0.quantity > 0 }
    }

    var body: some View {
        // NOTE: no NavigationStack here. The starter had one, but this view is
        // pushed INTO ContentView's stack. Nesting stacks gives a double nav bar.
        Group {
            if purchasedItems.isEmpty {
                VStack {
                    Text("Your Cart is Empty")
                        .padding(.top)
                    Spacer()
                }
            } else {
                List {
                    Section("Purchased Items") {
                        ForEach(purchasedItems) { item in
                            HStack {
                                Text(item.name)
                                Spacer()
                                Text(calculatePurchasedItems(item: item).asDollars)
                            }
                        }
                    }

                    Section("Payment Details") {
                        HStack {
                            Text("Net Amount")
                            Spacer()
                            Text(total.asDollars)
                                .bold()
                        }
                    }
                }
            }
        }
        .navigationTitle("My Cart")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: calculateTotal)   // new bill on every Checkout
    }

    /// price for one line = item price x item quantity
    private func calculatePurchasedItems(item: ShopItem) -> Double {
        item.price * Double(item.quantity)
    }

    /// total bill = sum of every line; then persist it as the "previous deal"
    private func calculateTotal() {
        total = shopItems.reduce(0) { runningTotal, item in
            runningTotal + calculatePurchasedItems(item: item)
        }
        previousDeal = total
    }
}

#Preview("With items") {
    var items = ShopItem.catalogue
    items[0].quantity = 2
    items[3].quantity = 1
    return NavigationStack { CartView(shopItems: items) }
}

#Preview("Empty") {
    NavigationStack { CartView(shopItems: ShopItem.catalogue) }
}
