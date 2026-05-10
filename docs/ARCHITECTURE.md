# aptu-app Architecture

## Overview

aptu-app is the mobile client for [Aptu](https://github.com/clouatre-labs/aptu). It consists of a Kotlin Multiplatform application and a UniFFI Rust bridge that exposes `aptu-core` to Kotlin.

## Repository Structure

```
aptu-app/
├── AptuKMP/              # Kotlin Multiplatform application
│   ├── androidApp/       # Android entry point (Compose Multiplatform)
│   ├── iosApp/           # iOS entry point (SwiftUI host -- parked)
│   └── shared/           # Shared KMP module: business logic, UI, ViewModels
│       ├── src/commonMain/  # Platform-independent code
│       ├── src/androidMain/ # Android-specific implementations
│       └── build.gradle.kts # Gobley + UniFFI configuration
└── crates/
    └── aptu-ffi/         # UniFFI Rust bridge
        ├── src/lib.rs    # Exposed API surface
        ├── Cargo.toml    # Depends on aptu-core (git dep)
        └── build.rs      # UniFFI build script
```

## Dependency Model

```
aptu-app (this repo)
├── crates/aptu-ffi        # Rust library
│   └── aptu-core          # Git dep → clouatre-labs/aptu (pinned SHA)
│       ├── AI providers   # OpenRouter, Gemini, etc.
│       ├── GitHub API     # Octocrab wrapper
│       └── Triage engine  # Issue analysis logic
└── AptuKMP/shared         # Kotlin, consumes aptu-ffi via Gobley + UniFFI
    └── androidApp         # Compose Multiplatform UI
```

`aptu-core` is consumed as a pinned git dependency. Switch to the crates.io version once `aptu-core` is published.

## Key Abstractions

### UniFFI Bridge (`crates/aptu-ffi`)

`aptu-ffi` re-exports a subset of `aptu-core` functions via UniFFI procedure definitions. The build script generates Kotlin bindings that are consumed by the KMP shared module through [Gobley](https://github.com/gobley/gobley).

### Gobley Configuration

`AptuKMP/shared/build.gradle.kts` sets `packageDirectory` to `../../crates/aptu-ffi` (the Cargo package root), enabling Gobley to compile the Rust library and link it into the Android/iOS targets.

### Token Provider

`FfiTokenProvider` in `aptu-core` resolves credentials from the Android Keystore (via KVault) on Android and from the iOS Keychain on iOS. This is the same `TokenProvider` trait used by the CLI, ensuring consistent security behavior across platforms.

## Build Pipeline

1. Gobley invokes `cargo build --target aarch64-linux-android` for the FFI crate
2. UniFFI generates Kotlin bindings from the compiled library
3. Gradle compiles the shared KMP module against the generated bindings
4. The Android APK is assembled, linking the Rust `.so` library

## Testing Strategy

- **Rust unit tests**: `cargo test --workspace` in `crates/aptu-ffi`
- **KMP unit tests**: `./gradlew :shared:testDebugUnitTest` (JVM-backed, no Android device needed)
- **Android unit tests**: `./gradlew :androidApp:testDebugUnitTest`
- **Instrumented tests**: Not yet configured (tracked in open issues)

## MSRV

Rust 1.95.0 (pinned via `rust-toolchain.toml`).
