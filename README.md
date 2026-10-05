# 🚀 Агентный стек для Claude Code, Codex и OpenCode

Гайд собирает окружение для ML-инженерии и Python-разработки: поиск по коду, синхронизацию Jupyter-ноутбуков, сжатие вывода терминала, MCP-серверы и skills. Процессы разработки (spec → plan → build → test → review → ship) обеспечивает набор [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills).

Можно настроить одну среду или все три. Блок «Общее окружение» выполняется один раз. Конфигурации MCP и плагины у агентов различаются — не переносите команды между ними буквально.

| Среда | Запуск | Инструкции проекта | Skills |
| --- | --- | --- | --- |
| Claude Code | `claude` | `CLAUDE.md` | `.claude/skills/` |
| Codex | `codex` | `AGENTS.md` | `.agents/skills/` |
| OpenCode | `opencode` | `AGENTS.md` | `.opencode/skills/` или `.agents/skills/` |

> OpenCode автоматически читает `.agents/skills/`. Это удобное общее расположение skills для Codex и OpenCode; Claude Code использует `.claude/skills/`.

---

## 1. Общее окружение

Сначала установите базовые CLI-инструменты:

```bash
# Поиск по AST и текстовые представления Jupyter-ноутбуков
uv tool install jupytext
uv tool install ast-grep-cli

# RTK — сжатие вывода команд для экономии контекста
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh

# Граф памяти кодовой базы
curl -fsSL https://raw.githubusercontent.com/DeusData/codebase-memory-mcp/main/install.sh | bash
codebase-memory-mcp config set auto_index true
```

Установите нужные среды по разделам 2–4, затем вернитесь сюда и подключите RTK и Codebase Memory. Для полного стека выполните все команды:

```bash
# RTK
rtk init --global
rtk init --global --codex
rtk init --global --opencode

# Установщик автоматически обнаруживает поддерживаемых агентов
codebase-memory-mcp install -y
```

Установите общие skills сразу для всех трёх сред:

```bash
npx skills@latest add JuliusBrussee/caveman \
  --global --agent claude-code codex opencode --skill '*' --yes

npx skills@latest add multica-ai/andrej-karpathy-skills \
  --global --agent claude-code codex opencode --skill '*' --yes
```

Для Codex и OpenCode добавьте набор процессов разработки. Для Claude Code используйте плагин (раздел 2): он даёт ещё и slash-команды с субагентами, которые `npx skills` не устанавливает.

```bash
npx skills@latest add addyosmani/agent-skills \
  --global --agent codex opencode --skill '*' --yes
```

> Не ставьте один и тот же набор и через `npx skills`, и через плагин в Claude Code: skills задвоятся и будут занимать контекст.

В корне каждого ML-проекта создайте `jupytext.toml`:

```toml
default_jupytext_formats = "ipynb,py:percent"
```

---

## 2. Claude Code

### Установка и вход

```bash
npm install -g @anthropic-ai/claude-code
claude
```

Завершите авторизацию в первом запуске. Проверка установки: `claude doctor`.

### MCP-серверы

```bash
# Документация по URL
claude mcp add --scope user fetch -- uvx mcp-server-fetch

# Пошаговое планирование
claude mcp add --scope user sequential-thinking -- \
  npx -y @modelcontextprotocol/server-sequential-thinking
```

`codebase-memory-mcp` устанавливается общим скриптом. Откройте `/mcp` и проверьте подключения.

### Skills и плагины Claude

Следующие расширения предназначены только для Claude Code:

```bash
# Автоподдержка CLAUDE.md
npx skills@latest add alirezarezvani/ClaudeForge \
  --global --agent claude-code --skill '*' --yes
curl -fsSL https://raw.githubusercontent.com/alirezarezvani/ClaudeForge/main/install.sh | bash

```

Процессы разработки (skills, slash-команды и субагенты) ставятся плагином. Выполните внутри Claude Code:

```text
/plugin marketplace add addyosmani/agent-skills
/plugin install agent-skills@addy-agent-skills
/reload-plugins
```

> Если `marketplace add` падает с `Permission denied (publickey)`, используйте HTTPS: `/plugin marketplace add https://github.com/addyosmani/agent-skills.git`.

Плагин `caveman` даёт хуки (режим кратких ответов, statusline). Если вы поставили и плагин, и skills через `npx skills`, удалите задвоившиеся отдельные skills (`cavecrew`, `caveman`, `caveman-commit`, `caveman-compress`, `caveman-help`, `caveman-review`, `caveman-stats`) из `~/.agents/skills/` и `~/.claude/skills/`:

