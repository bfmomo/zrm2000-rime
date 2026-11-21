# Installs the bundled Weasel TSF (run elevated). ASCII-only on purpose.
$ErrorActionPreference = 'Continue'
$src = Split-Path -Parent $MyInvocation.MyCommand.Path
$prog = $null
try { $prog = (Get-ItemProperty 'HKLM:\Software\Rime\Weasel' -Name WeaselRoot -ErrorAction Stop).WeaselRoot } catch {}
if (-not $prog) { $prog = 'C:\Program Files\Rime\weasel-0.17.4' }
Write-Host ('program dir: ' + $prog)
$pairs = @(
  @{ src = (Join-Path $src 'tsf\weaselx64.dll'); dst = 'C:\Windows\System32\weasel.dll' },
  @{ src = (Join-Path $src 'tsf\weaselx64.dll'); dst = (Join-Path $prog 'weaselx64.dll') },
  @{ src = (Join-Path $src 'tsf\weasel.dll');    dst = 'C:\Windows\SysWOW64\weasel.dll' },
  @{ src = (Join-Path $src 'tsf\weasel.dll');    dst = (Join-Path $prog 'weasel.dll') }
)
$stamp = Get-Date -Format 'yyyyMMdd-HHmm'
foreach ($p in $pairs) {
  if (-not (Test-Path -LiteralPath $p.src)) { Write-Host ('missing ' + $p.src); continue }
  if (Test-Path -LiteralPath $p.dst) { Copy-Item -LiteralPath $p.dst -Destination ($p.dst + '.bak-' + $stamp) -Force -ErrorAction SilentlyContinue }
  $ok = $false
  try { Copy-Item -LiteralPath $p.src -Destination $p.dst -Force -ErrorAction Stop; $ok = $true } catch {}
  if (-not $ok) {
    try { Move-Item -LiteralPath $p.dst -Destination ($p.dst + '.inuse-' + $stamp) -Force -ErrorAction Stop } catch {}
    try { Copy-Item -LiteralPath $p.src -Destination $p.dst -Force -ErrorAction Stop; $ok = $true } catch {}
  }
  Write-Host (($(if ($ok) { 'installed ' } else { 'FAILED    ' })) + $p.dst)
}
$help = Join-Path $src 'zrm2000-help.html'
if (Test-Path $help) {
  try { Copy-Item $help (Join-Path $prog 'zrm2000-help.html') -Force -ErrorAction Stop; Write-Host 'help copied to program dir' } catch { Write-Host ('help copy failed: ' + $_.Exception.Message) }
}
Write-Host 'done. Restart the apps (or explorer) so they load the new TSF.'
