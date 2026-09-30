# Verify read-only SSH: id, READ_OK_BITRIX, READ_OK_LOCAL, WRITE_DENIED.
# Example: .\scripts\ssh\verify-readonly-access.ps1 -AccessCardPath docs\standards\readonly-ssh-core-access.md
param(
    [string]$SshKeyPath,
    [string]$SshUser,
    [string]$SshHost,
    [string]$ServerProjectPath,
    [string]$AccessCardPath = "docs/standards/readonly-ssh-core-access.md",
    [switch]$AllowWriteOk
)

$ErrorActionPreference = "Stop"

function Get-TableField {
    param(
        [string]$Content,
        [string]$Label
    )
    $escaped = [regex]::Escape($Label)
    if ($Content -match "(?m)\|\s*$escaped[^|]*\|\s*([^|\r\n]+)\s*\|") {
        $v = $Matches[1].Trim()
        $v = $v -replace '^`+|`+$', ''
        return $v.Trim()
    }
    return $null
}

function Test-IsPlaceholder {
    param([string]$Value)
    if ([string]::IsNullOrWhiteSpace($Value)) { return $true }
    if ($Value -match '\{\{') { return $true }
    if ($Value -match '(?i)example\.com|HOST\.|TODO|_FIO|ukazat') { return $true }
    return $false
}

$accessTier = $null
if ($AccessCardPath -and (Test-Path -LiteralPath $AccessCardPath)) {
    $card = Get-Content -LiteralPath $AccessCardPath -Raw -Encoding UTF8
    if (-not $SshHost) { $SshHost = Get-TableField $card "SSH host" }
    if (-not $SshUser) { $SshUser = Get-TableField $card "SSH user" }
    if (-not $SshKeyPath) { $SshKeyPath = Get-TableField $card "SSH key" }
    if (-not $ServerProjectPath) {
        $ServerProjectPath = Get-TableField $card "SERVER_PROJECT_PATH"
        if (Test-IsPlaceholder $ServerProjectPath) {
            $ServerProjectPath = Get-TableField $card "site root"
        }
    }
    $accessTier = Get-TableField $card "access_tier"
    if (-not $accessTier) { $accessTier = Get-TableField $card "access tier" }
}

$missing = @()
if (Test-IsPlaceholder $SshHost) { $missing += "SshHost" }
if (Test-IsPlaceholder $SshUser) { $missing += "SshUser" }
if (Test-IsPlaceholder $SshKeyPath) { $missing += "SshKeyPath" }
if (Test-IsPlaceholder $ServerProjectPath) { $missing += "ServerProjectPath" }

if ($missing.Count -gt 0) {
    Write-Host "Missing connection parameters: $($missing -join ', ')."
    Write-Host "Fill docs/standards/readonly-ssh-core-access.md or pass -SshHost, -SshUser, -SshKeyPath, -ServerProjectPath."
    exit 2
}

$keyResolved = $SshKeyPath
if ($SshKeyPath -match '^\.\\') {
    $keyResolved = Join-Path (Get-Location).Path ($SshKeyPath -replace '^\.\\', '')
} elseif ($SshKeyPath -match '^\.(/|\\)') {
    $keyResolved = Join-Path (Get-Location).Path ($SshKeyPath -replace '^\.(/|\\)', '')
}

if (-not (Test-Path -LiteralPath $keyResolved)) {
    Write-Host "Key file not found: $keyResolved"
    Write-Host "Run ssh-add after creating the key, or fix path in access card."
    exit 2
}

$remote = @(
    "id"
    "test -r $ServerProjectPath/bitrix && echo READ_OK_BITRIX || echo READ_FAIL_BITRIX"
    "test -r $ServerProjectPath/local && echo READ_OK_LOCAL || echo READ_FAIL_LOCAL"
    "test -w $ServerProjectPath && echo WRITE_OK || echo WRITE_DENIED"
) -join "; "

Write-Host "Checking: ${SshUser}@${SshHost} (site: $ServerProjectPath)"
Write-Host ""

$text = ""
try {
    $output = & ssh -i $keyResolved -o BatchMode=yes -o ConnectTimeout=15 "${SshUser}@${SshHost}" $remote 2>&1
    $text = ($output | Out-String).Trim()
    Write-Host $text
} catch {
    Write-Host "SSH failed: $($_.Exception.Message)"
    Write-Host "Check network, VPN, host, key (ssh-add), and server account."
    exit 2
}

$ok = $true
if ($text -notmatch 'READ_OK_BITRIX') {
    Write-Host "ERROR: READ_OK_BITRIX not found"
    $ok = $false
}
if ($text -notmatch 'READ_OK_LOCAL') {
    Write-Host "ERROR: READ_OK_LOCAL not found"
    $ok = $false
}

if ($text -match 'WRITE_OK') {
    if ($accessTier -eq 'bitrix_shared' -or $AllowWriteOk) {
        Write-Warning "WRITE_OK (bitrix_shared). Document in access card; agent stays read-only by policy."
    } else {
        Write-Host "WARNING: WRITE_OK - account can write site root. Read-only not confirmed."
        exit 1
    }
} elseif ($text -notmatch 'WRITE_DENIED') {
    Write-Host "Could not determine WRITE_DENIED/WRITE_OK."
    $ok = $false
}

if (-not $ok) { exit 1 }
Write-Host ""
Write-Host "Verification passed."
exit 0
