# 🛠️ Руководство по agent-skills (`addyosmani/agent-skills`)

Набор из 25 skills и 9 slash-команд, которые проводят агента через жизненный цикл разработки: спецификация → план → реализация → тесты → ревью → релиз. Идея: вместо хаотичного «вайб-кодинга» агент идёт по проверяемым шагам и не снижает планку качества.

## Установка

| Среда | Команда |
| --- | --- |
| Все три среды (skills) | `npx skills@latest add addyosmani/agent-skills --global --agent claude-code codex opencode --skill '*' --yes` |
| Claude Code (slash-команды и персоны) | `cp templates/claude/commands/*.md ~/.claude/commands/` и `cp templates/claude/personas/*.md ~/.claude/personas/` |

> `npx skills` ставит только skills. Slash-команды (`/spec`, `/plan`…) и персоны для `/ship` (`code-reviewer`, `security-auditor`, `test-engineer`) лежат в [templates/claude/](templates/claude/). Персоны хранятся вне `~/.claude/agents/`, поэтому не занимают контекст, пока не запущен `/ship`.

После установки перезапустите агента: skills и команды подхватываются только при старте.

## Slash-команды (Claude Code)

| Команда | Когда |
| --- | --- |
| `/spec` | Новая фича, требования мутные. Пишет спецификацию до кода |
| `/plan` | Спека есть. Режет работу на задачи с критериями приёмки |
| `/build` | Реализует задачи по одной: код, тест, проверка, коммит. `/build auto` проходит весь план |
| `/test` | TDD. Для бага сначала падающий тест, доказывающий его (Prove-It) |
| `/review` | Ревью по пяти осям: корректность, читаемость, архитектура, безопасность, производительность |
| `/code-simplify` | Код работает, но запутан |
| `/ship` | Чеклист перед релизом, параллельный опрос трёх персон, решение go/no-go |
| `/constraints` | Один раз на проект: записывает планку качества в `CONSTRAINTS.md` и следит, чтобы агент её не снижал |

## Skills, которые подхватываются сами

В Claude Code включены: `debugging-and-error-recovery`, `investigate-first`, `security-and-hardening` (auth, ввод), `migration` (схемы и данные), `performance-optimization`, `documentation-and-adrs`, `doubt-driven-development` (рискованные изменения), а также skills, на которые опираются команды: `spec-driven-development`, `planning-and-task-breakdown`, `incremental-implementation`, `test-driven-development`, `code-review-and-quality`, `code-simplification`, `constraint-driven-development`, `shipping-and-launch`. Остальные выключены через `skillOverrides` в [templates/claude/settings.json](templates/claude/settings.json): за месяц они не использовались ни разу.

В Codex и OpenCode вызывайте skills по имени (`$имя` или «Use the … skill»).

## Какой инструмент выбрать

- **Ревью:** `/code-review` (встроенный) ищет баги в диффе; `/review` смотрит архитектуру и читаемость; `/security-review` (встроенный) для auth, загрузок, ввода.
- **Упрощение:** `/code-simplify` упрощает существующий код.
- **Баг с неясной причиной:** сначала `investigate-first` или `debugging-and-error-recovery`.
- **Качество:** `/constraints` один раз, дальше ссылка `@CONSTRAINTS.md` в `CLAUDE.md`.

## Типовой цикл

```text
/spec → /plan → /build → /test → /code-review → /review → /ship
```

Личные правила зависят от среды: Claude Code использует `~/.claude/CLAUDE.md`, Codex — `~/.codex/AGENTS.md`, OpenCode — `~/.config/opencode/AGENTS.md`, Cursor — User Rules и `~/.cursor/rules/personal.mdc`. Шаблоны: [Claude](templates/claude/), [Codex/OpenCode](templates/codex-opencode/), [Cursor](templates/cursor/).
