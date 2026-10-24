#!/usr/bin/env bash
# Edit|Write hook for .py/.pyi files. Usage: ruff-format.sh pre|post
#   pre  (PreToolUse):  if the file is not ruff-formatted yet (legacy code),
#                       remember its current lint messages and skip formatting later.
#   post (PostToolUse): formatted file -> ruff check --fix + ruff format;
#                       legacy file    -> no rewrite, report only NEW lint errors.
# Silent on success; errors go to Claude via exit 2.
# F401 is skipped: an import added one edit before its usage must survive.
mode=${1:-post}
f=$(jq -r '.tool_input.file_path // empty')
case "$f" in *.py|*.pyi) ;; *) exit 0 ;; esac

# Prefer the project's pinned ruff (.venv), fall back to uvx.
ruff="uvx ruff"
d=$(dirname "$f")
while [ "$d" != "/" ]; do
  if [ -x "$d/.venv/bin/ruff" ]; then ruff="$d/.venv/bin/ruff"; break; fi
  d=$(dirname "$d")
done

state="${TMPDIR:-/tmp}/claude-ruff/$(printf '%s' "$f" | sha1sum | cut -c1-16)"

# Lint messages without positions, so line shifts don't count as new errors.
lint_messages() {
  $ruff check --extend-ignore F401 --output-format concise "$f" 2>/dev/null \
    | grep -E '^.+:[0-9]+:[0-9]+: ' | sed -E 's/^.+:[0-9]+:[0-9]+: //' | sort
}

if [ "$mode" = pre ]; then
  rm -f "$state"
  if [ -f "$f" ] && ! $ruff format --check --quiet "$f" >/dev/null 2>&1; then
    mkdir -p "$(dirname "$state")"
    lint_messages > "$state"
  fi
  exit 0
fi

[ -f "$f" ] || exit 0

if [ -f "$state" ]; then
  new=$(comm -13 "$state" <(lint_messages))
  rm -f "$state"
  if [ -n "$new" ]; then
    echo "New lint errors in $f (file is not ruff-formatted, so it was left as is):" >&2
    echo "$new" >&2
    exit 2
  fi
  exit 0
fi

out=$($ruff check --fix --quiet --extend-ignore F401 "$f" 2>&1); rc=$?
$ruff format --quiet "$f" >/dev/null 2>&1
if [ $rc -ne 0 ]; then echo "$out" >&2; exit 2; fi
exit 0
