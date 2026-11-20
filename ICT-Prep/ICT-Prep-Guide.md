# ICT Prep Guide: iOS / SwiftUI In-Lab Test

Built from the papers in `past paper/`, the Week 6 ParcelCost spec, the GoalSaver practice build, and Lectures 1 to 5.
Every code file under `Solutions/` type-checks against the iOS SDK (Swift 5, Swift 6, and Swift 6 with MainActor default isolation), and the pricing and decoding logic was run against the worked examples in the specs.

> Rule from the 2025 paper: **a submission with compile errors gets 0 marks.** Build after every step. Commented-out code beats broken code.

---

## 0. What the papers tell you

| | 2023 ICT: Grocery Cart | 2025 ICT (draft): Cat Breeds Explorer | Week 7 practical pattern: ParcelCost / GoalSaver |
|---|---|---|---|
| Starter? | Yes, stubbed with comments | **No, build from scratch** | Yes, stubbed with TODOs |
| Core skill | `@State` array, `Stepper`, navigation, `@AppStorage` | **Networking** (URLSession async/await), **Codable**, MVVM, `AsyncImage`, `@AppStorage` onboarding | Form input, conditional UI, `guard` validation, alert, **SwiftData** (`@Model`, `@Query`), filter, delete |
| Marks | UI 40, Logic 40, Viva 10, Quality 5, Extra 5 | Setup 5, Model 5, AppStorage 5, Networking 15, **ViewModel 20**, **UI 30**, Quality 5, **Oral 15** | Calc 20, Layout 30, SwiftData 15, History 30, Quality 5 |
| Architecture | Plain views | **MVVM expected** ("clean separation of concerns") | **No MVVM** ("plain SwiftUI views, state and SwiftData") |
| Solution | [GroceryCart2023](Solutions/GroceryCart2023) | [CatBreeds2025](Solutions/CatBreeds2025) | [ParcelCostWeek7](Solutions/ParcelCostWeek7) |

The ParcelCost spec says it outright: *"The practical will use a different domain, so you must recognise the underlying patterns."* So learn the **patterns**, not the apps:

1. **State** drives UI (`@State`, `@Binding`)
2. **Conditional UI** (`if`, ternary label/icon/colour)
3. **Calculation** in small named functions
4. **Validation** with `guard` + alert
5. **Persistence**: `@AppStorage` (small values) or SwiftData (records)
6. **Read + filter** (`@Query`, computed filtered array)
7. **Remote data**: URLSession → Codable → ViewModel → List

Allowed during the test: Xcode autocomplete and **Apple Developer Documentation** (Xcode → Window → Developer Documentation, `⇧⌘0`). Practise looking things up there. No AI tools.

---

## 1. Fix these in your current practice project first

Your `Cat Breed Explorer` project has two compile errors and one silent bug:

| File | Problem | Fix |
|---|---|---|
| `Cat_Breed_ExplorerApp.swift` | `catAPIService.testJSONDecoding()` does not exist (`testJSONDecoding` is a free function, there is no `catAPIService` object). **Compile error.** | Delete the `init()`. Test decoding in a `#Preview` or unit test instead. |
| `CatAPIService.swift` | `#Preview( testJSONDecoding() )` is not valid: `#Preview` must return a View. **Compile error.** | Remove it. |
| `CatBreed.swift` | `case referenceImage = "reference_image"`. The JSON key is **`reference_image_id`**. Because the property is optional, decoding does **not** fail: every breed just gets `nil` and no images ever load. (Verified: this decodes to nil with no error.) | `case referenceImageId = "reference_image_id"` |

Also: when I called `https://api.thecatapi.com/v1/breeds` today without a key it returned **403 "Authentication required"**. Test it from your Mac before the exam. If you get 403, grab a free key from thecatapi.com and send it as the `x-api-key` header (see `AppConstants.API.apiKey` in the solution). This is also why the status-code check matters: without it you'd get a confusing *decoding* error instead of "status 403".

---

## 2. Core concepts you must be fluent in

### 2.1 Swift essentials

