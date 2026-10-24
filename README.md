# 🚀 Агентный стек для Claude Code, Codex и OpenCode

Окружение для ML и Python-разработки: процессы разработки из [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) (spec → plan → build → test → review → ship), сжатие вывода терминала (RTK), автоформатирование, минимум MCP.

Главный принцип — **минимум постоянного контекста**. Описания каждого skill, MCP-инструмента и агента попадают в каждый запрос. Поэтому установлено только то, что реально используется, а редкие вещи вызываются вручную.

| Среда | Инструкции | Skills | Шаблоны |
| --- | --- | --- | --- |
| Claude Code | `~/.claude/CLAUDE.md`, `CLAUDE.md` проекта | `~/.claude/skills/` | [templates/claude/](templates/claude/) |
| Codex | `~/.codex/AGENTS.md`, `AGENTS.md` проекта | `~/.agents/skills/`, `~/.codex/skills/` | [templates/codex-opencode/](templates/codex-opencode/) |
| OpenCode | `~/.config/opencode/AGENTS.md`, `AGENTS.md` проекта | `~/.agents/skills/` | [templates/codex-opencode/](templates/codex-opencode/) |

Все команды ниже выполняются из корня этого репозитория.

---

## 1. Общие инструменты

Нужны `uv`, `jq`, `git` и Node.js 22+.

```bash
uv tool install jupytext       # ноутбуки ⇄ .py (для ML-проектов)
uv tool install ast-grep-cli   # структурный поиск и рефакторинг: sg
npm install -g pyright         # проверка типов Python

# RTK — сжимает вывод команд в контексте агента
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
```

Каталог глобальных npm-пакетов должен быть в `PATH`, иначе `pyright` и `codex` не найдутся:

```bash
echo 'export PATH="$(npm prefix -g)/bin:$PATH"' >> ~/.zshrc   # для fish: fish_add_path (npm prefix -g)/bin
```

Skills ставятся один раз для всех сред, в общий каталог:

```bash
npx skills@latest add addyosmani/agent-skills \
  --global --agent claude-code codex opencode --skill '*' --yes
npx skills@latest add multica-ai/andrej-karpathy-skills \
  --global --agent claude-code codex opencode --skill '*' --yes
```

В корне каждого ML-проекта создайте `jupytext.toml`:

```toml
default_jupytext_formats = "ipynb,py:percent"
```

---

## 2. Claude Code

### Установка

```bash
curl -fsSL https://claude.ai/install.sh | bash
claude            # вход в аккаунт
rtk init --global # хук RTK и @RTK.md
claude mcp add --scope user fetch -- uvx mcp-server-fetch
```

### Конфигурация из шаблонов

```bash
mkdir -p ~/.claude/{commands,personas,hooks}
cp templates/claude/global-CLAUDE.md ~/.claude/CLAUDE.md   # если файл уже есть, объедините вручную
cp templates/claude/claude-md-init.md templates/claude/commands/*.md ~/.claude/commands/
cp templates/claude/personas/*.md ~/.claude/personas/
cp templates/claude/hooks/ruff-format.sh ~/.claude/hooks/ && chmod +x ~/.claude/hooks/ruff-format.sh

# Объединить settings.json, сохранив существующие хуки (например, RTK)
jq -s '.[0] as $a | .[1] as $b
  | ($a * ($b | del(.hooks, .permissions)))
  | .hooks.PreToolUse  = (($a.hooks.PreToolUse  // []) + $b.hooks.PreToolUse)
  | .hooks.PostToolUse = (($a.hooks.PostToolUse // []) + $b.hooks.PostToolUse)
  | .permissions.deny  = ((($a.permissions.deny // []) + $b.permissions.deny) | unique)' \
  ~/.claude/settings.json templates/claude/settings.json > /tmp/settings.json \
  && mv /tmp/settings.json ~/.claude/settings.json
```

Что даёт каждая часть:

| Часть | Назначение |
| --- | --- |
| `global-CLAUDE.md` | личные правила: русский язык ответов, Karpathy, git и коммиты, безопасность, экономия контекста, актуальность CLAUDE.md |
| `commands/` | `/spec`, `/plan`, `/build`, `/test`, `/review`, `/ship`, `/constraints`, `/code-simplify`, `/claude-md-init` |
| `personas/` | ревьюеры для `/ship`; лежат вне `agents/`, поэтому не занимают контекст до вызова |
| `hooks/ruff-format.sh` | после правки `.py` запускает `ruff check --fix` и `ruff format` только для этого файла. Неотформатированный legacy-код не трогает, Claude получает только новые ошибки lint |
| `settings.json` | `attribution: false` (без `Co-Authored-By`); `skillOverrides` (неиспользуемые skills выключены, команды доступны только через `/`); запрет Read для `.env` |

Опционально:

