# Contributing to aptu-app

We welcome contributions! This document covers the essentials.

## Quick Start

### Prerequisites

- **Android Studio** Ladybug or later
- **JDK 21** (set via `JAVA_HOME`)
- **Android SDK** with API 35
- **Rust 1.95.0** — automatically managed via `rust-toolchain.toml`
- **Just** (optional) — task runner

Install Just:
```bash
brew install just   # macOS
cargo install just  # Linux
```

### Setup

```bash
git clone https://github.com/clouatre-labs/aptu-app.git
cd aptu-app
```

### Build Commands

```bash
# Android app (debug)
cd AptuKMP && ./gradlew :androidApp:assembleDebug

# Android tests
cd AptuKMP && ./gradlew :shared:testDebugUnitTest :androidApp:testDebugUnitTest

# Rust FFI crate
cargo build

# Run all checks (if Just is installed)
just check
```

### Good First Issues

Look for issues labelled [`good-first-issue`](https://github.com/clouatre-labs/aptu-app/issues?q=is%3Aopen+label%3Agood-first-issue) or [`help-wanted`](https://github.com/clouatre-labs/aptu-app/issues?q=is%3Aopen+label%3Ahelp-wanted).

## Before Submitting

For Rust changes:
```bash
cargo fmt --check
cargo clippy -- -D warnings
cargo test
cargo deny check advisories licenses
```

For Kotlin/Gradle changes:
```bash
cd AptuKMP && ./gradlew :shared:testDebugUnitTest :androidApp:testDebugUnitTest
```

## Commit Message Format

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>
```

**Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`

**Scopes:** `kmp`, `ffi`, `android`, `ios`, `ci`, `deps`

Examples:
```bash
git commit -S --signoff -m "feat(kmp): add offline cache for issue list"
git commit -S --signoff -m "fix(ffi): handle null pointer in auth token retrieval"
git commit -S --signoff -m "ci: pin AGP to 8.5.2 for compileSdk=35 support"
```

## Developer Certificate of Origin (DCO)

All commits must be signed off:
```bash
git commit -S --signoff -m "Your commit message"
```

## Pull Request Checklist

- [ ] Tests pass
- [ ] No clippy warnings (Rust changes)
- [ ] Code formatted
- [ ] Commits GPG-signed and signed-off
- [ ] Clear PR description referencing the issue

## License

By contributing, you agree your contributions are licensed under [Apache-2.0](LICENSE).
