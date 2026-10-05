# 🛠️ Руководство по agent-skills (`addyosmani/agent-skills`)

Набор из 25 skills и 9 slash-команд, которые проводят агента через жизненный цикл разработки: спецификация → план → реализация → тесты → ревью → релиз. Идея: вместо хаотичного «вайб-кодинга» агент идёт по проверяемым шагам и не снижает планку качества.

## Установка

| Среда | Команда |
| --- | --- |
| Claude Code (skills + команды + субагенты) | `/plugin marketplace add addyosmani/agent-skills`, затем `/plugin install agent-skills@addy-agent-skills` |
| Codex, OpenCode | `npx skills@latest add addyosmani/agent-skills --global --agent codex opencode --skill '*' --yes` |

> `npx skills` ставит только skills. Slash-команды (`/spec`, `/plan`…) и субагенты (`code-reviewer`, `security-auditor`, `test-engineer`, `web-performance-auditor`) приходят только с плагином. Без субагентов `/ship` и `/webperf` не работают.

После установки перезапустите агента: skills, команды и агенты подхватываются только при старте.

## Slash-команды (Claude Code)

| Команда | Когда |
| --- | --- |
| `/spec` | Новая фича, требования мутные. Пишет спецификацию до кода |
| `/plan` | Спека есть. Режет работу на задачи с критериями приёмки |
| `/build` | Реализует задачи по одной: код, тест, проверка, коммит. `/build auto` проходит весь план |
| `/test` | TDD. Для бага сначала падающий тест, доказывающий его (Prove-It) |
| `/review` | Ревью по пяти осям: корректность, читаемость, архитектура, безопасность, производительность |
| `/code-simplify` | Код работает, но запутан |
| `/ship` | Чеклист перед релизом, параллельный опрос субагентов, решение go/no-go |
| `/constraints` | Один раз на проект: записывает планку качества в `CONSTRAINTS.md` и следит, чтобы агент её не снижал |
| `/webperf` | Аудит производительности фронтенда |

## Skills, которые подхватываются сами

`debugging-and-error-recovery`, `security-and-hardening` (auth, ввод), `deprecation-and-migration` (миграции БД), `performance-optimization`, `api-and-interface-design`, `frontend-ui-engineering`, `documentation-and-adrs`, `git-workflow-and-versioning`, `doubt-driven-development` (рискованные изменения), `interview-me` и `idea-refine` (сырая идея), `context-engineering`, `using-agent-skills` (мета-skill).

В Codex и OpenCode вызывайте их по имени (`$имя` или «Use the … skill»).

## Какой инструмент выбрать

- **Ревью:** `/code-review` (встроенный) ищет баги в диффе; `/review` смотрит архитектуру и читаемость; `/security-review` (встроенный) для auth, загрузок, ввода.
- **Упрощение:** `/simplify` (встроенный) чистит текущий дифф; `/code-simplify` упрощает существующий код.
- **Баг с неясной причиной:** сначала `investigate-first` или `debugging-and-error-recovery`; если место известно, `surgical-patch`.
- **Качество:** `/constraints` один раз, дальше ссылка `@CONSTRAINTS.md` в `CLAUDE.md`.

## Типовой цикл

```text
/spec → /plan → /build → /test → /code-review → /review → /ship
```

Личные правила (язык, caveman, коммиты, приоритеты MCP) лежат в глобальном `~/.claude/CLAUDE.md`, шаблон: [templates/global-CLAUDE.md](templates/global-CLAUDE.md).
