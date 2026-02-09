# Somni Analytics – iOS Mobile App

Somni Analytics is a Swift-based iOS application designed to **wake users during the lightest stage of sleep**, helping them feel more rested and alert. The app is part of a larger sleep‑analytics ecosystem that will eventually integrate **wearable hardware via Bluetooth**, **sleep stage classification**, and a **cloud-backed analytics platform**.

This repository focuses on the **iOS client**, built with modern Swift and SwiftUI practices, emphasizing clean architecture, reliability, and resume‑ready engineering patterns.

---

## Features

### Implemented

* **Custom HTTP Client**
  A fully abstracted networking layer supporting:

  * Typed API requests/responses
  * Centralized error handling
  * Async/await concurrency
  * Token‑based authentication support

* **Custom Keychain Wrapper**
  Secure storage abstraction for sensitive data such as:

  * Authentication tokens
  * User identifiers
  * App secrets

* **SwiftUI + MVVM Architecture**

  * Testable ViewModels
  * Scalable feature development

### In Progress / Planned

* **Bluetooth (BLE) Integration**

  * Connect to a custom wearable device
  * Stream raw sensor data (movement, heart rate, etc.)

* **Sleep Stage Classification Algorithm**

  * Classify sleep into stages (light, deep, REM)
  * Drive intelligent wake‑up timing

* **Smart Alarm Scheduling Logic**

  * Wake users within a configurable time window
  * Prioritize light sleep stages before hard cutoff

---

## Architecture Overview

The app follows a **modular MVVM architecture** with protocol‑driven design to enable testability and future expansion.

```
UI (SwiftUI Views)
   ↓
ViewModels (State & Business Logic)
   ↓
Services
   ├── API Client (HTTP)
   ├── Keychain Service
   └── (Future) Bluetooth Service
```

### Key Design Principles

* Protocol‑oriented programming
* Dependency injection
* Async/await for concurrency
* Strong typing for API boundaries

---

## Networking Layer

The custom HTTP client provides:

* A single entry point for all network calls
* Generic request/response handling
* Automatic decoding into Swift models
* Unified error propagation

---

## Security & Keychain

Sensitive data is stored using a **custom Keychain wrapper**, abstracting Apple’s Keychain APIs into a simple, testable interface.

Stored data includes:

* Access tokens
* Refresh tokens
* User session metadata

This ensures:

* Secure persistence across app launches
* No sensitive data stored in UserDefaults

---

## Bluetooth (Planned)

Future Bluetooth capabilities will include:

* BLE device discovery & pairing
* Continuous sensor data streaming
* Background data collection

The Bluetooth layer will be implemented as a standalone service to keep hardware concerns isolated from UI and business logic.

---

## Sleep Classification (Planned)

The sleep classification system will:

* Process time‑series sensor data
* Identify sleep stages using ML or rule‑based logic
* Expose sleep stage probabilities to the alarm system

This module is intentionally decoupled to allow:

* On‑device inference
* Future backend‑driven models

---

## Tech Stack

* **Language:** Swift
* **UI:** SwiftUI
* **Architecture:** MVVM
* **Concurrency:** async/await
* **Security:** Keychain Services
* **Networking:** Custom HTTP Client
* **Bluetooth:** CoreBluetooth (planned)

---

## Getting Started

### Requirements

* Xcode 15+
* iOS 17+
* Swift 5.9+

### Setup

1. Clone the repository
2. Open the project in Xcode
3. Configure environment variables / API base URLs
4. Build & run on simulator or device

---

## Project Status

Somni Analytics is **actively under development** as part of a larger senior design project. Core infrastructure is in place, with hardware integration and sleep intelligence currently in progress.

---

## 📄 License

This project is currently private and not licensed for redistribution.

---

## Contributors

**Hayden Barogh - Primary iOS Developer**
    - Architecture Design (MVVM)
    - Custom HTTP Client
    - Keychain Security Layer
    - Core App Infastructure

**Leena Joulani - iOS Developer**
    - Feature Development and Testing
    - Styling SwiftUI Views

---

If you’re reviewing this project for recruiting or technical evaluation, feel free to reach out for architecture walkthroughs or design discussions.
