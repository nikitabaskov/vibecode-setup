---
description: Create or update a project CLAUDE.md (project-specific only; personal rules live in ~/.claude/CLAUDE.md)
---

Analyze this repository and create or UPDATE its CLAUDE.md IN PLACE. Never create a duplicate; if several CLAUDE.md files exist, merge them into the root one and delete stale ones. Write IN ENGLISH, 40-80 lines, concise: the file is loaded into every request. Keep still-correct existing content, drop anything stale.

Personal rules (language, Karpathy, commits, tool routing, context economy, uv/ruff defaults, CLAUDE.md upkeep) already live in ~/.claude/CLAUDE.md. Do NOT repeat them. Include only what is specific to this project, plus overrides of the global rules where this repo differs (for example a fixed comment language, or a different package manager).

Step 1: detect before writing. Languages, package managers (by lockfiles), frameworks, test runners, linters, CI, Docker, DB/migrations. Verify EVERY command and path against the repo before writing it; never invent commands.

Step 2: write these sections.
1. What this is: one paragraph.
2. Tech stack: compact table (layer, stack).
3. Structure and context map: short tree of key directories, one line each, plus the main data flow. Name the entry points, key modules, and configs so a new session finds code without exploring.
4. Workflows: dev run, build, test, lint/format, migrations, Docker, CI. Only real verified commands. Give the exact syntax to run a single test case with this repo's runner (e.g. `uv run pytest path/test_x.py::test_name`). Note pre-commit / husky / lint-staged hooks if present. List the required `.env.example` key names (never values) and local setup steps needed for tests to run. List slow/heavy/gpu/e2e test markers and mark them "never auto-run".
5. Hard restrictions: generated/vendored/legacy dirs not to touch or lint-sweep; files never to commit (data, models, secrets, .env); anything else the repo marks off-limits.
6. Do not read: heavy dirs and files (data, outputs, model weights, notebook outputs, generated code, lockfiles). Propose matching `permissions.deny` Read rules for the project `.claude/settings.json` to the user, e.g. `"deny": ["Read(./data/**)"]`; don't write them silently.
7. Domain rules: units, coordinate systems, data privacy, invariants that are easy to get wrong.
8. Definition of Done: one line listing the repo's real checks (lint clean, types clean, fast tests green, build passes, no suppressions added). Link `@CONSTRAINTS.md` if it exists.

If the file would exceed 80 lines, move details into sub-files and reference them by plain path (e.g. "details: `docs/arch.md`"), not `@path`: an `@path` import is loaded into every request, a plain path is read only when needed.