```swift
// struct = value type (copied). Default for models. SwiftUI notices changes.
struct ShopItem: Identifiable { let id = UUID(); let name: String; var quantity: Int }

// class = reference type (shared). Needed for @Model and @Observable.
@Model final class ParcelData { var cost: Double; init(cost: Double) { self.cost = cost } }

// enum = closed set of choices. rawValue for display/storage, CaseIterable for pickers.
enum ParcelType: String, Codable, CaseIterable { case personal = "Personal", business = "Business" }

// Computed property: derive, don't store twice
var volume: Double { length * width * height }

// Optionals
if let insurance = record.insuranceAmount { Text("Ins: \(insurance)") }   // show only if present
guard let url = URL(string: urlString) else { throw APIError.invalidURL } // early exit
let name = userName.isEmpty ? "Guest" : userName
let label = optionalText ?? "Unknown"

// guard = validate first, leave early, happy path stays unindented
guard inputsAreValid else { showInvalidInput = true; return }

// Closures on collections
let picked = items.filter { $0.quantity > 0 }
let names  = items.map { $0.name }
let total  = items.reduce(0) { $0 + $1.price * Double($1.quantity) }

// Extension: add behaviour to an existing type
extension Double { var asDollars: String { String(format: "$%.2f", self) } }
```

**Gotcha (2023 starter):** `ShopItem` is a `class`. `@State` watches the *array value*; changing `item.quantity` inside a class instance doesn't change that value, so the UI may not refresh. Change it to `struct` (or mark the class `@Observable`). Be ready to explain this in the viva.

### 2.2 Property wrappers: who owns the data?

| Wrapper | Use when | Example |
|---|---|---|
| `@State` | This view **owns** simple, temporary UI state | `@State private var showCart = false` |
| `@Binding` | A child needs to **read and write** the parent's value without owning it | `@Binding var item: ShopItem`, passed as `$shopItems[index]` |
| `@AppStorage("key")` | Small value that must **survive relaunch** (UserDefaults) | `@AppStorage("previousDeal") var previousDeal = 0.0` |
| `@Observable` class + `@State` | ViewModel: the view owns an object with several properties + logic | `@State private var viewModel = CatBreedViewModel()` |
| `@Bindable` | You need `$` bindings to properties of an `@Observable` object you didn't create | `@Bindable var vm: FormViewModel` then `TextField("", text: $vm.name)` |
| `@Environment(\.x)` | Read something injected higher up (no prop drilling) | `@Environment(\.modelContext) private var modelContext` |
| `@Query` | Read SwiftData records **and** auto-update when they change | `@Query(sort: \ParcelData.timestamp, order: .reverse) var records: [ParcelData]` |

Five questions before choosing one (Lecture 3): **Who owns it? What type is it? Who needs it? Does a child need to write it? Must it persist?**

