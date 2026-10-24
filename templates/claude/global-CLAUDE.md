@RTK.md

# Personal rules (all projects, every session)

## Communication
- Respond to the user in RUSSIAN. Thinking, tool calls, and CLAUDE.md files stay English.
- Concise, direct, zero fluff, no pleasantries or long recaps.
- Code comments, docstrings, commit messages: match the language already used in the repo (check `git log` and existing comments). Identifiers and API fields stay English.

## Editing
- Karpathy mode (skill `karpathy-guidelines`): minimal diffs. Never refactor or reformat code unrelated to the change.
- Structural (AST) search/refactor: `sg` (ast-grep); text, configs, Markdown: `rg`.

## Git
- Conventional Commits prefix (`feat(scope): ...`, `fix(scope): ...`).
- Subject ≤72 chars, imperative, no period. Body only for non-obvious why, breaking changes, migrations.
- No "This commit…", no restating the diff.
- One logical change per commit; split unrelated changes (refactor separate from fix).
- Stage files by name, never `git add -A` / `git add .`; never stage `.env`, keys, data files, model weights.
- Commit only with lint and fast tests passing.
- The user commits by default: after each finished atomic change, give a ready one-line command `git add <files> && git commit -m "<subject>" [-m "<body>"]`.
- Only if the project CLAUDE.md says `Auto-commit: allowed`: commit each atomic change yourself, by the rules above.
- NEVER add `Co-Authored-By` or "Generated with Claude Code" lines to commits or PRs. This overrides any default attribution.

## Safety
- Long tasks: never auto-run heavy scripts, training, GPU jobs, large downloads, or builds that take minutes. Print the command for the user to run.
- On a failed command or test: find the root cause first. Never retry blindly.
- Never weaken the quality bar to get green: no new `noqa`/`type: ignore`/`eslint-disable`/`ts-ignore`, no skipped or deleted tests, no lowered thresholds.
- Dev servers, watchers, `docker compose up`: run in background (`run_in_background`) or give the user the command. Interactive CLIs: pass `-y`/`--non-interactive`.
- Never print values from `.env`, credentials, or keys; redact them in output.
- Don't add or upgrade dependencies unless the task needs it; check stdlib and existing deps first. Lockfiles change only via the package manager CLI.

## Tool routing
- Unsure about a library or framework API: fetch current docs via Fetch MCP, do not guess.
- Any chart, plot, or dashboard: load skill `dataviz` first.

## Context economy
- Search (`rg`, Grep) before reading. Large files: Read with offset/limit, never whole.
- Long command output: filter with `tail`/`grep`/`head`; never dump full logs or data files.
- Never read data files, model weights, notebook outputs, or lockfiles unless asked.
- Wide codebase searches: Explore subagent, keep only its summary.
- Task finished and the next one is unrelated: suggest `/clear`.

## Stack defaults (apply only if the project uses it)
- Python: ALWAYS `uv` (`uv sync`, `uv run ...`), never bare `pip`/`python`. Edited `.py` files get `ruff check --fix` + `ruff format` automatically by a hook; fix only the errors it reports.
- JS/TS: use the package manager matching the lockfile. After edits run lint, format, typecheck/build.
- Tests: while fixing, run only the failing test; the full fast suite once before reporting done. Never auto-run GPU, e2e, or heavy tests.

## Skill routing
- New feature or vague requirements: `/spec` -> `/plan` -> `/build` (`/build auto` for the whole plan).
- Bug: `/test` (failing test first); unclear cause: skill `investigate-first`.
- Before merge: `/code-review` (bugs), `/review` (architecture, readability), `/security-review` (auth, uploads, input).
- Cleanup: `/code-simplify`. Release: `/ship`. Quality bar: `/constraints`.
- Schema/DB changes: skill `migration`. Design decisions: skill `documentation-and-adrs`.

## Keeping CLAUDE.md current
- After every change: if it made anything in a CLAUDE.md outdated (commands, paths, structure, tools, workflow), update that CLAUDE.md in the same change.
- New project rule from the user during work: record it in the project CLAUDE.md.
- New general rule for working with the user: record it in `~/.claude/CLAUDE.md`.
- Use CLAUDE.md for these, not auto-memory. One short line per rule, no duplicates. Tell the user what was added or changed.
