---
name: agent-md-init
description: Create or update a project AGENTS.md with verified repository-specific guidance for Cursor. Use when starting work in an unfamiliar repository, when AGENTS.md is missing or stale, or when the user asks for /agent-md-init.
---

# Initialize AGENTS.md (Cursor)

Create or update the repository's root `AGENTS.md` in place. This skill is for Cursor Agent (Chat, Plan, Ask, CLI). Do not create `CLAUDE.md`, `.cursorrules`, or `.cursor/rules/*.mdc` unless the user explicitly asks.

## Rules

- Read existing `AGENTS.md` files first. Preserve still-correct project guidance.
- If several project instruction files exist, keep nested `AGENTS.md` files only when their directory has a distinct stack. Merge stale or duplicate root guidance into the root file; do not delete files without a clear reason.
- Write the file in English. Keep it concise: target 40–80 lines, never exceed 120 lines without moving detail to a referenced file.
- Detect before writing. Inspect languages, package managers from lockfiles, frameworks, test runners, linters, formatters, CI, Docker, databases, and migrations.
- Verify every command and path against the repository. Never invent commands.
- Project instructions describe repository facts. Keep personal communication, model behavior, and global tool preferences out of this file. Those live in Cursor User Rules (`Customize → Rules`) and `~/.cursor/rules/`.

## Required sections

1. **What this is** — one paragraph.
2. **Tech stack** — compact table with layer and stack.
3. **Structure** — key directories, entry points, and the main data flow.
4. **Workflows** — development, build, test, lint/format, migrations, Docker, and CI. Give the exact command to run a single test. Mark slow, GPU, and end-to-end commands `never auto-run`.
5. **Hard restrictions** — generated, vendored, legacy, data, model, secret, and environment files that must not be changed or committed.
6. **Do not read** — heavy dirs and files (data, outputs, weights, notebook outputs, generated code, lockfiles).
7. **Domain rules** — units, coordinate systems, privacy rules, and easy-to-break invariants.
8. **Definition of Done** — actual repository checks: lint, types, fast tests, build, and no new suppressions. Link `CONSTRAINTS.md` when it exists.

If the file would exceed 80 lines, move details into sub-files and reference them by plain path (for example `docs/arch.md`). Do not use `@path` for large docs: Agent may treat that as a must-read.

## Verification

- Re-read the resulting `AGENTS.md`.
- Run only fast, relevant checks needed to verify commands and repository facts.
- Report missing tools or unverified checks instead of claiming success.
- Tell the user the path written and that a new Cursor Agent chat picks the file up immediately.