```text
/plugin marketplace add JuliusBrussee/caveman
/plugin install caveman@caveman
```

### Личные правила и команда `/claude-md-init`

Личные правила (язык ответов, caveman, Karpathy, запрет `Co-Authored-By`, приоритеты MCP, `uv`/`ruff`, маршрутизация по skills) хранятся один раз в глобальном `~/.claude/CLAUDE.md`, а не в каждом проекте. Шаблоны лежат в [templates/](templates/):

```bash
# Если файл уже есть, сначала объедините вручную. Строка @RTK.md нужна после rtk init --global.
cp templates/global-CLAUDE.md ~/.claude/CLAUDE.md
mkdir -p ~/.claude/commands
cp templates/claude-md-init.md ~/.claude/commands/claude-md-init.md
```

`/claude-md-init` создаёт или обновляет проектный `CLAUDE.md` только с проектной спецификой (стек, структура, проверенные команды, запреты), без повторов личных правил.

### Первый запуск проекта

```bash
cd /путь/к/проекту
claude
```

Выполните `/claude-md-init` (или `/init`), чтобы создать `CLAUDE.md`; затем `/mcp`. Для нового проекта цикл такой: `/spec` → `/plan` → `/build` → `/test` → `/code-review` → `/ship`; подробности в [agent-skills-guide.md](agent-skills-guide.md).

---

## 3. Codex

### Установка и вход

```bash
npm install -g @openai/codex
codex
```

В первом запуске завершите предложенную авторизацию.

### MCP-серверы

`codex mcp add` сохраняет пользовательские серверы в `~/.codex/config.toml`.

```bash
# Документация по URL
codex mcp add fetch -- uvx mcp-server-fetch

# Пошаговое планирование
codex mcp add sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking

# Проверка состояния серверов
codex mcp list
```

Опционально добавьте официальный MCP документации OpenAI:

```bash
codex mcp add openaiDeveloperDocs --url https://developers.openai.com/mcp
```

Если `codebase-memory-mcp` отсутствует в списке, повторите `codebase-memory-mcp install -y` после установки Codex.

### Skills и инструкции

Skills `addyosmani/agent-skills` для Codex уже установлены командой из раздела 1. Проверка: `npx skills list --global`.

В корне проекта используйте `AGENTS.md`. Команда `/init` создаёт стартовый файл, `/mcp` показывает MCP, а `/skills` — доступные skills.

Codex вызывает skills через `$имя` или меню `/skills`:

```text
$interview-me Помоги уточнить требования к новой функции
$spec-driven-development Напиши спецификацию до кода
$planning-and-task-breakdown Разбей спецификацию на задачи
$test-driven-development Реализуй изменение через red-green-refactor
$code-review-and-quality Проверь текущие изменения
```

Codex также может выбрать подходящий skill автоматически по описанию задачи. Slash-команды `/spec`, `/plan` и т.п. есть только в Claude Code.

---

## 4. OpenCode

### Установка и подключение модели

```bash
curl -fsSL https://opencode.ai/install | bash
opencode
```

В интерфейсе выполните `/connect`, выберите провайдера и сохраните ключ; затем используйте `/models`. Альтернатива: `npm install -g opencode-ai`.

### MCP-серверы

Интерактивный способ — `opencode mcp add`; проверка — `opencode mcp list`.

Либо добавьте серверы в глобальный `~/.config/opencode/opencode.json` или проектный `opencode.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "fetch": {
      "type": "local",
      "command": ["uvx", "mcp-server-fetch"],
      "enabled": true
    },
    "sequential-thinking": {
      "type": "local",
      "command": ["npx", "-y", "@modelcontextprotocol/server-sequential-thinking"],
      "enabled": true
    }
  }
}
```

После перезапуска выполните `opencode mcp list`. Если `codebase-memory-mcp` отсутствует, повторите `codebase-memory-mcp install -y` после установки OpenCode.

### Skills и инструкции

OpenCode читает `.opencode/skills/`, а также совместимые `.agents/skills/` и `.claude/skills/`. Skills `addyosmani/agent-skills` для OpenCode уже установлены командой из раздела 1 в общий Agent Skills-каталог `~/.agents/skills/`. Если skill не отображается в slash-меню, сформулируйте запрос явно:

```text
Use the spec-driven-development skill to write a spec for this feature
Use the planning-and-task-breakdown skill to split the spec into tasks
Use the test-driven-development skill to implement this change
Use the code-review-and-quality skill to review the current diff
```

