# ParcelCost — Starter Project

Requires the Xcode version specified for the module (Xcode 26.6), iOS 26.4+ simulator.

1. Open `ParcelCost.xcodeproj`.
2. Select your own team under *Signing & Capabilities* if you want to run on a device (the simulator needs nothing).
3. Run it. Enter a weight, tap **Calculate Cost**, then open the **History** tab.

What works already:
- Two-tab shell (`ContentView.swift`)
- SwiftData container (`ParcelCostApp.swift`)
- A minimal model with `type` and `cost` (`ParcelModel.swift`)
- One input -> placeholder calculation -> result -> saved record -> History list

What you add (follow the experiments in Section 8 of the specification; search the code for `TODO`):
- the remaining inputs, the toggle and the insurance slider
- the real Personal and Business pricing rules
- validation and the alert
- the full model, the History row, sorting and filtering

The placeholder calculation (`weight * 0.50`) is **not** the pricing rule — see Section 4 of the specification.
