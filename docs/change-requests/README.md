# Change requests

- Рабочие CR: `CR-NNN-*.md` / `YYYY-MM-DD-*.md` (стиль проекта — в `AGENTS.md`)
- **Шаблон:** [`CR.template.md`](CR.template.md) — копировать при новой заявке
- Подготовка: subagent `change-request-preparer`, skill `bitrix24-change-request`
- После нового CR: показать резюме и запросить подтверждение интегратора (`ok` / `уточнение: …` / `нет`)
- После подтверждённого CR: subagent `orchestrator` + `docs/playbooks/workflow.md`
