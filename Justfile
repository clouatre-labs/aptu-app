# SPDX-FileCopyrightText: 2026 Aptu Contributors
# SPDX-License-Identifier: Apache-2.0

# List available recipes
default:
    @just --list

# Run all checks (format, lint, test)
check: fmt lint test reuse

# --- Rust (crates/aptu-ffi) ---

# Build Rust FFI crate
build:
    cargo build

# Run Rust tests
test:
    cargo test --workspace

# Check Rust formatting
fmt:
    cargo fmt --check

# Fix Rust formatting
fmt-fix:
    cargo fmt

# Run Clippy linter
lint:
    cargo clippy --workspace -- -D warnings

# Fix Clippy suggestions
lint-fix:
    cargo clippy --workspace --fix --allow-dirty

# Run cargo-deny audit
deny:
    cargo deny check advisories licenses

# Check REUSE compliance
reuse:
    reuse lint

# --- Android (AptuKMP) ---

# Build Android debug APK
android-build:
    cd AptuKMP && ./gradlew :androidApp:assembleDebug

# Run Android unit tests
android-test:
    cd AptuKMP && ./gradlew :shared:testDebugUnitTest :androidApp:testDebugUnitTest

# Build shared KMP module
kmp-build:
    cd AptuKMP && ./gradlew :shared:assembleDebug

# Clean all build artifacts
clean:
    cargo clean
    cd AptuKMP && ./gradlew clean
