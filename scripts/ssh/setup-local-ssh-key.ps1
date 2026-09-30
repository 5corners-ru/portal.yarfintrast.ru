# Local Ed25519 SSH key for read-only Bitrix24 access (interactive ssh-keygen).
# Example: .\scripts\ssh\setup-local-ssh-key.ps1 -ProjectRoot .
param(
    [string]$ProjectRoot = (Get-Location).Path,
    [string]$KeyName,
    [switch]$UseUserProfile,
    [switch]$NoPassphrase
)

$ErrorActionPreference = "Stop"

function Get-DefaultKeyName {
    param([string]$Root)
    $folder = Split-Path -Leaf $Root
    $safe = ($folder -replace '[^\w\-]', '_').Trim('_')
    if ([string]::IsNullOrWhiteSpace($safe)) { $safe = "project" }
    "id_ed25519_${safe}_readonly"
}

function Test-GitignoreHasSshEntry {
    param([string]$GitignorePath)
    if (-not (Test-Path $GitignorePath)) { return $false }
    foreach ($line in Get-Content -LiteralPath $GitignorePath) {
        $t = $line.Trim()
        if ($t -eq '.ssh' -or $t -eq '.ssh/') { return $true }
    }
    return $false
}

if (-not $KeyName) {
    $KeyName = Get-DefaultKeyName -Root $ProjectRoot
}

if ($UseUserProfile) {
    $keyDir = Join-Path $env:USERPROFILE ".ssh"
} else {
    $ProjectRoot = (Resolve-Path $ProjectRoot).Path
    $keyDir = Join-Path $ProjectRoot ".ssh"
}

New-Item -ItemType Directory -Force -Path $keyDir | Out-Null
$privatePath = Join-Path $keyDir $KeyName
$publicPath = "$privatePath.pub"

if (Test-Path -LiteralPath $privatePath) {
    throw "Key already exists: $privatePath. Remove it or use another -KeyName."
}

if (-not $UseUserProfile) {
    $gitignore = Join-Path $ProjectRoot ".gitignore"
    $line = ".ssh/"
    if (-not (Test-GitignoreHasSshEntry -GitignorePath $gitignore)) {
        if (Test-Path -LiteralPath $gitignore) {
            Add-Content -LiteralPath $gitignore -Value "`n$line"
            Write-Host "Added to .gitignore: $line"
        } else {
            Set-Content -LiteralPath $gitignore -Value $line -Encoding UTF8
            Write-Host "Created .gitignore with: $line"
        }
    }
}

$comment = "$($env:USERNAME)@$(Get-Date -Format 'yyyy-MM-dd')"
$sshKeygen = Get-Command ssh-keygen -ErrorAction Stop

if ($NoPassphrase) {
    Write-Warning "NoPassphrase: empty passphrase. Use only if intentional."
    # OpenSSH on Windows: -N "" must be quoted; splatting @("-N","") drops the value.
    & $sshKeygen.Source -t ed25519 -a 64 -f $privatePath -C $comment -N '""'
} else {
    Write-Host "ssh-keygen will prompt for passphrase interactively (recommended)."
    & $sshKeygen.Source -t ed25519 -a 64 -f $privatePath -C $comment
}

Write-Host ""
Write-Host "Done."
Write-Host "  Private (do not commit): $privatePath"
Write-Host "  Public (send to admin):    $publicPath"
Write-Host ""
Write-Host "Next:"
Write-Host "  1. Send .pub to server admin (see docs/SSH-ONBOARDING.md section 2)"
Write-Host "  2. After server setup: ssh-add $privatePath"
Write-Host "  3. Verify: .\scripts\ssh\verify-readonly-access.ps1 -AccessCardPath docs\standards\readonly-ssh-core-access.md"
Write-Host "  4. Work: skill bitrix24-readonly-ssh-core"
