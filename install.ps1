# 自然码2000 v2 Rime 安装脚本（Windows / 小狼毫）
$ErrorActionPreference = 'Stop'
$src = Split-Path -Parent $MyInvocation.MyCommand.Path
$dst = Join-Path $env:APPDATA 'Rime'
New-Item -ItemType Directory -Force -Path $dst | Out-Null
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
$roots = @($env:ProgramFiles, [Environment]::GetFolderPath('ProgramFilesX86')) | Where-Object { $_ -and (Test-Path $_) }
$deployer = $null
foreach ($root in $roots) {
  $deployer = Get-ChildItem (Join-Path $root 'Rime') -Recurse -Filter WeaselDeployer.exe -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
  if ($deployer) { break }
}
if ($deployer) {
  Write-Host ('deploying via ' + $deployer)
  & $deployer /deploy
} else {
  Write-Host '未找到 WeaselDeployer.exe；请右键小狼毫托盘图标 -> 重新部署。'
}
Write-Host ('完成。用户目录：' + $dst)
