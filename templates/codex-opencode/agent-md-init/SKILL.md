---
name: agent-md-init
description: Create or update a project AGENTS.md with verified repository-specific guidance. Use when starting work in an unfamiliar repository or when its instructions are missing or stale.
---

# Initialize AGENTS.md

Create or update the repository's root `AGENTS.md` in place. This skill is for Codex and OpenCode. Do not create `CLAUDE.md`, use Claude plugins, or add agent-specific slash commands.

## Rules

- Read existing `AGENTS.md` files first. Preserve still-correct project guidance.
- If several project instruction files exist, keep nested files only when their scope is intentional. Merge stale or duplicate root guidance into the root file; do not delete files without a clear reason.
- Write the file in English. Keep it concise: target 80-120 lines and never exceed 150 lines without moving detail to a referenced file.
- Detect before writing. Inspect languages, package managers from lockfiles, frameworks, test runners, linters, formatters, CI, Docker, databases, and migrations.
- Verify every command and path against the repository. Never invent commands.
- Project instructions describe repository facts. Keep personal communication, model behavior, and global tool preferences in the user's global `AGENTS.md`, not in each project.

## Required sections

1. **What this is** — one paragraph.
2. **Tech stack** — compact table with layer and stack.
3. **Structure** — key directories and the main data flow.
4. **Workflows** — development, build, test, lint/format, migrations, Docker, and CI. Mark slow, GPU, and end-to-end commands `never auto-run`.
5. **Hard restrictions** — generated, vendored, legacy, data, model, secret, and environment files that must not be changed or committed.
6. **Domain rules** — units, coordinate systems, privacy rules, and easy-to-break invariants.
7. **Definition of Done** — actual repository checks: lint, types, fast tests, build, and no new suppressions. Link `@CONSTRAINTS.md` when it exists.

## Verification

- Re-read the resulting `AGENTS.md`.
- Run only fast, relevant checks needed to verify commands and repository facts.
- Report missing tools or unverified checks instead of claiming success.
