# Security Assurance

This document describes the security controls and supply-chain practices for aptu-app.

## Threat Model

aptu-app is a mobile client for Aptu that runs on Android devices. Key threat actors:

- **Malicious app distribution**: sideloaded APKs or compromised app store listings
- **Device compromise**: rooted/jailbroken devices with elevated privileges
- **Network interception**: man-in-the-middle attacks on API calls
- **Credential theft**: extraction of stored tokens from device storage
- **Prompt injection**: malicious input to AI providers via the app UI

## Trust Boundaries

1. **App sandbox** — Android enforces process isolation; aptu-app cannot access other apps' data
2. **Android Keystore** — Hardware-backed credential storage (if available); tokens never in plaintext
3. **Network boundary** — All API calls to GitHub and AI providers use HTTPS with certificate pinning (future)
4. **User input** — Untrusted; validated and sanitized before sending to AI providers

## Input Validation

- **Issue body**: capped at `max_issue_body_bytes` (32 KB) before sending to AI
- **PR diff**: capped at `max_diff_bytes` (128 KB) before sending to AI
- **Commit message**: capped at `max_commit_message_bytes` (4 KB) before sending to AI
- **UI forms**: validated client-side before submission

Exceeding these limits results in a user-facing error; no truncation or silent failure.

## Credential Storage

- **Android**: Tokens stored in Android Keystore via KVault; encrypted at rest
- **iOS**: Tokens stored in iOS Keychain (when iOS is re-enabled)
- **Never**: plaintext files, SharedPreferences, or unencrypted storage

## Supply Chain Security

### REUSE/SPDX Compliance

Every file has explicit license metadata (SPDX headers). Verified by `reuse.yml` CI workflow on every push/PR.

### SHA-pinned GitHub Actions

All `uses:` lines in workflows are pinned to commit SHA, not tags or branches. Renovate automates digest updates with `minimumReleaseAge: 3 days` to prevent same-day supply-chain attacks.

Example:
```yaml
- uses: actions/checkout@11bd71901afe44af187b393f46cea9edd785c69a  # v4.2.2
```

### Dependency Audits

- **Rust**: `cargo deny check advisories licenses` audits all Rust dependencies for CVEs and license compliance
- **Kotlin**: Gradle dependency scanning (via Android Gradle Plugin)
- **Renovate**: Automated updates with `minimumReleaseAge: 3 days` to allow time for vulnerability disclosure

### Secret Detection

- **gitleaks**: Scans commits for accidentally committed secrets (API keys, tokens, credentials)
- **GitHub push protection**: Blocks commits containing detected secrets
- **Test fixtures**: Intentional hardcoded secrets in `tests/security_fixtures/` are allowlisted in `.gitleaks.toml`

### Repository Security

- **Branch protection**: `main` requires signed commits and passing CI
- **Required status check**: `CI Result` is the sole required check; all workflows aggregate into this job
- **Code review**: All PRs reviewed by the maintainer before merge
- **Squash merge**: All PRs merged with `--squash` to maintain linear history

### OpenSSF Scorecard

Weekly automated security posture analysis via `scorecard.yml`. Tracks:

- Branch protection
- Code review enforcement
- Dependency pinning
- Signed commits
- Token permissions
- Vulnerability disclosure

## Incident Response

Security vulnerabilities are reported privately via GitHub's private vulnerability reporting feature or email security@aptu.dev.

Response SLA:

| Severity | Triage | Acknowledge | Fix Target | Disclosure |
|----------|--------|-------------|------------|------------|
| Critical | 24h    | 24h         | 14 days    | 90 days after fix |
| High     | 24h    | 48h         | 14 days    | 90 days after fix |
| Medium   | 48h    | 72h         | 30 days    | 90 days after fix |
| Low      | 72h    | 7 days      | 90 days    | Coordinated       |

Reporters are credited by their chosen name or pseudonym in release notes. Anonymous reports are always respected.

## Future Improvements

- **Certificate pinning**: Pin GitHub and AI provider certificates to prevent MITM attacks
- **Instrumented tests**: Security-focused test suite running on Android emulator in CI
- **Third-party audit**: Independent security audit of credential handling and FFI boundary
- **Fuzzing**: Fuzz-test the FFI boundary and input validation logic
