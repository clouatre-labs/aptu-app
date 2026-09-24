# Repository Standards

Living reference mapping every CI workflow and tooling choice to its purpose and rationale.

---

## Workflow Artifact Map

| File | Trigger | Purpose | Rationale |
| ------ | --------- | --------- | --------- |
| `.github/workflows/android-kmp.yml` | push/PR (`AptuKMP/**`, `crates/aptu-ffi/**`) | Build and test Android KMP app and Rust FFI | Catches UniFFI binding regressions before merge |
| `.github/workflows/ios-kmp.yml` | `workflow_dispatch` only (parked) | iOS KMP build | iOS is parked until Android is stable |
| `.github/workflows/ci.yml` | push/PR on `main` (`crates/**`, `Cargo.*`, `ci.yml`) | Rust FFI build, test, lint, cargo-deny | Fast feedback on Rust changes |
| `.github/workflows/reuse.yml` | push/PR | REUSE SPDX compliance check | Apache-2.0 attribution is machine-verifiable |
| `.github/workflows/scorecard.yml` | schedule weekly | OpenSSF Scorecard security posture | Tracks supply-chain security best practices |
| `.github/workflows/aptu-triage.yml` | `repository_dispatch: types: [aptu-triage]` (dispatched by aptu GitHub App) | Auto-triage new issues via `clouatre-labs/aptu-github-app/.github/workflows/issue-triage.yml@d341c5f20e31b570db8a10136d56ca63af6ded7b # v0.1.8` | GitHub App-driven dispatch (installation tokens, AI provider/model selection) reduces maintainer triage overhead |
| `.github/workflows/aptu-review.yml` | `repository_dispatch: types: [aptu-review]` (dispatched by aptu GitHub App) | Review PRs via `clouatre-labs/aptu-github-app/.github/workflows/pr-review.yml@d341c5f20e31b570db8a10136d56ca63af6ded7b # v0.1.8` | GitHub App-driven dispatch (installation tokens, AI provider/model selection); review only — labeling lives in the external repo |
| `.github/workflows/aptu-scan-security.yml` | `repository_dispatch: types: [aptu-scan-security]` (dispatched by aptu GitHub App) | Secret scanning via `clouatre-labs/aptu-github-app/.github/workflows/scan-security.yml@v0.1.8` with `security-events: write` | SARIF upload to code scanning |

---

## Required Status Checks

`CI Result` is the sole required status check in the branch ruleset. Each workflow has a `ci-result` job that aggregates its jobs — only `ci-result` is registered in the ruleset.

---

## Tooling

| Tool | Command | Purpose |
| ------ | --------- | --------- |
| `cargo clippy` | `cargo clippy --workspace -- -D warnings` | Lint; all warnings are errors in CI |
| `cargo fmt` | `cargo fmt --check` | Format enforcement |
| `cargo deny` | `cargo deny check advisories licenses` | Dependency audit (CVEs and license policy) |
| `reuse` | `reuse lint` | SPDX header compliance |
| secret scanning | via `aptu-scan-security.yml` (aptu-github-app scan-security workflow) | Secret detection |

---

## Security Controls

| Control | Implementation |
| ------- | ----------- |
| SHA-pinned Actions | All `uses:` lines pinned to commit SHA |
| Renovate | Automated dependency updates; `minimumReleaseAge: 3 days` |
| REUSE/SPDX | Every file has license metadata; checked in `reuse.yml` |
| Least-privilege permissions | Least-privilege top-level permissions (`{}` or `contents: read`) with per-job scopes |
| OpenSSF Scorecard | Weekly analysis in `scorecard.yml` |
| cargo-deny | CVE and license audit for Rust dependencies |
| Secret scanning | Delegated to clouatre-labs/aptu-github-app scan-security workflow (v0.1.8) |

---

## Dependency Management

Renovate manages all dependency updates. GitHub Actions SHAs and Rust crates are updated automatically. `minimumReleaseAge: 3 days` prevents same-day merges of newly published packages.

---

## Versioning

Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/). Release tags use `vMAJOR.MINOR.PATCH` and must be GPG-signed annotated tags.
