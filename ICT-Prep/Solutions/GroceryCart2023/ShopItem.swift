//
//  ShopItem.swift
//  MNAD23-ICT (reference solution)
//
//  Changed from `class` to `struct` on purpose:
//  @State watches VALUES. Mutating a property inside a class instance does not change
//  the array value that @State holds, so the UI may not refresh. A struct copy does.
//  (If you must keep the starter's class, mark it `@Observable` instead.)
//

import Foundation

struct ShopItem: Identifiable {
    let id = UUID()

    // name: grocery item name. Lowercased, it matches the asset name ("Broccoli" -> "broccoli").
    let name: String

    // price: unit price in dollars
    let price: Double

    // quantity: how many the user wants (0...maxQuantity)
    var quantity: Int

    // Derived, not stored: no duplicate source of truth.
    var imageName: String { name.lowercased() }
    var lineTotal: Double { price * Double(quantity) }

    static let maxQuantity = 10

    static let catalogue: [ShopItem] = [
        ShopItem(name: "Broccoli", price: 5.00, quantity: 0),
        ShopItem(name: "Banana", price: 8.00, quantity: 0),
        ShopItem(name: "Avocado", price: 10.00, quantity: 0),
        ShopItem(name: "Chicken", price: 20.00, quantity: 0),
        ShopItem(name: "Water", price: 2.00, quantity: 0)
    ]
}

// One place for keys and formatting, so nothing is hard-coded twice.
enum StorageKeys {
    static let previousDeal = "previousDeal"
}

extension Double {
    /// 30 -> "$30.00" (locale independent, matches the spec text exactly)
    var asDollars: String { String(format: "$%.2f", self) }
}