`@AppStorage` handles `Bool`, `Int`, `Double`, `String`, `URL`, `Data`, and `String`/`Int`-backed enums. Use the **same key** in two views and they stay in sync automatically (that's how "previous deal" updates when you come back from the cart). Put keys in constants so a typo can't split them.

### 2.3 Layout and controls

```swift
VStack(alignment: .leading, spacing: 8) { }   HStack { Text("A"); Spacer(); Text("B") }   ZStack { }

List { Section("Purchased Items") { ForEach(items) { Text($0.name) } } }
ForEach(items.indices, id: \.self) { i in Row(item: $items[i]) }   // 2023 appendix pattern
ForEach($items) { $item in Row(item: $item) }                       // same idea, needs Identifiable

Form { Section("Dimensions & Weight") { ... } }        // settings-style input screen

TextField("Name", text: $name)                                    // String
TextField("0.0", value: $weight, format: .number)                 // Double: numeric binding + format
    .keyboardType(.decimalPad)                                    // .numberPad for whole numbers
    .multilineTextAlignment(.trailing)

Stepper("Qty", value: $item.quantity, in: 0...10).labelsHidden()  // range enforces the max
Toggle(isOn: $isInsured) { Label(title, systemImage: symbol) }.tint(.purple)
Slider(value: $insurance, in: 0...100, step: 5)
Picker("Filter", selection: $filter) {
    ForEach(Filter.allCases) { Text($0.rawValue).tag($0) }
}.pickerStyle(.segmented)

Button("Checkout") { showCart = true }.buttonStyle(.bordered).tint(.green)
Label("Egypt", systemImage: "globe")
Image("broccoli").resizable().scaledToFit().frame(width: 60, height: 60)  // asset by name
Image(systemName: "cat.fill")                                              // SF Symbol
```

`AsyncImage` (2025 paper names it in the marks):

```swift
AsyncImage(url: url) { phase in
    switch phase {
    case .empty: ProgressView()
    case .success(let image): image.resizable().scaledToFill()
    case .failure: Image(systemName: "photo")
    @unknown default: EmptyView()
    }
}
.frame(width: 80, height: 80)
.clipShape(RoundedRectangle(cornerRadius: 10))
```

Gotcha: `AsyncImage(url: nil)` stays in `.empty` forever (endless spinner). Check `if let url` first.

### 2.4 Navigation and presentation

```swift
// Root of a navigation flow. Only ONE per flow: never put a NavigationStack inside a pushed view.
NavigationStack {
    content
        .navigationTitle("Buy Fresh Groceries")
        .navigationDestination(isPresented: $showCart) { CartView(shopItems: shopItems) } // Bool-driven
        .navigationDestination(for: CatBreed.self) { DetailView(breed: $0) }              // value-driven
}
NavigationLink(value: breed) { CatBreedRowView(breed: breed) }   // type must be Hashable
.navigationBarTitleDisplayMode(.inline)

TabView {
    Tab("Calculate", systemImage: "list.bullet") { CalculateView() }
    Tab("History", systemImage: "calendar") { HistoryView() }
}

.alert("Invalid Input", isPresented: $showInvalidInput) {
    Button("OK", role: .cancel) { }
} message: { Text("Please ensure ...") }

.sheet(isPresented: $showAdd) { AddView() }
```

The 2023 starter's `CartView` wraps itself in a `NavigationStack`. Remove it: that view is pushed into Home's stack, and nesting gives a double nav bar.

### 2.5 Conditional UI and lifecycle

```swift
if viewModel.isLoading { ProgressView() } else if let msg = viewModel.errorMessage { Text(msg) } else { List ... }
if parcelType == .business { Slider(...) }                       // removes the view entirely
Text(parcelType.title).foregroundStyle(isInsured ? .purple : .blue)

.onAppear { calculateTotal() }          // runs every time the view appears ("new bill each checkout")
.onDisappear { ... }
.task { await viewModel.loadIfNeeded() } // async work, auto-cancelled when the view goes away
.refreshable { await viewModel.loadBreeds() }
.onChange(of: isInsured) { showResults = false }   // hide a stale result when the mode flips
```

`if` vs `.opacity(0)`: `if` removes the view (no space, not tappable, not read by VoiceOver). Opacity only hides it.

### 2.6 Formatting cheat sheet

| Want | Code |
|---|---|
| `$50.00` exactly | `String(format: "$%.2f", value)` |
| `£50.75` | `Text(value, format: .currency(code: "GBP"))` |
| Inside a sentence | `Text("Cost: \(cost, format: .currency(code: "GBP"))")` |
| 2 decimal places | `Text("\(weight, specifier: "%.2f") kg")` |
| `17 Oct 2026` | `date.formatted(.dateTime.day().month(.abbreviated).year())` |
| Trim input | `name.trimmingCharacters(in: .whitespacesAndNewlines)` |
| Asset name | `item.name.lowercased()` ("Broccoli" → "broccoli") |

### 2.7 SwiftData (Week 7 pattern)

The trio: **`@Model`** (the table), **`ModelContainer`** (the database, created once in the App), **`ModelContext`** (where you insert/delete/save).

```swift
// 1. Model
@Model final class ParcelData {
    var type: ParcelType
    var cost: Double
    var insuranceAmount: Double?   // optional: Personal has NO insurance, which is not the same as £0
    var timestamp: Date            // enables "newest first"
    init(type: ParcelType, cost: Double, insuranceAmount: Double? = nil, timestamp: Date = .now) { ... }
}

// 2. App: register the model
WindowGroup { ContentView() }.modelContainer(for: ParcelData.self)

// 3. Write (CalculateView)
@Environment(\.modelContext) private var modelContext
modelContext.insert(ParcelData(type: parcelType, cost: total, insuranceAmount: isInsured ? insurance : nil))
try? modelContext.save()

// 4. Read (HistoryView)
@Query(sort: \ParcelData.timestamp, order: .reverse) private var records: [ParcelData]

// 5. Filter: computed, NOT a second stored array
private var filteredRecords: [ParcelData] {
    switch selectedFilter {
    case .all: records
    case .personal: records.filter { $0.type == .personal }
    case .business: records.filter { $0.type == .business }
    }
}

// 6. Delete: offsets refer to the array the ForEach shows, so use the FILTERED one
ForEach(filteredRecords) { ParcelRowView(record: $0) }.onDelete { offsets in
    for i in offsets { modelContext.delete(filteredRecords[i]) }
}

// 7. Previews: always in-memory, or the preview crashes / touches real data
#Preview { HistoryView().modelContainer(for: ParcelData.self, inMemory: true) }
```

**Inputs are `@State`/`@AppStorage`, not model properties.** The model only holds what a *saved record* needs to display.

### 2.8 Networking + Codable (2025 pattern)

**Model:** match JSON keys exactly, make anything that can be missing optional.

```swift
struct CatBreed: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let origin: String
    let description: String
    let lifeSpan: String              // "14 - 15" is a String in the JSON
    let referenceImageId: String?     // some breeds have none

    enum CodingKeys: String, CodingKey {
        case id, name, origin, description
        case lifeSpan = "life_span"
        case referenceImageId = "reference_image_id"
    }
}
```

Alternative: `decoder.keyDecodingStrategy = .convertFromSnakeCase` with **no** CodingKeys. Don't mix the two: with the strategy on, a CodingKey raw value of `"life_span"` no longer matches.

**Service: "Ask, wait, check, then decode" (Lecture 5)**

```swift
func fetchBreeds() async throws -> [CatBreed] {
    guard let url = URL(string: AppConstants.API.breedsURL) else { throw CatAPIError.invalidURL }
    let (data, response) = try await URLSession.shared.data(from: url)                 // ask + wait
    guard let http = response as? HTTPURLResponse else { throw CatAPIError.invalidResponse }
    guard (200...299).contains(http.statusCode) else { throw CatAPIError.badStatus(http.statusCode) } // check
    do { return try JSONDecoder().decode([CatBreed].self, from: data) }               // decode (top level is an ARRAY)
    catch { throw CatAPIError.decodingFailed }
}
```

**ViewModel: screen state + actions, no SwiftUI, no JSON**

```swift
@MainActor @Observable
final class CatBreedViewModel {
    private(set) var breeds: [CatBreed] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private let service = CatAPIService()   // not a default-arg init: that warns under MainActor-by-default

    func loadBreeds() async {
        isLoading = true; errorMessage = nil
        defer { isLoading = false }
        do { breeds = try await service.fetchBreeds() }
        catch { errorMessage = error.localizedDescription }
    }
}
```

**View:** `@State private var viewModel = CatBreedViewModel()`, then `.task { await viewModel.loadIfNeeded() }` and three states: loading, error (with Try Again), list.

Decoding errors are evidence about the JSON contract: `keyNotFound` (missing key / wrong CodingKey), `typeMismatch` (e.g. you said `Int`, JSON has `"14 - 15"`), `valueNotFound` (null in a non-optional).

### 2.9 MVVM: who does what

| Layer | Job | Must NOT |
|---|---|---|
| Model (`CatBreed`) | Describe the data | Know about UI or networking |
| Service (`CatAPIService`) | Build request, call API, check status, decode | Hold UI state |
| ViewModel (`CatBreedViewModel`) | Screen state (`breeds`, `isLoading`, `errorMessage`) + actions | Import SwiftUI, decode JSON |
| View | Layout, read VM state, forward user actions | Do networking or business rules |

Use MVVM when the brief marks "ViewModel Logic" (2025). Don't add it when the brief says plain views (ParcelCost). Following the brief **is** the marks.

### 2.10 Code-quality marks (cheap 5%)

- Folders: `Models/`, `ViewModels/`, `Views/`, `Services/` (Xcode: right-click → New Group).
- Constants enum for URLs, keys, limits, prices. No magic numbers in views.
- `private` on state and helpers, `private(set)` on VM outputs.
- Small reusable subviews (`ShopItemRow`, `DimensionInput`, `CatBreedRowView`).
- Names that read like English: `calculateTotal()`, `filteredRecords`, `inputsAreValid`.
- A `#Preview` for every view (with sample data / in-memory container).

---

## 3. Paper blueprints (requirement → code)

### 3.1 2023 Grocery Cart (starter provided)
Files: [ShopItem.swift](Solutions/GroceryCart2023/ShopItem.swift), [ContentView.swift](Solutions/GroceryCart2023/ContentView.swift), [CartView.swift](Solutions/GroceryCart2023/CartView.swift)

| Requirement | How |
|---|---|
| 5 items with image, name, price | `@State var shopItems` array; `Image(item.name.lowercased())` |
| Change quantity, max 10 | `Stepper(value: $shopItems[index].quantity, in: 0...10)` |
| Checkout → Cart page | `Button` sets `showCartView = true`; `.navigationDestination(isPresented:)` |
| New bill on each checkout | `CartView.onAppear { calculateTotal() }` |
| "Your previous deal with us was $50.00", persists | `@AppStorage("previousDeal")` in **both** views; Cart writes, Home reads |
| "Your Cart is Empty" | `if purchasedItems.isEmpty` where `purchasedItems = shopItems.filter { $0.quantity > 0 }` |
| Line totals + net amount | `List { Section("Purchased Items") ...; Section("Payment Details") ... }` |
| iPhone SE support | `List`/`Spacer`/`.scaledToFit()`, no fixed full-screen sizes; run on the SE simulator |

Order (target ~75 min): data array → row UI → stepper → button + navigation → cart filter + empty state → totals → AppStorage → polish + SE check.

### 3.2 2025 Cat Breeds Explorer (from scratch)
Files: [AppConstants](Solutions/CatBreeds2025/AppConstants.swift), [CatBreed](Solutions/CatBreeds2025/CatBreed.swift), [CatAPIService](Solutions/CatBreeds2025/CatAPIService.swift), [CatBreedViewModel](Solutions/CatBreeds2025/CatBreedViewModel.swift), [App + RootView](Solutions/CatBreeds2025/CatBreedsExplorerApp.swift), [OnboardingView](Solutions/CatBreeds2025/OnboardingView.swift), [HomeView](Solutions/CatBreeds2025/HomeView.swift), [CatBreedRowView](Solutions/CatBreeds2025/CatBreedRowView.swift)

| Requirement | How |
|---|---|
| Onboarding once, collect name | `RootView`: `@AppStorage("hasCompletedOnboarding")` picks Onboarding vs Home |
| "Greetings, {name}" | `@AppStorage("userName")` in Home; `.navigationTitle("Greetings, \(userName)")` |
| Fetch breeds | Service: URLSession async/await + status check + `decode([CatBreed].self)` |
| Only 5 fields | Model has only those + `id`; extra JSON keys are ignored automatically |
| Image URL | computed `imageURL` = base + `referenceImageId` + `.jpg`, `nil` if no id |
| Row: image, name, origin, life span, description | `HStack { AsyncImage; VStack { headline, subheadline, subheadline, caption } }` |
| Async UI updates | `@MainActor @Observable` VM, `.task`, loading/error/list states |

Order (target ~90 min): new project + folders → constants → model → service → VM → Home list with plain `Text` → row with AsyncImage → onboarding + AppStorage → error/loading states → detail view / pull-to-refresh as extras.

### 3.3 Week 7 practical pattern: ParcelCost (and GoalSaver)
Files: [ParcelModel](Solutions/ParcelCostWeek7/ParcelModel.swift), [ParcelType+Display](Solutions/ParcelCostWeek7/ParcelType+Display.swift), [App + Tabs](Solutions/ParcelCostWeek7/ParcelCostApp.swift), [CalculateView](Solutions/ParcelCostWeek7/CalculateView.swift), [HistoryView](Solutions/ParcelCostWeek7/HistoryView.swift)

Button order (spec 7.2b): **validate (guard) → calculate → show result → save record.**

Validation hand-check answers (spec 7.2e), verified by running the code:

| Service | Weight | L × W × H | Ins | Valid? | Cost |
|---|---|---|---|---|---|
| Personal | 1 kg | 20×20×20 | | Yes | £4.30 |
| Personal | 40 kg | 200×10×10 | | **Yes** (limits are Business only) | £25.00 |
| Business | 30 kg | 150×10×10 | £100 | Yes (30 and 150 are allowed) | £161.25 |
| Business | 31 kg | 10×10×10 | £0 | No, over 30 kg | rejected |
| Business | 5 kg | 10×151×10 | £20 | No, 151 > 150 | rejected |
| Personal | 0 kg | 10×10×10 | | No, must be > 0 | rejected |

GoalSaver is the same skeleton with a different domain: Toggle (Fixed / Regular), Regular-only fields shown with `if`, `.onChange(of:)` hides the old result, compound interest with `pow`, `@Model SavingsRecord` with `Double?` for the Regular-only values, `@Query` newest first, segmented filter, `.onDelete` on the filtered array.

---

## 4. Viva questions (10 to 15% of the marks: answer in full sentences)

**State and data flow**
1. *@State vs @Binding?* `@State` means this view owns the value and SwiftUI stores it outside the struct so it survives redraws. `@Binding` is a two-way reference to someone else's state: the child can read and write it but doesn't own it. There is still one source of truth.
2. *Why does a Toggle/Slider/TextField take `$value`?* The control must write back. `$` gives a Binding, not a copy.
3. *Why `@AppStorage` here and not SwiftData?* It's one small value (a flag, a name, a total). AppStorage wraps UserDefaults, persists across launches, and redraws views when it changes. SwiftData is for many structured records.
4. *How does the onboarding show only once?* RootView reads a persisted Bool. When the user taps Continue, I set it to true, SwiftUI re-runs `body`, and it shows Home. Next launch the Bool is already true.
5. *How does "previous deal" update when I go back?* Cart and Home use the same AppStorage key. Cart writes it in `onAppear`, Home's text reads it, so it re-renders automatically.
6. *Why did you change ShopItem to a struct?* `@State` detects changes to values. Mutating a property inside a class doesn't change the array's value, so the view may not refresh. A struct is copied on change, so SwiftUI always notices. (Alternative: `@Observable` class.)
7. *@Observable vs ObservableObject?* `@Observable` is the modern Observation macro: no `@Published`, and SwiftUI only redraws views that actually read the property that changed. The view owns it with `@State`.
8. *What is `private(set)` for?* Views can read the VM's state but only the VM can change it, so every mutation goes through one controlled path.
9. *Why `Identifiable`?* `List`/`ForEach` need a stable id to know which row is which when data changes.

**Networking and Codable**
10. *What does async/await give you?* The network call suspends the task instead of blocking the main thread, so the UI stays responsive, and the code reads top to bottom with normal `try`/`catch`.
11. *Why check the status code?* URLSession doesn't throw for 403/404/500. Without the check you'd try to decode an error body and get a misleading decoding error.
12. *What are CodingKeys?* A naming bridge between JSON `snake_case` and Swift `camelCase`. Once you write them you must list every property you decode.
13. *Why is `referenceImageId` optional?* Some breeds don't have one. If it were non-optional, one missing key throws `keyNotFound` and the **whole** array fails.
14. *Why `@MainActor` on the ViewModel?* Its properties drive the UI, and UI state must be updated on the main thread.
15. *`.task` vs `.onAppear { Task { } }`?* `.task` gives an async context and is cancelled automatically when the view disappears.
16. *Why does the ViewModel not decode JSON?* Separation of concerns: the service owns the network/JSON contract, the VM owns screen state. If the API changes, only the service and model change, and each part can be tested separately.
17. *How do you handle errors?* A custom `LocalizedError` enum (invalid URL, bad status, decoding failed). The VM catches it, stores `errorMessage`, and the View shows it with a Try Again button.

**Validation, calculation, SwiftData**
18. *Why `guard`?* It validates and leaves early, so nothing invalid is ever calculated or saved, and the happy path stays unindented.
19. *Why validate before calculating and saving?* So bad input never produces a result or a database record.
20. *Why split pricing into functions?* Each one has one job, a clear name, and can be tested on its own. The button action just orchestrates.
21. *Why is `insuranceAmount` optional?* Personal parcels have *no* insurance. `0` would mean "insured for £0", which is a different fact and would wrongly show "Ins: £0.00".
22. *Why store a `Date` timestamp instead of a String?* Dates sort correctly and can be formatted for any locale. Strings sort alphabetically.
23. *What does `@Query` do for you?* It fetches the records and keeps watching them, so a record inserted on another tab appears with no sync code.
24. *Why is the filter a computed property, not a second array?* A second array is a second source of truth that can drift. Computed is always derived from the current `@Query` results.
25. *Deleting from a filtered list?* `onDelete` offsets index into what the ForEach is showing, so delete `filteredRecords[index]`, not `records[index]`.
26. *ModelContainer vs ModelContext?* The container is the database set up once in the App. The context is the working area where you insert, delete and save.
27. *Store volume in cm³ or litres?* Store the raw unit and convert when displaying. Presentation is the view's decision.
28. *Why `if` and not `opacity(0)` for the slider?* `if` removes it from layout and interaction; opacity leaves an invisible, tappable control taking up space.
29. *Why are calculator inputs `@State`/`@AppStorage` and not model properties?* They're in-progress UI input. The model represents a *saved* calculation.

---

## 5. Exam-day checklist

**Before you start**
- [ ] Build and run the starter (if given). Open Assets to see the image names.
- [ ] Simulator chosen (for 2023: also run once on an **iPhone SE**).
- [ ] Read the whole brief and the marking scheme. Plan the order by marks.

**While coding**
- [ ] `⌘B` after every small step. Never let errors pile up.
- [ ] Get something on screen with fake data first, then wire up real data.
- [ ] Previews: give them sample data (`CatBreed.sample`) or `inMemory: true`.
- [ ] If a feature fights you at the end, comment it out. **Zero compile errors** beats one more feature.

**Time plan for 2 hours**
| Time | Goal |
|---|---|
| 0:00 to 0:10 | Read brief, build starter, sketch views and state |
| 0:10 to 1:15 | Core logic + core UI (the 40/40 or 20/30 parts) |
| 1:15 to 1:40 | Persistence, edge cases (empty cart, missing image, invalid input) |
| 1:40 to 1:55 | Polish, constants, naming, previews, SE check |
| 1:55 to 2:00 | Final clean build, submit |

**Viva:** walk through the data flow out loud: *"The user taps X → this state changes → this computed property updates → SwiftUI redraws this view."* Name the property wrapper and *why* you chose it.

---

## 6. Practice plan

1. **Today:** fix the 3 issues in section 1, then finish your Cat Breed Explorer **without looking** at the solution. Compare after.
2. **Timed 75 min:** unzip `past paper/MNAD23-ICT Starter.zip` into a fresh folder and do the Grocery Cart from the starter.
3. **Timed 2 h:** unzip `week 6/ParcelCost_Starter.zip` and complete all 8 experiments.
4. **Timed 2 h:** GoalSaver from `GoalSaver_Tutorial.pdf` (same skeleton, new domain): this is the closest rehearsal for a "different domain" practical.
5. Read section 4 out loud. If you can't say an answer in two sentences, re-read that concept.