```bash
# Jupyter MCP включается только в нужном проекте
cp templates/claude/bin/jupyter-mcp ~/.local/bin/ && chmod +x ~/.local/bin/jupyter-mcp
mkdir -p ~/.config/jupyter-mcp
printf 'JUPYTER_URL=http://localhost:8888\nJUPYTER_TOKEN=<токен>\n' > ~/.config/jupyter-mcp/env
chmod 600 ~/.config/jupyter-mcp/env
# в папке проекта: jupyter-mcp on | off | status, затем перезапуск Claude Code
```

```text
# Pyright LSP: переход к определению и поиск ссылок
/plugin marketplace add anthropics/claude-plugins-official
/plugin install pyright-lsp@claude-plugins-official
```

Статуслайн: `npm install -g ccstatusline`, затем в `settings.json` укажите `"statusLine": {"type": "command", "command": "ccstatusline"}`.

### Проект

```bash
cd /путь/к/проекту && claude
```

`/claude-md-init` создаёт проектный `CLAUDE.md` на 40–80 строк: стек, карта кода, проверенные команды, запуск одного теста, что не читать. Дальше работа по циклу `/spec → /plan → /build → /test → /code-review → /ship` (см. [agent-skills-guide.md](agent-skills-guide.md)).

Коммиты по умолчанию делаете вы: после каждого атомарного изменения Claude даёт готовую команду `git add … && git commit …`. Чтобы разрешить ему коммитить самому, добавьте в `CLAUDE.md` проекта строку `Auto-commit: allowed`.

### Что сознательно не ставится

| Инструмент | Почему |
| --- | --- |
| `codebase-memory-mcp` | за месяц 1 вызов; 17 инструментов и 7 хуков в каждом запросе |
| `sequential-thinking` MCP | 1 вызов за месяц; у модели есть собственное thinking |
| `caveman` | экономит 1–2% расхода: текст ответов — около 10% output |
| плагин agent-skills | его 4 агента попадают в каждый запрос, а `skillOverrides` на skills плагина не действуют |
| ClaudeForge | его skill работает на `haiku`, правила противоречат `/claude-md-init` |
| `includeGitInstructions: false` | экономит лишь 300–500 токенов на запрос |

### Экономия токенов

Около 80% расхода — это контекст, который заново отправляется с каждым запросом.
- `/clear` при смене задачи: одна задача — одна сессия.
- Effort `medium` по умолчанию; `/effort high` + `s` — только на текущую сессию, для сложных багов.
- После перерыва больше часа кеш истекает. Лучше новая сессия с коротким резюме.
- `/model sonnet` для рутины.
- В DS-проектах запретите чтение данных: `"permissions": {"deny": ["Read(./data/**)"]}` в `.claude/settings.json` проекта.
- Раз в неделю смотрите `/usage`.

---

## 3. Codex

```bash
npm install -g @openai/codex
codex                       # вход
rtk init --global --codex
codex mcp add fetch -- uvx mcp-server-fetch

mkdir -p ~/.codex/skills/agent-md-init
cp templates/codex-opencode/agent-md-init/SKILL.md ~/.codex/skills/agent-md-init/
cp templates/codex-opencode/global-AGENTS.md ~/.codex/AGENTS.md   # если файл уже есть, объедините вручную
```

Skills вызываются через `$имя` или меню `/skills`. Файл `AGENTS.md` проекта создаётся командой `$agent-md-init`.

## 4. OpenCode

```bash
curl -fsSL https://opencode.ai/install | bash
opencode                    # /connect — выбрать провайдера
rtk init --global --opencode

mkdir -p ~/.agents/skills/agent-md-init ~/.config/opencode
cp templates/codex-opencode/agent-md-init/SKILL.md ~/.agents/skills/agent-md-init/
cp templates/codex-opencode/global-AGENTS.md ~/.config/opencode/AGENTS.md
```

MCP и LSP задаются в `~/.config/opencode/opencode.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "fetch": { "type": "local", "command": ["uvx", "mcp-server-fetch"], "enabled": true }
  },
  "lsp": true,
  "permission": { "lsp": "allow" }
}
```

Навигация через LSP включается переменной `OPENCODE_EXPERIMENTAL_LSP_TOOL=true`. Skills вызываются запросом вида «Use the spec-driven-development skill …».

### Опционально для Codex и OpenCode

```bash
# Граф кодовой базы (установщик сам найдёт агентов)
curl -fsSL https://raw.githubusercontent.com/DeusData/codebase-memory-mcp/main/install.sh | bash
codebase-memory-mcp install -y   # регистрирует себя и в Claude: уберите там через claude mcp remove codebase-memory-mcp -s user

# Caveman — сжатый стиль ответов
npx skills@latest add JuliusBrussee/caveman --global --agent codex opencode --skill '*' --yes
```

---

## 5. Проверка

```bash
claude mcp list            # fetch
claude plugin list
codex mcp list
opencode mcp list
for c in uv jq jupytext sg rtk pyright codex opencode; do command -v $c >/dev/null || echo "нет: $c"; done
```

После любых изменений конфигурации перезапустите агента: skills, команды и хуки подхватываются при старте.
