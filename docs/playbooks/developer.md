# Playbook: developer — B24 boxed

Расширение subagent `.cursor/agents/developer.md` для **этого репозитория**.

## Код и пути

- Custom code: `local/`, `php_interface` (уточните в AGENTS.md)
- BP PHP activities: skill `bitrix24-readonly-ssh-core` / skill `bitrix24-bp-php-activity` (тело без `<?php`)
- Domain package (если есть): _указать каталог, напр. `event-b24-automation/`_

## REST и диагностика

- Webhook: `B24_WEBHOOK_BASE` **только** в `.env` корня проекта (`.env.example` → локальный `.env`, не в git; не User/System env)
- Опционально: `local/tools/b24-rest/` — шаблон в ките `templates/local/tools/b24-rest/`

## Массовые операции

- Указывать в CR: batch size, lock, resume, dry-run, путь к log/report
- CLI/cron: только пути из CR; не запускать на прод без критериев приёмки

## SSH

- Read-only core: `docs/standards/readonly-ssh-core-access.md` после onboarding
- Не менять `/bitrix`

## Перед кодом

1. CR и при необходимости ТЗ architect
2. Dependency impact scan (поля, переменные БП, шаблоны, REST)
3. Подтвердить entity IDs и коды полей из проекта — не выдумывать

## Запреты проекта

_Добавьте: сущности, каталоги, BP, которые нельзя трогать без отдельного CR._
