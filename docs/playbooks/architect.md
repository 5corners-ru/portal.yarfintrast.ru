# Playbook: architect (project extension)

Subagent: `.cursor/agents/architect.md`. Не писать production-код.

## Пути проекта (уточнить в AGENTS.md)

- Документация: `docs/architecture/`, `docs/user-guides/`, `docs/change-requests/`
- Код: `local/`, корневые скрипты репозитория, каталоги модулей проекта

## Dependency impact scan (если CR меняет shared-контракт)

Искать по точным кодам: `UF_*`, `entityTypeId`, `IBLOCK_ID`, переменные БП, имена методов, placeholders шаблонов.

| Зависимость | Где найдено | Решение | Причина |
|-------------|-------------|---------|---------|

Решения: в текущем CR / не затрагивается / follow-up CR.

## Результат

1. Анализ CR  
2. Влияние (PHP, CRM, BP, iblock, Disk, HTML, CLI, docs)  
3. Что обновить в docs  
4. ТЗ для `developer` / `html-layout` / `n8n-developer`  
5. Таблица scan  
