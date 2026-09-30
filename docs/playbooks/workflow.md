# Workflow: change request → subagents

Индекс playbooks: `README.md`. Корневые правила: `AGENTS.md`.  
Subagents: `.cursor/agents/`. Автоцепочка: rule `bitrix24-orchestration.mdc`.

## Термины

- **Subagent** — файл в `.cursor/agents/<role>.md`, вызов через orchestrator / Task.
- **Playbook** — `docs/playbooks/<role>.md`, только дополнения для этого репозитория.

## Вход

### A. Есть CR

1. Прочитать CR.
2. Прочитать 2–5 похожих CR в `docs/change-requests/`.
3. Прочитать релевантные docs и код.
4. Subagent `orchestrator` (режим **execute**, если в задаче путь к CR и нет «только план»).
5. При shared-контрактах — dependency scan до кода.

### B. Нет CR

Subagent `change-request-preparer` → сохранить CR → показать резюме и запросить подтверждение интегратора → после **ok** → `orchestrator` execute.

## Цепочка по умолчанию

1. `change-request-preparer` (если нет CR)
2. `orchestrator`
3. `architect` (если impact неочевиден; можно пропустить для мелочи)
4. `developer` / `html-layout` / `n8n-developer` — по scope
5. `tester`
6. `documentation`

Только docs: preparer (при необходимости) → `documentation` → краткий checklist.

## Approval gate после CR

- После создания нового CR остановиться до реализации.
- Показать путь к CR и краткое резюме scope / вне scope / критериев приёмки.
- Продолжать orchestration только после явного **`ok`** от интегратора.
- При ответе `уточнение: …` обновить CR и снова запросить подтверждение.

## Матрица маршрутизации

| Сигнал | Playbooks / subagents |
|--------|------------------------|
| Нет CR | `change-request-preparer` |
| Крупное / кросс-модульное | `orchestrator`, `architect` |
| Поле / переменная БП / API / шаблон | + dependency scan, `tester`, `documentation` |
| PHP в БП | `architect`, `developer`, `tester` |
| CLI / mass update | + lock, batch, cursor в CR |
| HTML шаблон | `html-layout`, `tester` |
| n8n | `n8n-developer`, `documentation` |

## Готово, когда

- Реализация в scope CR.
- Scan выполнен или явно N/A.
- `/bitrix` не тронут.
- Критерии приёмки CR проверены.
- Docs обновлены, риски указаны.

## Отключить автоцепочку в чате

«только план», «не делегируй», `plan-only`.
