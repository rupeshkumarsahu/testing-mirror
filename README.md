# test-argocd
### added general too

## Detect Secrets Enforcement

This repository uses [`detect-secrets`](https://github.com/IBM/detect-secrets-stream) to prevent committing sensitive information like API keys, tokens, and passwords.

### How It Works

Secrets are tracked using a `.secrets.baseline` file. This file contains a hash of detected secret patterns and is version-controlled.

On every pull request, GitHub Actions will:
- Scan the codebase using the committed baseline.
- Fail the build if new untracked secrets are found.

### Update the Baseline

If your PR is failing due to newly detected secrets (false positives or intentional additions), follow the steps below to update the baseline:

#### One-Command Update

Use the provided `Makefile` to automatically install and run `detect-secrets`, then clean up:

```bash
make update-secrets