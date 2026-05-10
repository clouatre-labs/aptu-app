<p align="center">
  <img src="https://raw.githubusercontent.com/clouatre-labs/aptu/main/assets/logo-light.png" alt="Aptu Logo" width="128">
</p>

<h1 align="center">aptu-app</h1>

<p align="center">
  <a href="https://github.com/clouatre-labs/aptu-app/actions/workflows/ci.yml"><img alt="CI" src="https://img.shields.io/github/actions/workflow/status/clouatre-labs/aptu-app/ci.yml?style=for-the-badge&label=CI&logo=rust" height="20"></a>
  <a href="https://github.com/clouatre-labs/aptu-app/actions/workflows/android-kmp.yml"><img alt="Android CI" src="https://img.shields.io/github/actions/workflow/status/clouatre-labs/aptu-app/android-kmp.yml?style=for-the-badge&label=Android%20CI&logo=android" height="20"></a>
  <a href="https://api.reuse.software/info/github.com/clouatre-labs/aptu-app"><img alt="REUSE" src="https://img.shields.io/reuse/compliance/github.com/clouatre-labs/aptu-app?style=for-the-badge" height="20"></a>
  <a href="LICENSE"><img alt="License" src="https://img.shields.io/badge/license-Apache--2.0-blue?style=for-the-badge" height="20"></a>
</p>

<p align="center"><strong>Kotlin Multiplatform mobile client for <a href="https://github.com/clouatre-labs/aptu">Aptu</a></strong> -- Android and iOS.</p>

Aptu is an AI-powered triage utility for OSS issue triage and PR review. This repository contains the mobile client: a Kotlin Multiplatform app and the UniFFI Rust bridge that exposes [aptu-core](https://github.com/clouatre-labs/aptu) to Kotlin.

## Structure

```
aptu-app/
├── AptuKMP/              # Kotlin Multiplatform application
│   ├── androidApp/       # Android entry point (Compose Multiplatform)
│   ├── iosApp/           # iOS entry point (SwiftUI host -- parked)
│   └── shared/           # Shared KMP module: business logic, UI, ViewModels
└── crates/
    └── aptu-ffi/         # UniFFI Rust bridge exposing aptu-core to Kotlin
```

## Relationship to clouatre-labs/aptu

The AI triage engine, GitHub API client, and all core logic live in [clouatre-labs/aptu](https://github.com/clouatre-labs/aptu) (`aptu-core`). This repository consumes `aptu-core` as a pinned git dependency via [UniFFI](https://github.com/mozilla/uniffi-rs) and [Gobley](https://github.com/gobley/gobley):

```toml
aptu-core = { git = "https://github.com/clouatre-labs/aptu", rev = "<pinned-sha>" }
```

Switch to the crates.io version once `aptu-core` is published.

## Building

### Android

Requires Android Studio Ladybug or later, JDK 21, and a configured Android SDK.

```bash
cd AptuKMP
./gradlew :shared:assembleDebug :androidApp:assembleDebug
```

Run unit tests:

```bash
./gradlew :shared:testDebugUnitTest :androidApp:testDebugUnitTest
```

### Rust FFI

```bash
cargo build
```

Requires Rust 1.95+ and the `aarch64-linux-android` target for Android cross-compilation:

```bash
rustup target add aarch64-linux-android
```

## CI

| Workflow | Runner | Trigger | Purpose |
|---|---|---|---|
| `ci.yml` | `ubuntu-24.04-arm` | push/PR on `crates/**`, `Cargo.*` | Build, test, lint, and audit Rust FFI |
| `android-kmp.yml` | `ubuntu-24.04` | push/PR on `AptuKMP/**`, `crates/aptu-ffi/**` | Build and test Android app; x86_64 required for NDK host binaries |
| `ios-kmp.yml` | `macos-15` | `workflow_dispatch` (parked) | iOS simulator build; re-enable once Android is stable |
| `reuse.yml` | `ubuntu-24.04-arm` | push/PR on source files | REUSE license compliance |
| `issue-triage.yml` | `ubuntu-24.04-arm` | issue opened | AI triage via aptu action |
| `pr-review.yml` | `ubuntu-24.04-arm` | PR opened/synchronized | AI PR review via aptu action |
| `scorecard.yml` | `ubuntu-24.04-arm` | weekly | OpenSSF Scorecard |

## Contributing

We welcome contributions. Please read [CONTRIBUTING.md](CONTRIBUTING.md) for coding standards, commit conventions (Conventional Commits, GPG-signed and DCO signed-off), and PR guidelines.

## License

Apache-2.0. See [LICENSE](LICENSE).
