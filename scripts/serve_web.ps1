# Serve the web build for iOS Safari testing on your local network.
# Run after: .\scripts\build_web.ps1 -BaseHref "/"   (local Wi‑Fi test)
# For GitHub Pages production build use default BaseHref /dyd2026/ and deploy via Actions.
#
# On iPhone: connect to the same Wi‑Fi, open Safari, go to http://<your-pc-ip>:8080

$ErrorActionPreference = "Stop"

$ProjectRoot = if (Test-Path "C:\dyd2026\pubspec.yaml") { "C:\dyd2026" } else { Split-Path $PSScriptRoot -Parent }
$WebDir = Join-Path $ProjectRoot "build\web"
$Port = 8080

if (-not (Test-Path $WebDir)) {
    Write-Error "Web build not found. Run: flutter build web --release"
}

$ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {
    $_.IPAddress -notlike "127.*" -and $_.PrefixOrigin -ne "WellKnown"
} | Select-Object -First 1).IPAddress

if (-not $ip) { $ip = "localhost" }

Write-Host ""
Write-Host "Serving DYD 2026 web build for mobile testing"
Write-Host "  Local:   http://localhost:$Port"
Write-Host "  Network: http://${ip}:$Port"
Write-Host ""
Write-Host "On iPhone (same Wi‑Fi): open the Network URL in Safari."
Write-Host "Optional: Share -> Add to Home Screen for an app-like icon."
Write-Host "Press Ctrl+C to stop."
Write-Host ""

Set-Location $WebDir
python -m http.server $Port --bind 0.0.0.0
