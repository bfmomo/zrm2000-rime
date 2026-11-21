# zrm2000-rime installer (v1.1.0, ASCII-only on purpose: Windows PowerShell
# reads .ps1 as ANSI unless it has a BOM, so keep this file non-Unicode).
$ErrorActionPreference = 'Stop'
$src = Split-Path -Parent $MyInvocation.MyCommand.Path
$dst = Join-Path $env:APPDATA 'Rime'
New-Item -ItemType Directory -Force -Path $dst | Out-Null

# 1) schema / dict / lua
$files = @(
  'zrm2000.schema.yaml',
  'zrm2000_code.schema.yaml',
  'zrm2000.dict.yaml',
  'custom_phrase.txt',
  'rime.lua',
  'default.custom.yaml',
  'weasel.custom.yaml'
)
Copy-Item (Join-Path $src 'lua') $dst -Recurse -Force
foreach ($f in $files) {
  $to = Join-Path $dst $f
  if (Test-Path $to) { Copy-Item $to ($to + '.bak') -Force }
  Copy-Item (Join-Path $src $f) $to -Force
  Write-Host ('copied ' + $f)
}

# 2) help page: user dir first (no admin), then the program dir (needs admin)
$help = Join-Path $src 'zrm2000-help.html'
if (Test-Path $help) {
  Copy-Item $help (Join-Path $dst 'zrm2000-help.html') -Force
  Write-Host 'help copied to user dir'
}

# 3) TSF DLLs, optional and only with elevation
$tsf = Join-Path $src 'tsf'
if (Test-Path $tsf) {
  $installer = Join-Path $src 'install-tsf.ps1'
  if (Test-Path $installer) {
    Write-Host 'installing Weasel TSF (UAC prompt expected)...'
    try {
      Start-Process powershell -Verb RunAs -Wait -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-File',$installer
    } catch { Write-Host ('TSF install skipped: ' + $_.Exception.Message) }
  }
}

# 4) deploy schemas
$deployer = $null
foreach ($root in @($env:ProgramFiles, [Environment]::GetFolderPath('ProgramFilesX86'))) {
  if (-not $root -or -not (Test-Path $root)) { continue }
  $deployer = Get-ChildItem (Join-Path $root 'Rime') -Recurse -Filter WeaselDeployer.exe -ErrorAction SilentlyContinue |
    Select-Object -First 1 -ExpandProperty FullName
  if ($deployer) { break }
}
if ($deployer) {
  Write-Host ('deploying via ' + $deployer)
  & $deployer /deploy
} else {
  Write-Host 'WeaselDeployer.exe not found; right-click the Weasel tray icon and choose Deploy.'
}
Write-Host ('done. user dir: ' + $dst)
