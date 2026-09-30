# Playbook: orchestrator (project extension)

Subagent: `.cursor/agents/orchestrator.md`. Workflow: `workflow.md`.

## Режимы

- **execute** (по умолчанию при пути к подтверждённому CR): план → делегирование subagents по порядку. Оркестратор **не пишет** код реализации.
- **intake** (нет CR, пользователь описал задачу своими словами): делегировать `change-request-preparer`, дождаться подтверждения CR, затем execute.
- **plan-only**: по запросу «только план» / «не делегируй».

## Если CR ещё нет

1. Не писать код и не симулировать роли в корневом чате.
2. Передать задачу `change-request-preparer`; после сохранения CR остановиться на подтверждение интегратора (`ok` / `уточнение: …` / `нет`).
3. Только после **ok** запускать execute по созданному CR.

## После чтения подтверждённого CR

1. Классификация: B24 BP/CLI/module/CRM/REST/HTML/dump/docs; BUS; n8n; docs-only.
2. Риск: low / medium / high (массовые операции, рекурсия БП, FM, cron).
3. Subagents и порядок; что пропустить — с одной строкой причины.
4. Защиты: batch, lock, cursor, dry-run — по необходимости.
5. **Dependency impact scan**, если меняются shared-контракты (таблица: зависимость | где | решение | причина).
6. Список docs для синхронизации.
7. **Kit findings gate:** после documentation — собрать `Kit finding: candidate` из handoffs; при необходимости делегировать `plugin-contributor` (rule `bitrix24-kit-contribution.mdc`).

## Клиентские триггеры (заполнить)

- Массовые БП → обязателен `architect` перед `developer`.
- Hybrid: разделить portal и n8n в CR; workflow в `docs/integrations/n8n/`.

## Формат ответа (plan-only или шапка execute)

### Классификация
- тип, риск, сущности, объём данных

### Subagents
- роль — зачем

### Порядок
1. …

### Защиты
- …

### Dependency scan
таблица или «не требуется: …»
