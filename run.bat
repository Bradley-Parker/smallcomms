@echo off
setlocal
cd /d "%~dp0"

echo ===================================================
echo        SAR Comms Log - Local Field Launcher
echo ===================================================
echo.
echo Starting local web server on http://localhost:8000 ...
echo (Microphone and Web Workers require http:// or https://)
echo.

where python >nul 2>nul
if %ERRORLEVEL% equ 0 (
    start http://localhost:8000
    python -m http.server 8000
    goto :eof
)

where py >nul 2>nul
if %ERRORLEVEL% equ 0 (
    start http://localhost:8000
    py -m http.server 8000
    goto :eof
)

where npx >nul 2>nul
if %ERRORLEVEL% equ 0 (
    start http://localhost:8000
    npx -y serve -l 8000 .
    goto :eof
)

echo [WARNING] Neither Python nor Node/npx was detected in PATH.
echo Attempting to open index.html directly...
start index.html
echo.
pause

