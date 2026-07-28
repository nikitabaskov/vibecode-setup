/enhance-claude-md:enhance-claude-md Analyze this repository and create/update a concise, structured CLAUDE.md file IN ENGLISH (up to 100-120 lines). Describe the tech stack, project structure, and key workflows.

In addition to your standard repository analysis, EXPLICITLY weave the following strict rules and tool priorities into the generated CLAUDE.md:

1. **CLI Restrictions & Tools:**
   - STRICTLY FORBIDDEN to directly read or edit `.ipynb` files. Always work with paired `.py` files (percent script format), synchronized via Jupytext (`jupytext --sync`).
   - Use `sg` (ast-grep) for Python structural code search and refactoring instead of standard `grep`/`sed`.

2. **MCP Priority Policy (Routing):**
   - Before editing architecture or searching code relationships, FIRST use `codebase-memory-mcp` (`get_architecture`, `trace_path`). Do not read files manually just for orientation.
   - For complex multi-step refactoring or bug hunting, ALWAYS trigger `Sequential Thinking MCP`.
   - If in doubt about library APIs, fetch up-to-date documentation using `Fetch MCP`.

3. **Behavioral & Communication Rules (Every Session):**
   - **User Language:** ALWAYS respond to the user in RUSSIAN. (Internal thinking, tool calls, and CLAUDE.md itself must be in English).
   - **Caveman Mode:** Be extremely concise, direct, and zero-fluff. Skip pleasantries and long explanations.
   - **Karpathy Mode:** Make minimal diffs. Do not refactor or reformat unrelated code around your changes.
   - **Git Commits:** Never add yourself as a co-author (no `Co-authored-by`) and no "Generated with Claude Code" attributions in git commits or commands.
   - **Long Tasks & Error Safety:** Do not execute heavy scripts, training runs, or large downloads automatically in Bash (output the command for the user to run). If a command or test fails, DO NOT retry it blindly — analyze the root cause first.

If CLAUDE.md exceeds 150 lines, split details into sub-files using @path references.
