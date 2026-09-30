# SSH scripts (boxed Bitrix24)

Human guide: **`docs/SSH-ONBOARDING.md`** (copied with `connect-client.ps1` for boxed/hybrid profiles).

```text
[SSH-ONBOARDING.md] → verify script → skill bitrix24-readonly-ssh-core
```

| Script | Purpose |
|--------|---------|
| `setup-local-ssh-key.ps1` | Ed25519 key in `.\.ssh\` (interactive) |
| `verify-readonly-access.ps1` | READ_OK_* / WRITE_DENIED after access granted |

```powershell
.\scripts\ssh\setup-local-ssh-key.ps1 -ProjectRoot .
.\scripts\ssh\verify-readonly-access.ps1 -AccessCardPath docs\standards\readonly-ssh-core-access.md
```

Agent onboarding (hints only): skill `bitrix24-ssh-onboarding`. Live server read: `bitrix24-readonly-ssh-core`.
