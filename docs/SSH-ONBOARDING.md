# SSH read-only: настройка доступа (коробка Bitrix24)

Инструкция для **людей**. Агент в Cursor не заменяет эти шаги — только подсказывает (skill `bitrix24-ssh-onboarding`) и потом работает read-only (skill `bitrix24-readonly-ssh-core`).

Подключение репозитория клиента: **`connect-client.ps1`** с профилем `b24-boxed` или `hybrid` + `-HybridBase b24-boxed` ([START.md](START.md) шаг 4). Низкоуровневая раскатка — [COPY-TO-PROJECT.md](COPY-TO-PROJECT.md) (тимлид).

```text
[1 ключ на ПК] → [2 сервер: админ или sudo] → [3 проверка + карточка] → [4 работа в Cursor]
```

---

## 0. Подготовка репозитория клиента

Из папки кита (не из репо клиента):

```powershell
cd C:\Projects\cursor-b24-integrator-kit
.\scripts\connect-client.ps1 -TargetRepo C:\Projects\<client-repo> -ProjectType b24-boxed
```

Появятся: `scripts/ssh/`, `templates/ssh/`, этот файл в `docs/SSH-ONBOARDING.md`, при необходимости копии skills в `.cursor/skills/`.

Rules и subagents для SSH также доступны через **плагин** Bitrix24 Integrator Kit (Teams Required).

---

## 1. Ключ на вашем ПК (Windows)

Терминал — в **корне git-репозитория клиента**.

```powershell
.\scripts\ssh\setup-local-ssh-key.ps1 -ProjectRoot .
```

- Папка `.\.ssh\`, строка `.ssh/` в `.gitignore`.
- Passphrase при `ssh-keygen` — **рекомендуется**.
- Админу отдаёте только **`.\.ssh\имя.pub`**, не приватный ключ.

Ключ в профиле Windows:

```powershell
.\scripts\ssh\setup-local-ssh-key.ps1 -UseUserProfile -KeyName id_ed25519_client_readonly
```

Перед работой агента с passphrase:

```powershell
ssh-add .\.ssh\имя_ключа
```

---

## 2. Сервер: два варианта

### 2a. Тикет админу заказчика

Шаблон: `templates/ssh/server-readonly-user-admin-handoff.md.template` — вставьте строку из `.pub`, `SITE_ROOT`, контакты.

Ожидание от админа: user (например `codex_readonly`), ключ в `authorized_keys`, чтение `bitrix/` и `local/`, **без записи** в корень сайта.

### 2b. Сами с root / sudo на сервере

Переменные на сервере:

```bash
export READONLY_USER="codex_readonly"
export SITE_ROOT="/home/bitrix/www"   # ваш корень сайта
export PUB_KEY='ssh-ed25519 AAAA...'  # одна строка из .pub
```

Создать user и ключ:

```bash
id "$READONLY_USER" 2>/dev/null || sudo useradd -m -s /bin/bash "$READONLY_USER"
sudo passwd -l "$READONLY_USER" 2>/dev/null || true
sudo install -d -m 700 -o "$READONLY_USER" -g "$READONLY_USER" "/home/$READONLY_USER/.ssh"
echo "$PUB_KEY" | sudo tee -a "/home/$READONLY_USER/.ssh/authorized_keys"
sudo chmod 600 "/home/$READONLY_USER/.ssh/authorized_keys"
sudo chown -R "$READONLY_USER:$READONLY_USER" "/home/$READONLY_USER/.ssh"
```

Чтение сайта (часто группа `bitrix`):

```bash
sudo usermod -aG bitrix "$READONLY_USER"
sudo -u "$READONLY_USER" test -r "$SITE_ROOT/bitrix" && echo READ_OK_BITRIX
sudo -u "$READONLY_USER" test -r "$SITE_ROOT/local" && echo READ_OK_LOCAL
sudo -u "$READONLY_USER" test -w "$SITE_ROOT" && echo WRITE_OK || echo WRITE_DENIED
```

Нужны `READ_OK_*` и **`WRITE_DENIED`**. Если `WRITE_OK` — ACL/политика хостинга (см. `templates/ssh/server-readonly-user-admin.sh.template`).

Черновик скрипта: `templates/ssh/server-readonly-user-admin.sh.template` — только **ручной** запуск на сервере.

### 2c. Нестандарт: только user `bitrix`

Отдельного user **не** создавать. В карточке: `access_tier: bitrix_shared`. Агент всё равно только **смотрит** файлы по регламенту.

---

## 3. Карточка и проверка

Шаблон → `docs/standards/readonly-ssh-core-access.md`:

`templates/readonly-ssh-core-access.md.template`

Проверка с ПК:

```powershell
.\scripts\ssh\verify-readonly-access.ps1 -AccessCardPath docs\standards\readonly-ssh-core-access.md
```

Или с параметрами: `-SshHost`, `-SshUser`, `-SshKeyPath`, `-ServerProjectPath`.

---

## 4. Работа в Cursor

1. Workspace = **репозиторий клиента**.
2. Skill **`bitrix24-readonly-ssh-core`** (прикрепить или `/` в чате).
3. Пример: «Прочитай `docs/standards/readonly-ssh-core-access.md`, найди класс X в ядре — только read-only SSH».

Подробнее про команды `ssh` и Cursor: `.cursor/skills/bitrix24-readonly-ssh-core/getting-started.md`.

Вопросы по настройке (не по live-ядру): skill **`bitrix24-ssh-onboarding`** + этот файл.

---

## Скрипты

| Скрипт | Назначение |
|--------|------------|
| `scripts/ssh/setup-local-ssh-key.ps1` | Ключ на ПК |
| `scripts/ssh/verify-readonly-access.ps1` | Проверка после выдачи доступа |

Кратко: `scripts/ssh/README.md`.

---

## Безопасность

- Не коммитить приватный ключ, passphrase, пароли.
- Не вставлять ключ в чат Cursor.
- `/bitrix` на сервере не редактировать.
- Агент не выполняет `sudo` / `useradd` на проде из IDE.

Правило агента: `.cursor/rules/bitrix24-ssh-access.mdc` (или через плагин Teams).
