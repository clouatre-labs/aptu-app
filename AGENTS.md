# aptu-app Agent Instructions

Mobile client for [Aptu](https://github.com/clouatre-labs/aptu): Kotlin Multiplatform Android/iOS app with a UniFFI Rust bridge exposing `aptu-core`.

## Stack

Rust 2024 + UniFFI + Gobley | Kotlin Multiplatform + Compose Multiplatform | Gradle 8 + AGP

## Workspace Layout

```
aptu-app/
├── AptuKMP/              # Kotlin Multiplatform application
│   ├── androidApp/       # Android entry point (Compose Multiplatform)
│   ├── iosApp/           # iOS entry point (SwiftUI host -- parked)
│   └── shared/           # Shared KMP module: business logic, UI, ViewModels
└── crates/
    └── aptu-ffi/         # UniFFI Rust bridge (exposes aptu-core to Kotlin)
```

## Commands

```bash
# Rust FFI
cargo build
cargo test --workspace
cargo clippy --workspace -- -D warnings
cargo fmt --check
cargo deny check advisories licenses

# Android (from AptuKMP/)
./gradlew :shared:assembleDebug :androidApp:assembleDebug
./gradlew :shared:testDebugUnitTest :androidApp:testDebugUnitTest
```

## Key Conventions

- Conventional Commits; GPG + DCO sign every commit (`git commit -S --signoff`)
- Apache-2.0; REUSE-compliant; SPDX headers on every source file
- `aptu-core` is a git dep pinned to a SHA in `Cargo.toml`; switch to crates.io once published
- UniFFI build script lives in `crates/aptu-ffi/build.rs`; Gobley handles Kotlin binding generation
- iOS target is parked; `ios-kmp.yml` is `workflow_dispatch` only
- ARM runners (`ubuntu-24.04-arm`) for all Linux CI except `android-kmp.yml`, which requires x86_64 NDK host binaries (see android/ndk#1752)

## CI Workflows

| Workflow | Runner | Trigger |
|---|---|---|
| `ci.yml` | `ubuntu-24.04-arm` | push/PR on `crates/**`, `Cargo.*` |
| `android-kmp.yml` | `ubuntu-24.04` (x86_64, NDK constraint) | push/PR on `AptuKMP/**`, `crates/aptu-ffi/**` |
| `ios-kmp.yml` | `macos-15` | `workflow_dispatch` only (parked) |
| `reuse.yml` | `ubuntu-24.04-arm` | push/PR on source files |
| `issue-triage.yml` | `ubuntu-24.04-arm` | issue opened |
| `pr-review.yml` | `ubuntu-24.04-arm` | PR opened/synchronized |
| `scorecard.yml` | `ubuntu-24.04-arm` | weekly schedule |

## Dependency on clouatre-labs/aptu

All AI triage logic, GitHub API client, and core types live in `aptu-core` (clouatre-labs/aptu). This repo only contains the mobile surface and the UniFFI bridge. Pin updates: change `rev` in `[workspace.dependencies]` in `Cargo.toml` and run `cargo update`.
