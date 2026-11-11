# SAR Comms Log - PowerShell Launcher
$ErrorActionPreference = "SilentlyContinue"
Set-Location -Path $PSScriptRoot

Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "       SAR Comms Log - Local Field Launcher" -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Starting local web server on http://localhost:8000 ..." -ForegroundColor Green
Write-Host "(Microphone and Web Workers require http:// or https://)" -ForegroundColor Yellow
Write-Host ""

Start-Process "http://localhost:8000"

if (Get-Command python -ErrorAction SilentlyContinue) {
    python -m http.server 8000
} elseif (Get-Command py -ErrorAction SilentlyContinue) {
    py -m http.server 8000
} elseif (Get-Command npx -ErrorAction SilentlyContinue) {
    npx -y serve -l 8000 .
} else {
    Write-Warning "Neither Python nor Node/npx was found on PATH. Opening index.html directly..."
    Start-Process "$PSScriptRoot\index.html"
}