OpenCode загружает skills через встроенный инструмент `skill` и умеет выбирать их автоматически. Проверка обнаруженных skills: `opencode debug skill`. Проектные правила храните в `AGENTS.md`.

> ClaudeForge не предназначен для OpenCode. agent-skills используется здесь как набор стандартных Agent Skills, а не как OpenCode-плагин.

---

## 5. Python LSP (Pyright)

LSP даёт агенту диагностику типов и навигацию по Python-коду: переход к определению, поиск ссылок и информацию о символах. Установите Pyright один раз:

```bash
npm install -g pyright
pyright --version
command -v pyright-langserver
```

Для Fish, если глобальные npm-команды не находятся, добавьте каталог npm в `PATH`:

```fish
fish_add_path (npm prefix -g)/bin
```

Для Bash выполните:

```bash
export PATH="$(npm prefix -g)/bin:$PATH"
```

После изменения `PATH` полностью перезапустите агента из того же терминала.

### Claude Code

Claude Code подключает Pyright через официальный LSP-плагин:

```text
/plugin marketplace add anthropics/claude-plugins-official
/plugin install pyright-lsp@claude-plugins-official
/reload-plugins
```

Проверьте установку:

```bash
claude plugin list
pyright --version
command -v pyright-langserver
```

Старый MCP-сервер `@mcp/python-lsp` для этого не нужен. Если он был установлен и отображается как `python-lsp MCP · failed`, удалите его:

```bash
claude mcp remove python-lsp
```

Затем перезапустите Claude Code. В `/plugin` плагин `pyright-lsp` должен быть включён без ошибок.

### OpenCode

Создайте глобальный `~/.config/opencode/opencode.json` для всех проектов либо `opencode.json` в корне конкретного проекта:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "lsp": true,
  "permission": {
    "lsp": "allow"
  }
}
```

Запустите OpenCode с экспериментальным инструментом навигации LSP:

```bash
OPENCODE_EXPERIMENTAL_LSP_TOOL=true opencode
```

Чтобы не указывать флаг при каждом запуске, сохраните переменную окружения один раз. Для Fish:

```fish
set -Ux OPENCODE_EXPERIMENTAL_LSP_TOOL true
```

Для Bash добавьте в `~/.bashrc`:

```bash
export OPENCODE_EXPERIMENTAL_LSP_TOOL=true
```

После этого запускайте OpenCode обычной командой `opencode`. Чтобы выключить настройку в Fish, выполните `set -eU OPENCODE_EXPERIMENTAL_LSP_TOOL`.

Pyright входит в список встроенных LSP-конфигураций OpenCode и активируется для `.py` и `.pyi`, когда `pyright` установлен. Без экспериментального инструмента OpenCode всё равно может использовать LSP-диагностику, но агент не получает операции перехода к определению и поиска ссылок.

### Codex

В Codex нет штатной пользовательской настройки Python LSP. Добавьте в `AGENTS.md` команду проверки типов, чтобы агент запускал Pyright после изменений:

```md
После изменений Python-кода запускай `pyright`.
```

---

## 6. Рекомендуемый workflow (agent-skills)

```text
/spec          # уточнить требования, написать спецификацию до кода
   ↓
/plan          # разбить на маленькие задачи с критериями приёмки
   ↓
/build         # реализовать по задачам (/build auto — весь план за раз)
   ↓
/test          # TDD; для бага сначала падающий тест (Prove-It)
   ↓
/code-review   # встроенный: поиск багов; /review — архитектура и читаемость
   ↓
/ship          # чеклист перед релизом, решение go/no-go
```

Slash-команды доступны в Claude Code через плагин. В Codex и OpenCode вызывайте те же процессы через skills: `spec-driven-development`, `planning-and-task-breakdown`, `incremental-implementation`, `test-driven-development`, `code-review-and-quality`, `shipping-and-launch`. Когда что использовать: [agent-skills-guide.md](agent-skills-guide.md).

После установки или обновления конфигурации полностью перезапустите выбранного агента.

## 7. Проверка

```bash
claude plugin list
claude mcp list

codex mcp list

opencode mcp list
opencode debug skill

npx skills list --global
```

Ожидаемый результат: `codebase-memory-mcp`, `fetch` и `sequential-thinking` подключены во всех трёх средах; Claude показывает включённые `agent-skills` и `caveman`, а Codex/OpenCode обнаруживают skills из `~/.agents/skills/`.

## Полезные ссылки

- [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)
- [Codex Skills](https://learn.chatgpt.com/docs/build-skills?surface=cli)
- [OpenCode Agent Skills](https://opencode.ai/docs/skills)
