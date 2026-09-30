# Playbooks (расширения ролей проекта)

Базовые **subagents** и **skills**: Team plugin **Bitrix24 Integrator Kit** (по умолчанию не копируются в `.cursor/`).  
**Playbooks** здесь — дополнение с клиентской спецификой; имя файла = имя subagent.

| Playbook | Subagent | Назначение |
|----------|----------|------------|
| `workflow.md` | — | Цепочка CR, режимы orchestrator, критерии готовности |
| `orchestrator.md` | `orchestrator` | Маршрутизация, риски, dependency scan |
| `change-request-preparer.md` | `change-request-preparer` | Формат CR |
| `architect.md` | `architect` | Анализ, ТЗ, scan |
| `developer.md` | `developer` | PHP, БП, `/local` |
| `n8n-developer.md` | `n8n-developer` | n8n (hybrid) |
| `html-layout.md` | `html-layout` | HTML/CSS шаблоны |
| `tester.md` | `tester` | Проверка по CR |
| `documentation.md` | `documentation` | Синхронизация docs |

- Change requests: `docs/change-requests/`
- n8n (hybrid): `docs/integrations/n8n/`
- Profile rules: `.cursor/rules/` (plugin-first bootstrap)

Bootstrap (plugin-first): `.\scripts\connect-client.ps1 -TargetRepo <path> -ProjectType ...`  
Legacy (копия skills/agents в репо): добавьте `-IncludeSkills -IncludeAgents`.

Устаревший путь: `docs/promts/` → переименуйте в `docs/playbooks/` и выровняйте имена файлов.
