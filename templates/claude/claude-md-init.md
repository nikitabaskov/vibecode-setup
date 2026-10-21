---
description: Create or update a project CLAUDE.md (project-specific only; personal rules live in ~/.claude/CLAUDE.md)
---

Invoke the enhance-claude-md:enhance-claude-md skill with this brief.

Analyze this repository and create or UPDATE its CLAUDE.md IN PLACE. Never create a duplicate; if several CLAUDE.md files exist, merge them into the root one and delete stale ones. Write IN ENGLISH, 80-120 lines, concise. Keep still-correct existing content, drop anything stale.

Personal rules (language, caveman, Karpathy, commits, tool routing, skill routing, uv/ruff defaults) already live in ~/.claude/CLAUDE.md. Do NOT repeat them. Include only what is specific to this project, plus overrides of the global rules where this repo differs (for example a fixed comment language, or a different package manager).

Step 1: detect before writing. Languages, package managers (by lockfiles), frameworks, test runners, linters, CI, Docker, DB/migrations. Verify EVERY command and path against the repo before writing it; never invent commands.

Step 2: write these sections.
1. What this is: one paragraph.
2. Tech stack: compact table (layer, stack).
3. Structure: short tree of key directories, one line each, plus the main data flow.
4. Workflows: dev run, build, test, lint/format, migrations, Docker, CI. Only real verified commands. List slow/heavy/gpu/e2e test markers and mark them "never auto-run".
5. Hard restrictions: generated/vendored/legacy dirs not to touch or lint-sweep; files never to commit (data, models, secrets, .env); anything else the repo marks off-limits.
6. Domain rules: units, coordinate systems, data privacy, invariants that are easy to get wrong.
7. Definition of Done: one line listing the repo's real checks (lint clean, types clean, fast tests green, build passes, no suppressions added). Link `@CONSTRAINTS.md` if it exists.

If the file would exceed 150 lines, move details into sub-files and reference them via @path.
