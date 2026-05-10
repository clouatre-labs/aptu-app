# Roadmap

_Near-Term: Q2–Q3 2026 | Medium-Term: Q4 2026–Q1 2027 | Long-Term: 2027+_

Mobile roadmap for aptu-app. The core CLI and AI triage roadmap lives in [clouatre-labs/aptu](https://github.com/clouatre-labs/aptu/blob/main/docs/ROADMAP.md).

## Near-Term (next 3-6 months)

- **Contribution history view** (#8): display the user's local triage and review history in the app
- **API key management UI** (#9): settings screen for managing provider API keys securely via Android Keystore
- **Local caching for performance** (#10): SQLite-backed offline cache for issue lists and triage results
- **AGP upgrade** (#11): bump Android Gradle Plugin past 8.5.2 to support `compileSdk=35` natively
- **Switch aptu-core to crates.io**: replace git dep with published crate version once `aptu-core` is released

## Medium-Term (6-18 months)

- **KMP PR review**: expose `aptu-core::review_pr` via FFI; add PR review screen to the Android app
- **Repo filter FFI** (#6): pass repository filter through Rust FFI to Kotlin layer
- **PR review fetch and analyze** (#7): expose full PR review pipeline via FFI
- **Instrumented tests**: Android instrumented test suite running on emulator in CI
- **iOS re-enable**: re-enable iOS KMP build once Android app is stable and iOS Compose Multiplatform matures

## Long-Term (2027+)

- **iOS App Store release**: full iOS support with App Store distribution
- **Independent security audit**: third-party audit of the credential handling and FFI boundary

## Not Planned

- A hosted backend or SaaS offering
- Web UI (belongs in the `aptu` repo via the MCP server)
- Automatic merge or code modification; aptu-app is read/triage only
