# Playbook: change-request-preparer (project extension)

Subagent: `.cursor/agents/change-request-preparer.md`. Skill: `bitrix24-change-request`.

Сохранять в `docs/change-requests/` (имя: `CR-NNN-кратко.md` или `YYYY-MM-DD-кратко.md` по стилю проекта).

## Шаблон CR

1. Открыть `docs/change-requests/CR.template.md` (из кита при bootstrap).
2. Скопировать в новый файл `CR-NNN-…md`, заполнить все разделы.
3. Не оставлять плейсхолдеры `NNN` / `…` в финальном CR.

## Перед написанием

1. Найти 2–5 похожих CR в `docs/change-requests/`.
2. Изучить релевантные docs и код (пути — в `AGENTS.md`).
3. Один уточняющий вопрос только если без него нельзя.

## Оркестрация в CR

Указать путь к файлу и ожидаемую цепочку subagents — для `orchestrator` в режиме execute после подтверждения CR.

## После сохранения CR

1. Показать путь к файлу.
2. Кратко перечислить scope, вне scope, критерии приёмки и риски.
3. Запросить подтверждение интегратора: **`ok`** / **`уточнение: …`** / **`нет`**.
4. Не запускать `orchestrator` и не писать код до явного **`ok`**. Если пришло уточнение — обновить CR и снова запросить подтверждение.
