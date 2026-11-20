//
//  ContentView.swift
//  MNAD23-ICT (reference solution)
//
//  Home Page: list of items with steppers, Checkout button, previous deal (persisted).
//

import SwiftUI

struct ContentView: View {

    // Persisted across launches. CartView writes the same key, so this text
    // updates by itself when the user comes back from the cart.
    @AppStorage(StorageKeys.previousDeal) private var previousDeal: Double = 0.0

    // The home page OWNS the basket (single source of truth).
    @State private var shopItems = ShopItem.catalogue

    @State private var showCartView = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                List {
                    // Appendix hint: iterate indices so each row gets a Binding to its own item.
                    ForEach(shopItems.indices, id: \.self) { index in
                        ShopItemRow(item: $shopItems[index])
                    }
                }
                .listStyle(.plain)

                Button("Checkout") {
                    showCartView = true
                }
                .buttonStyle(.bordered)
                .tint(.green)

                Text("Your previous deal with us was \(previousDeal.asDollars)")
                    .font(.footnote)
                    .padding(.bottom)
            }
            .navigationTitle("Buy Fresh Groceries")
            .navigationDestination(isPresented: $showCartView) {
                // Pass a COPY of the current basket. The cart only reads it.
                CartView(shopItems: shopItems)
            }
        }
    }
}

/// Reusable row. @Binding = read and write the parent's value without owning it.
struct ShopItemRow: View {
    @Binding var item: ShopItem

    private let imageSize: CGFloat = 60

    var body: some View {
        HStack(spacing: 12) {
            Image(item.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: imageSize, height: imageSize)

            VStack(alignment: .leading, spacing: 6) {
                Text(item.name)
                Text(item.price.asDollars)
                    .font(.caption)
                    .bold()
            }

            Spacer()

            // `in:` range enforces the "max 10 per item" rule. The minus/plus
            // buttons disable themselves at the bounds automatically.
            Stepper("Quantity of \(item.name)", value: $item.quantity, in: 0...ShopItem.maxQuantity)
                .labelsHidden()

            Text("\(item.quantity)")
                .frame(minWidth: 24)
        }
    }
}

#Preview {
    ContentView()
}
