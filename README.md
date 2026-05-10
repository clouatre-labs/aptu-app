# aptu-app

Kotlin Multiplatform mobile app (Android and iOS) for [Aptu](https://github.com/clouatre-labs/aptu).

## Structure

```
aptu-app/
├── AptuKMP/          # Kotlin Multiplatform app (Android + iOS)
│   ├── androidApp/   # Android-specific entry point
│   ├── iosApp/       # iOS-specific entry point
│   └── shared/       # Shared KMP module with business logic
└── crates/
    └── aptu-ffi/     # UniFFI Rust bindings exposing aptu-core to Kotlin
```

## Relationship to clouatre-labs/aptu

This repository contains only the mobile client. The core AI triage and PR review logic lives in [clouatre-labs/aptu](https://github.com/clouatre-labs/aptu) (`aptu-core`). The `crates/aptu-ffi` crate bridges Rust to Kotlin via [UniFFI](https://github.com/mozilla/uniffi-rs) and [Gobley](https://github.com/gobley/gobley).

`aptu-core` is consumed as a pinned git dependency; switch to the crates.io version once `aptu-core` is published.

## Building

### Android

```bash
cd AptuKMP
./gradlew :shared:assembleDebug :androidApp:assembleDebug
```

### Rust FFI (Cargo)

```bash
cargo build
```

## License

Apache-2.0. See [LICENSE](LICENSE).
