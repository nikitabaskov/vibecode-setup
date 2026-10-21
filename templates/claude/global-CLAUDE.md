@RTK.md

# Personal rules (all projects, every session)

## Communication
- Respond to the user in RUSSIAN. Thinking, tool calls, and CLAUDE.md files stay English.
- Caveman mode (plugin; `/caveman lite|full|ultra`): concise, direct, zero fluff, no pleasantries or long recaps.
- Code comments, docstrings, commit messages: match the language already used in the repo (check `git log` and existing comments). Identifiers and API fields stay English.

## Editing
- Karpathy mode (skill `karpathy-guidelines`): minimal diffs. Never refactor or reformat code unrelated to the change.
- Structural code search/refactor: `sg` (ast-grep) instead of grep/sed. Plain `rg`/`grep` is fine for configs, YAML, Markdown, text.

## Git
- Conventional Commits prefix (`feat(scope): ...`, `fix(scope): ...`).
- NEVER add `Co-Authored-By` or "Generated with Claude Code" lines to commits or PRs. This overrides any default attribution.

## Safety
- Long tasks: never auto-run heavy scripts, training, GPU jobs, large downloads, or builds that take minutes. Print the command for the user to run.
- On a failed command or test: find the root cause first. Never retry blindly.
- Never weaken the quality bar to get green: no new `noqa`/`type: ignore`/`eslint-disable`/`ts-ignore`, no skipped or deleted tests, no lowered thresholds.

## Tool routing
- Orientation and code relationships: `codebase-memory-mcp` FIRST (`get_architecture`, `trace_path`, `search_graph`, `get_code_snippet`). Do not read files just to orient.
- Complex multi-step refactoring or bug hunting: ALWAYS Sequential Thinking MCP.
- Unsure about a library or framework API: fetch current docs via Fetch MCP, do not guess.
- Browser/UI behaviour check: Playwright MCP.

## Stack defaults (apply only if the project uses it)
- Python: ALWAYS `uv` (`uv sync`, `uv run ...`), never bare `pip`/`python`. After ANY Python edit: `ruff check --fix . && ruff format .`.
- JS/TS: use the package manager matching the lockfile. After edits run lint, format, typecheck/build.
- If tests exist, run the fast ones after changes. Never auto-run GPU, e2e, or heavy tests.

## Skill routing
- New feature or vague requirements: `/spec` -> `/plan` -> `/build` (`/build auto` for the whole plan).
- Bug: `/test` (failing test first); unclear cause: skill `investigate-first`.
- Before merge: `/code-review` (bugs), `/review` (architecture, readability), `/security-review` (auth, uploads, input).
- Cleanup: `/code-simplify`. Release: `/ship`. Frontend perf: `/webperf`. Quality bar: `/constraints`.
- Schema/DB changes: skill `migration`. Design decisions: skill `documentation-and-adrs`.
