# 🚀 Полное пошаговое руководство по развертыванию Claude Code

Этот стек оптимизирован для **ML-инженерии и Python-разработки**, бережет до 90% токенов, строит граф кода и автоматически поддерживает порядок в `CLAUDE.md`.

---

### ШАГ 1. Системные CLI-утилиты и токен-киллер (RTK)
*Устанавливаем бинарники для поиска по AST, работы с Jupyter-ноутбуками и сжатия консольного вывода.*

```bash
# 1.1 Установка ast-grep и Jupytext через uv
uv tool install jupytext
uv tool install ast-grep-cli

# 1.2 Установка RTK (Rust Token Killer) и активация авто-хука
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
rtk init --global
```

---

#### ШАГ 2. Регистрация MCP-серверов (Глобально)
*Подключаем внешние «мозги»: граф архитектуры, загрузчик документации и пошаговое планирование.*

```bash
# 2.1 Граф памяти проекта (codebase-memory-mcp)
curl -fsSL https://raw.githubusercontent.com/DeusData/codebase-memory-mcp/main/install.sh | bash

# Включаем автоматическую фоновую индексацию графа для всех проектов
codebase-memory-mcp config set auto_index true

# 2.2 Модуль загрузки веб-документации (Fetch MCP через uvx)
claude mcp add --scope user fetch -- uvx mcp-server-fetch

# 2.3 Модуль глубокого пошагового планирования (Sequential Thinking MCP)
claude mcp add --scope user sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking
```

---

#### ШАГ 3. Установка скиллов и плагинов
*Загружаем правила поведения, лаконичные ответы и менеджеры процессов.*

> 💡 **При запросах в терминале выбирайте:**
> 1. Агент: **`● Claude Code (.claude/skills)`**
> 2. Метод установки: **`○ Symlink (Recommended)`**

```bash
# 3.1 Caveman (Убирает «воду» из ответов Claude)
npx skills add JuliusBrussee/caveman

# 3.2 Andrej Karpathy Skills (Правила чистого AI-кодинга)
npx skills add multica-ai/andrej-karpathy-skills

# 3.3 ClaudeForge (Плагин авто-управления и чистки CLAUDE.md)
npx skills add alirezarezvani/ClaudeForge
curl -fsSL https://raw.githubusercontent.com/alirezarezvani/ClaudeForge/main/install.sh | bash

# 3.4 Matt Pocock Skills (Плагин процессов разработки)
claude plugin marketplace add mattpocock/skills
claude plugin install mattpocock-skills@mattpocock
```

---

### ⚙️ ШАГ 4. Настройка нового ML-проекта

Выполняйте в папке любого вашего проекта при старте работы:

1. **Создайте файл авто-синхронизации Jupyter-ноутбуков:**
   ```bash
   echo 'default_jupytext_formats = "ipynb,py:percent"' > jupytext.toml
   ```
   *(Теперь все существующие и будущие `.ipynb` в любых подпапках будут автоматически дублироваться в легкие `.py` файлы).*

2. **Запустите Claude Code:**
   ```bash
   claude
   ```

3. **Выполните первичные команды настройки внутри Claude Code:**
   * `/init` — сгенерирует первичный `CLAUDE.md`.
   * `/setup-matt-pocock-skills` — настроит трекер задач (GitHub/Linear/файлы) и папку документации.
   * `/mcp` — убедитесь, что все 3 сервера (`codebase-memory-mcp`, `fetch`, `sequential-thinking`) находятся в статусе **`✔ connected`**.

---

### 📋 Чек-лист проверки готовности системы

* [x] **RTK:** При вызове любых Bash-команд в консоли появляется плашка сжатия токенов.
* [x] **Codebase Memory:** В меню `/mcp` видны функции вроде `get_architecture` и `trace_path`.
* [x] **Fetch & Sequential Thinking:** В меню `/mcp` все 3 сервера зеленые и подключены.
* [x] **Caveman & Karpathy Rules:** Claude отвечает лаконично, по делу и производит минимальные, аккуратные изменения.
* [x] **ClaudeForge:** Поддерживает порядок в `CLAUDE.md`, а команда `/sync-claude-md` чистит устаревшие правила.
