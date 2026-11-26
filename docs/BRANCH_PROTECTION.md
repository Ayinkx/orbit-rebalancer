# Branch Protection Rules & Required CI Checks

This document describes the branch protection rules enforced on the `main` branch, the CI checks that must pass before a pull request can be merged, and the expected merge workflow for contributors.

---

## Protected Branches

### `main`

The `main` branch is the production-ready release branch. All changes reach `main` through pull requests — direct pushes are not allowed.

| Rule                              | Setting  |
| --------------------------------- | -------- |
| Require pull request before merge | ✅ Yes   |
| Required approving reviews        | 1+       |
| Require review from Code Owners   | ✅ Yes   |
| Dismiss stale reviews on new push | ✅ Yes   |
| Require status checks to pass     | ✅ Yes   |
| Require branches to be up-to-date | ✅ Yes   |
| Require linear history            | ✅ Yes   |
| Include administrators            | ✅ Yes   |
| Allow force pushes                | ❌ No    |
| Allow deletions                   | ❌ No    |

### `develop` (if used)

The `develop` branch follows the same protection rules as `main`. Feature branches are merged into `develop` first, then promoted to `main` via a release PR.

---

## GitHub Actions workflows

The table lists the workflow files on `main`. Each workflow file defines its
exact events, branch filters, and path filters. Branch protection settings
determine which job names are required to merge a pull request.

| Workflow | Events | Purpose |
| --- | --- | --- |
| [Dependabot Auto-Merge](../.github/workflows/dependabot-auto-merge.yml) | Pull request | Processes eligible Dependabot updates |
| [Env Example Validation](../.github/workflows/env-example-validation.yml) | Pull request and push, with path filters | Checks environment examples against the source and docs |
| [Generated Artifact Guard](../.github/workflows/generated-artifact-guard.yml) | Pull request and push | Checks generated artifacts |
| [Merge PR linked to Stellar Wave issues](../.github/workflows/merge-open-prs.yml) | Pull request opened against `main` | Processes pull requests linked to eligible Stellar Wave issues |
| [Observability Config Lint](../.github/workflows/observability-lint.yml) | Pull request and push, with path filters | Validates observability configuration |
| [PR Lint](../.github/workflows/pr-lint.yml) | Pull request | Checks for an issue link or a rationale |
| [Release Please](../.github/workflows/release-please.yml) | Push to `main` | Maintains the release pull request |
| [SBOM Generation & Dependency Integrity](../.github/workflows/sbom.yml) | Pull requests to `main`, path-filtered pushes to `main`, and published releases | Checks dependencies and generates software bills of materials |
| [Secret Scan](../.github/workflows/secret-scan.yml) | Pull request and push | Scans for leaked secrets |
| [Terraform DR Plan Validation](../.github/workflows/terraform-dr.yml) | Pull request and push, with path filters | Validates disaster-recovery infrastructure configuration |

---

## What Contributors Should Know

### Before opening a PR

1. **Run tests locally** to catch failures early:
   ```bash
   cd backend && npm test && cd ../frontend && npm test
   ```

2. **Run the linter**:
   ```bash
   cd frontend && npm run lint
   cd ../backend && npm run lint
   ```

3. **Verify commit messages** follow Conventional Commits:
   ```bash
   scripts/check-commit-messages.sh
   ```

4. **Check env example sync** (if you changed environment variables):
   ```bash
   npm run validate:env-examples
   ```

5. **Check the audit baseline** (if you changed dependencies):
   ```bash
   npm run audit:policy
   ```

6. **Run the generated artifact guard** (if you changed OpenAPI sources):
   ```bash
   cd backend && npm run openapi:export && npm run api:validate
   ```

### After opening a PR

- All required checks appear in the **Checks** tab on the PR.
- If a check fails, click through to the workflow run for logs and error messages.
- Workflows with path filters run when the changed paths match the workflow configuration.
- Fix failures locally, push again, and the checks re-run automatically.

### Merge requirements

A PR is mergeable when **all** of the following are true:

1. ✅ All required status checks pass (green)
2. ✅ At least one approving review from a maintainer
3. ✅ The branch is up-to-date with `main`
4. ✅ No unresolved review conversations

### Merge strategy

This repository uses **squash merges** to maintain a clean, linear commit history on `main`. The squash commit message should follow Conventional Commits format.

---

## Common CI Failure Scenarios

| Failure                                      | Likely cause                                                       | Resolution                                                                                            |
| -------------------------------------------- | ------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------- |
| `guard-generated-artifacts` fails            | Committed `openapi.json` is stale                                  | Run `cd backend && npm run openapi:export` and commit the updated spec                                |
| `validate-env-examples` fails                | `.env.example` doesn't match source `process.env.*` references     | Run `npm run validate:env-examples` and add missing variables to `.env.example`                       |

---

## Configuring Branch Protection (Maintainers)

Branch protection rules are configured in **Settings → Branches → Branch protection rules** on GitHub.

### Recommended setup for `main`

1. Navigate to **Settings → Branches** in the repository.
2. Click **Add rule** (or edit the existing `main` rule).
3. Set **Branch name pattern** to `main`.
4. Enable:
   - ✅ **Require a pull request before merging** (at least 1 approval)
   - ✅ **Dismiss stale pull request approvals when new commits are pushed**
   - ✅ **Require status checks to pass before merging**
   - ✅ **Require branches to be up to date before merging**
   - ✅ **Require linear history**
   - ✅ **Do not allow bypassing the above settings** (include administrators)
5. Under **Status checks that are required**, select the always-running job names you intend to enforce.
6. Save the rule.

For workflows with path filters, check how skipped runs interact with required checks before adding a job to the rule.

### Adding a new required check

When adding a new CI workflow that should block merges:

1. Create the workflow YAML in `.github/workflows/`.
2. Ensure it triggers on `pull_request` (with or without `paths:` filters).
3. If it should be **always-required**, add its job name to the branch protection required checks list.
4. If it is **path-scoped**, do not add it to the required list — it will run and report status only when relevant files change.
5. Update the workflow table above.
6. Open a PR to validate the workflow runs correctly.

---

## Further Reading

- [Contributor Setup Guide](CONTRIBUTING.md) — Full local development setup
- [Maintainer Triage Guide](TRIAGE.md) — Issue and PR triage procedures
- [Operations Handbook](OPERATIONS.md) — Redis, workers, health checks
- [Release Checklist](RELEASE_CHECKLIST.md) — Steps for cutting a release
