# Playbook: tester (project extension)

Subagent: `.cursor/agents/tester.md`.

Вход: CR, diff/список изменений, при необходимости handoff architect.

Проверить по **критериям приёмки** CR; регрессии (BP, mass, shared-поля); соответствие scan.

Формат: чеклист pass/fail, что проверить на портале, остаточные риски. Не переписывать архитектуру.

**Summary (обязательно):** в ответе tester и в `docs/qa/CR-*-qa-report.md` первым — `## Summary` с **RESULT:** `PASS` | `FAIL` | `CONDITIONAL` | `BLOCKED` и одной строкой итога; детальная таблица TC — ниже (rule `bitrix24-testing`, agent `tester`).

Если в чате/CR описана **бизнес-логика** заполнения или вида результата — фикстуры и Expected должны её **воспроизводить**, а не подгонять PASS под старые упрощённые данные (см. rule `bitrix24-testing`, agent `tester`).

Если QA создавала тестовые CRM-сущности через REST — в конце прогона финализировать cleanup (collect/append ID по ходу → finalize at end → delete только после «очищать»). Skill: `bitrix24-rest-test-cleanup`; rule: `bitrix24-testing`.
