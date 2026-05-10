# Security Policy

## Reporting

Please report issues privately via GitHub's private vulnerability reporting feature or email security@aptu.dev.

Do not open public issues for sensitive matters.

### Response SLA

This is a solo-maintained project (see [GOVERNANCE.md](GOVERNANCE.md)). The targets below are best-effort commitments, not contractual guarantees.

| Severity | Triage | Acknowledge | Fix Target | Disclosure |
|----------|--------|-------------|------------|------------|
| Critical | 24h    | 24h         | 14 days    | 90 days after fix |
| High     | 24h    | 48h         | 14 days    | 90 days after fix |
| Medium   | 48h    | 72h         | 30 days    | 90 days after fix |
| Low      | 72h    | 7 days      | 90 days    | Coordinated       |

## Credential Storage

Aptu stores tokens in the Android Keystore (via KVault) and iOS Keychain on mobile. Tokens are never stored in plaintext.

## Best Practices

- Review AI-generated content before posting
- Keep the app updated

## Supply Chain Security

### REUSE/SPDX

Every file has explicit license metadata, verified by the `reuse.yml` CI workflow.

### SHA-pinned Actions

All GitHub Actions are pinned to commit SHA. Renovate automates digest updates with `minimumReleaseAge: 3 days` to prevent day-zero supply-chain attacks.

### Repository Security

- **Secret scanning** - Detects accidentally committed credentials (gitleaks in CI)
- **Push protection** - Blocks commits containing secrets
- **Branch Protection** - Signed commits required; `CI Result` is the sole required status check

### Reporter Credit

Security reporters are acknowledged by their chosen name or pseudonym in the release notes for the version that includes the fix. Reporters who wish to remain anonymous are always respected.
