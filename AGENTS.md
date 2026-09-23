# aptu-app Agent Instructions

Mobile client for [Aptu](https://github.com/clouatre-labs/aptu): Kotlin Multiplatform Android/iOS app with a UniFFI Rust bridge exposing `aptu-core`.

## Stack

Rust 2024 + UniFFI + Gobley | Kotlin Multiplatform + Compose Multiplatform | Gradle 8 + AGP

## Workspace Layout

```text
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

## CI Runners

All Linux CI jobs run on ARM64 GitHub-hosted runners except `android-kmp.yml`, which requires x86_64 NDK host binaries (android/ndk#1752). `ios-kmp.yml` runs one ARM64 Linux job alongside its `macos-15` job (Apple Silicon, parked).

| Workflow | Runner | Trigger |
|---|---|---|
| `ci.yml` | ARM64 Linux | push/PR on `crates/**`, `Cargo.*` |
| `android-kmp.yml` | x86_64 Linux (NDK constraint) | push/PR on `AptuKMP/**`, `crates/aptu-ffi/**` |
| `ios-kmp.yml` | `macos-15` + ARM64 Linux | `workflow_dispatch` only (parked) |
| `reuse.yml` | ARM64 Linux | push/PR on source files |
| `scorecard.yml` | ARM64 Linux | weekly schedule |

## Key Conventions

- Conventional Commits; GPG + DCO sign every commit (`git commit -S --signoff`)
- Apache-2.0; REUSE-compliant; no inline SPDX headers on `.md` files (catch-all in `REUSE.toml` covers them)
- `aptu-core` is a git dep pinned to a SHA in `[workspace.dependencies]` in `Cargo.toml`; switch to crates.io once published; to update: change `rev` and run `cargo update`
- UniFFI build script lives in `crates/aptu-ffi/build.rs`; Gobley handles Kotlin binding generation
- iOS target is parked; `ios-kmp.yml` is `workflow_dispatch` only -- do not re-enable without explicit issue

## Dependency on clouatre-labs/aptu

All AI triage logic, GitHub API client, and core types live in `aptu-core` (clouatre-labs/aptu). This repo only contains the mobile surface and the UniFFI bridge.

## Do Not

- Add yourself as co-author in git commits
- Use `gh release create` to tag releases; create a GPG-signed annotated tag and push it to trigger the release workflow
- Add dependencies without justification in the PR description
- Use `unsafe` code
- Implement features not specified in the assigned issue
- Modify files outside the scope of the assigned issue
- Assume any API exists based on training data; verify against installed crate versions
