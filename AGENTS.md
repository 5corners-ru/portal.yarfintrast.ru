# Cursor / Codex: portal.yarfintrast.ru

Проект: **коробочный Bitrix24** (`b24-boxed`). Общие правила команды — в `.cursor/rules/` (кит `cursor-b24-integrator-kit`).

## Портал (коробка B24)

- Профиль: `b24-boxed`
- Домен / портал: `https://portal.yarfintrast.ru`
- Webhook read-only (если есть): `B24_WEBHOOK_BASE` в `.env` корня проекта (не User/System env), не коммитить
- SSH read-only: skill `bitrix24-readonly-ssh-core` + `docs/standards/readonly-ssh-core-access.md`
- SSH onboarding: `docs/SSH-ONBOARDING.md`, skill `bitrix24-ssh-onboarding`, `scripts/ssh/`


## Subagents и playbooks

| Слой | Путь |
|------|------|
| **Subagent** (роль Cursor) | Team plugin **Bitrix24 Integrator Kit** (опц. `.cursor/agents/<role>.md` при legacy-копии) |
| **Playbook** (специфика проекта) | `docs/playbooks/<role>.md` — то же имя, что у subagent |
| **Workflow** (цепочка CR) | `docs/playbooks/workflow.md` |

Rule `bitrix24-playbooks.mdc` — не путать subagent и playbook.

**Subagents и skills по умолчанию** поставляются **Team plugin** (plugin-first bootstrap). Этот `AGENTS.md` и playbooks — только дополнение (профиль, пути, исключения), не замена базовых ролей.

## Change requests

- Каталог CR: `docs/change-requests/` (шаблон: `CR.template.md`)
- Нетривиальные изменения — только через CR; новый CR сначала показывается интегратору и продолжается только после **ok**
- Подготовка CR: subagent `change-request-preparer` + skill `bitrix24-change-request` + playbook `change-request-preparer.md`

## Оркестрация

По умолчанию (**автоцепочка**): путь к подтверждённому CR в задаче → rule `bitrix24-orchestration.mdc` → subagent `orchestrator` (execute) → цепочка subagents. Если CR нет: `change-request-preparer` → проверка CR интегратором → **ok** → `orchestrator`. Отключить: «только план» / «не делегируй».

Не подключай папки целиком (Full Folder Content): карта проекта / targeted-файлы.

1. CR первым (если указан путь).
2. `docs/playbooks/workflow.md` — порядок ролей.
3. Subagents: `architect` → `developer` / `html-layout` / `n8n-developer` → `tester` → `documentation`.
4. Dependency scan при shared-полях, переменных БП, API, шаблонов, workflow I/O.

Кит: `cursor-b24-integrator-kit` → `docs/INTEGRATOR-WORKFLOW.md`, `docs/TEAM-CHAT-TEMPLATES.md` §6.

## Специфика клиента

- Домен: `https://portal.yarfintrast.ru`
- Ключевые сущности CRM: _указать_
- Каталоги кода / docs: _указать_
- Особые BP / workflow: _указать_
- Запреты: _указать_
