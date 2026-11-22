@echo off
rem zrm2000-rime installer launcher.
rem Windows blocks .ps1 by default (ExecutionPolicy=Restricted), so this .cmd
rem starts PowerShell with -ExecutionPolicy Bypass for this one run only.
rem It does not change any machine-wide policy.
setlocal
cd /d "%~dp0"

echo.
echo == zrm2000-rime installer ==
echo    (PowerShell -ExecutionPolicy Bypass, one run only)
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-ChildItem -LiteralPath '%~dp0.' -Recurse -File -ErrorAction SilentlyContinue | Unblock-File -ErrorAction SilentlyContinue"

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1"
set "RC=%ERRORLEVEL%"

echo.
echo exit=%RC%
pause
