@RTK.md

# Personal rules (all projects, every Codex/OpenCode session)

## Communication
- Respond to the user in RUSSIAN. Keep tool calls, code, and AGENTS.md files in English.
- Be concise, direct, and action-oriented. Do not stop at a plan when the requested work is authorized.
- Code comments, docstrings, and commit messages: match the language already used in the repository. Identifiers and API fields stay English.

## Model behavior
- User instructions take precedence over these defaults and any skill guidance.
- Infer reasonable scope from the request. Ask questions only when an answer materially changes the implementation or a destructive action needs confirmation.
- Keep working through implementation, verification, and documentation until the requested outcome is complete.
- State assumptions when requirements are ambiguous. Do not invent repository commands, paths, APIs, or model capabilities.

## Editing
- Make minimal diffs. Never reformat or refactor unrelated code.
- Structural code search/refactor: `ast-grep` instead of `grep`/`sed`. Plain `rg`/`grep` is fine for configs, YAML, Markdown, and text.

## Git
- Use Conventional Commits prefixes (`feat(scope): ...`, `fix(scope): ...`).
- Never add `Co-Authored-By` or agent-attribution lines to commits or pull requests.

## Safety
- Never auto-run heavy scripts, training, GPU jobs, large downloads, or multi-minute builds. Print the command for the user instead.
- After a failed command or test, find the root cause first. Never retry blindly.
- Never weaken the quality bar: no new `noqa`/`type: ignore`/`eslint-disable`/`ts-ignore`, no skipped or deleted tests, no lowered thresholds.

## Tool routing
- For codebase structure and relationships, use `codebase-memory-mcp` first when available.
- For complex multi-step reasoning, use Sequential Thinking MCP when available.
- For uncertain library or framework APIs, fetch current official documentation before coding.
- For browser behavior, use the configured browser-testing tool when available.

## Stack defaults (apply only if the project uses it)
- Python: use `uv` (`uv sync`, `uv run ...`), never bare `pip`/`python`. After Python edits, run the repository's formatter and linter.
- JS/TS: use the package manager matching the lockfile. After edits, run lint, format, typecheck, or build checks defined by the repository.
- If tests exist, run fast relevant tests after changes. Never auto-run GPU, end-to-end, or heavy tests.

## Workflow
- New feature or vague requirements: use `spec-driven-development`, then `planning-and-task-breakdown`.
- Implementation: use `incremental-implementation` and `test-driven-development` when behavior changes.
- Before merge: use `code-review-and-quality`. For security-sensitive changes, use `security-and-hardening`.
- Cleanup: use `code-simplification`. Release: use `shipping-and-launch`.
