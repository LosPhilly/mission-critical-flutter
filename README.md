# Mission-Critical Flutter: FlightApp Reference Implementation

![Mission Critical Flutter Banner](assets/images/mcfBookCoverTallBycphil.png)

> **A High-Integrity Flutter application built with rigor, reliability, and strict engineering standards derived from the Joint Strike Fighter (JSF) C++ Coding Standards.**

---

## 📖 Overview

This repository serves as the official reference implementation for the **Mission-Critical Flutter (MCF)** methodology.  
It demonstrates how to build **safety‑critical mobile applications** where failure is not an option.

Standard Flutter encourages rapid prototyping — but speed introduces risk.  
Mission‑critical systems demand something else:

- **Deterministic behavior**  
- **Architectural isolation**  
- **Total type safety**  
- **Predictable state flow**

MCF enforces a strict Dart subset to eliminate entire classes of runtime errors such as:

- `TypeError`
- `NullPointer`
- Race conditions  
- Illegal layer access  
- Uncaught UI states

### **Core Philosophy**
1. **Architecture:** Strict separation of Presentation, Domain, and Data Layers.  
2. **Safety:** Zero tolerance for `dynamic`, implicit casts, or unsafely nullable logic.  
3. **State:** Immutable, exhaustive, unidirectional state machines.  
4. **Verification:** 100% business logic test coverage + Golden tests for UI stability.

---

## 🏗 Architecture

This project follows a **Clean Architecture** pattern with a strict **Composition Root**, ensuring that dependencies only flow downward.

---

### **The Composition Root**

`main.dart` is the single entry point that assembles the complete dependency graph.

<p align="center">
  <img src="assets/images/compositionLayerWMain.png" width="600" alt="Composition Root Diagram">
</p>

---

### **Dependency Flow (Rule 2.2)**

The Domain layer is completely pure:  
❌ No Flutter  
❌ No JSON  
❌ No HTTP  
❌ No UI imports  

<p align="center">
  <img src="assets/images/layered_dependencyFlow.png" width="600" alt="Dependency Flow Diagram">
</p>

```text
lib/
├── domain/            # PURE LOGIC (Rules, Entities, Failures, Interfaces)
│   ├── entities/
│   ├── failures/
│   └── repositories/  # Abstract Contracts Only
│
├── data/              # INFRASTRUCTURE (Serialization, Networking)
│   ├── models/        # DTOs -> Entities
│   └── repositories/  # Concrete Implementations
│
├── presentation/      # UI + State (Flutter Only)
│   ├── cubit/         # Logic Containers (Enforce Rule 5.1)
│   └── screens/       # Stateless Widgets
│
└── main.dart          # COMPOSITION ROOT
```

---

## 🔄 State Management (MCF Rule 5.1)

State must always flow **downward**.  
UI elements never mutate state directly.

<p align="center">
  <img src="assets/images/5.1stateManagement.png" width="700" alt="Unidirectional Data Flow">
</p>

- UI dispatches an event/intent  
- Cubit processes the event using Domain logic  
- Cubit emits a new **immutable state**  
- UI rebuilds based on that state  

No shortcuts. No mutable leaks. Zero ambiguity.

---

## 🛠️ The MCF CLI (Strongly Recommended)

To avoid human error and enforce strict compliance, use the official MCF CLI:

**Pub.dev:** https://pub.dev/packages/mcf_cli  
**Repository:** https://github.com/LosPhilly/mcf_cli  

### Installation
```bash
dart pub global activate mcf_cli
```

### Generate a fully compliant feature:
```bash
mcf create feature user_profile
```

This creates:

- Domain entity + repository contract  
- Data DTO + repository implementation  
- Presentation Cubit + State + UI scaffold  
- Strict imports + analysis rules  

---

## 🛡️ MCF Compliance Checklist

| Rule | Description | Status |
|------|-------------|--------|
| **MCF 2.2** | Strict Layer Isolation | ✔️ Enforced |
| **MCF 3.1** | Strict Analysis (no implicit casts/inference) | ✔️ Enforced |
| **MCF 3.4** | No bang operator `!` allowed | ✔️ Zero tolerated |
| **MCF 4.1** | Stateless Widgets by default | ✔️ Required |
| **MCF 5.1** | Unidirectional State Flow | ✔️ Mandatory |
| **MCF 6.5** | Heavy JSON parsing offloaded to isolates | ✔️ compute() used |
| **MCF 6.6** | Async reentrancy guards | ✔️ Implemented |
| **MCF 7.5** | Golden tests for critical UI | ✔️ Included |

---

## 🚀 Getting Started

### **Prerequisites**
- Flutter SDK **3.10.0+**
- Dart SDK **3.0.0+** (sealed classes support)

### **Installation**
Clone the repository:

```bash
git clone https://github.com/LosPhilly/mission-critical-flutter
cd flightapp
```

Install dependencies:

```bash
flutter pub get
```

Run:

```bash
flutter run
```

---

## 🧪 Verification & Testing

This project uses the **Mission-Critical Test Pyramid**:

---

### **1. Unit Tests (Business Logic)**  
100% branch coverage for Cubits + Domain logic.

```bash
flutter test test/presentation/cubit/user_cubit_test.dart
```

---

### **2. Widget Tests (UI Behavior)**  
Ensures correct wiring between state and UI.

```bash
flutter test test/presentation/screens/profile_screen_test.dart
```

---

### **3. Golden Tests (Visual Regression)**  
Ensures pixel-perfect UI rendering over time.

Run:

```bash
flutter test test/presentation/screens/profile_screen_golden_test.dart
```

Regenerate after intentional UI changes:

```bash
flutter test --update-goldens
```

---

## 🔧 Technical Stack

| Component | Technology |
|-----------|------------|
| Framework | Flutter |
| Language | Dart (Strict Mode) |
| State Management | flutter_bloc |
| Equality | equatable |
| Networking | http |
| Testing | mocktail • bloc_test |
| Linting | very_good_analysis (MCF‑customized) |

---

## 📄 License

Licensed under the **MIT License**.  
See the LICENSE file for full details.

> **"The difference between a prototype and a product is not features; it is predictability."**

---

## ✍️ Citation

If you reference this architecture or implementation:

**Phillips, Carlos. (2025). _Mission-Critical Flutter: Building High-Integrity Applications._**

