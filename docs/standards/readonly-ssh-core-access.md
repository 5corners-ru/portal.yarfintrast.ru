# SSH: доступ к ядру и /local

> Карточка портала `https://portal.yarfintrast.ru`.  
> Пароли и приватные ключи **не** хранить в этом файле и не вставлять в чат.

## Назначение

Просмотр `/bitrix` и `/local` на сервере. Не для деплоя и правок. Агент не использует `sudo` и не ходит под `root`.

## Параметры подключения

| Параметр | Значение |
|----------|----------|
| SSH host | `80.78.254.199` |
| SSH user | `bitrix` |
| SSH key | `.\.ssh\id_ed25519_portal_yarfintrast_ru_readonly` |
| SSH config alias (опционально) | _не задан_ |
| site root (`SERVER_PROJECT_PATH`) | `/home/bitrix/ext_www/portal.yarfintrast.ru` |
| Локальный cwd (справка) | Корень репозитория в Cursor; `pwd` после SSH ≠ корень сайта |
| access_tier | `bitrix_shared` |
| sudo_available | `yes` (учётные `root` — только человеку в vault; агенту не выдавать) |

Onboarding: `docs/SSH-ONBOARDING.md`.

### Разрешённые пути для чтения

```text
/home/bitrix/ext_www/portal.yarfintrast.ru/bitrix/modules/
/home/bitrix/ext_www/portal.yarfintrast.ru/bitrix/php_interface/
/home/bitrix/ext_www/portal.yarfintrast.ru/local/
```

## Команда подключения (PowerShell)

```powershell
ssh -i .\.ssh\id_ed25519_portal_yarfintrast_ru_readonly -o BatchMode=yes -o IdentitiesOnly=yes -o ConnectTimeout=10 bitrix@80.78.254.199 "команда"
```

## Проверка доступа (после установки ключа на сервер)

```powershell
.\scripts\ssh\verify-readonly-access.ps1 -AccessCardPath docs\standards\readonly-ssh-core-access.md
```

`/home/bitrix/www` на этой машине — заглушка (нет `modules` и `local`). Боевой портал: `ext_www/portal.yarfintrast.ru`.

На `bitrix_shared` допустим `WRITE_OK` (у `bitrix` обычно есть запись в корень сайта). Для агента это не разрешение писать.

## Контакты

| Роль | Кто |
|------|-----|
| Выдача/отзыв SSH | vault: `ssh - bitrix(new)` → `bitrix@80.78.254.199`; запись `ssh`/`root` на `194.58.108.253` — не для агента |
| Публичный ключ | установить в `~/.ssh/authorized_keys` пользователя `bitrix` |

## Запрещено

- Коммитить приватный ключ, passphrase, пароли
- Кладсть пароль `root`/`bitrix` в `.env`, `AGENTS.md` или чат
- Использовать `root` для работы агента
- Писать на сервер без отдельного CR
