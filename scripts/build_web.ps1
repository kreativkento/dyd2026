# Build Flutter web as a PWA (offline-first service worker) for GitHub Pages.
#
# Default base path matches: https://kreativkento.github.io/dyd2026/
# Local testing:  .\scripts\build_web.ps1 -BaseHref "/"

param(
    [string]$BaseHref = "/dyd2026/"
)

$ErrorActionPreference = "Stop"

$FlutterBin = "C:\flutter\bin"
$ProjectRoot = if (Test-Path "C:\dyd2026\pubspec.yaml") { "C:\dyd2026" } else { Split-Path $PSScriptRoot -Parent }

if (-not (Test-Path "$FlutterBin\flutter.bat")) {
    Write-Error "Flutter not found at C:\flutter"
}

if ($BaseHref -ne "/" -and $BaseHref -notmatch '^/.+/$') {
    Write-Error "BaseHref must be / or a path like /dyd2026/ (leading and trailing slash)."
}

$env:Path = "$FlutterBin;$env:Path"
Set-Location $ProjectRoot

Write-Host "Generating web/PWA icons from dyd_logo.png..."
& "$FlutterBin\dart.bat" run flutter_launcher_icons -f flutter_launcher_icons_web.yaml

Write-Host ""
Write-Host "Building web release (PWA, base-href=$BaseHref)..."
& "$FlutterBin\flutter.bat" pub get
& "$FlutterBin\flutter.bat" build web --release --base-href $BaseHref

# GitHub Pages has no SPA rewrite; 404.html loads the app for deep links / refresh.
$webOut = Join-Path $ProjectRoot "build\web"
Copy-Item (Join-Path $webOut "index.html") (Join-Path $webOut "404.html") -Force

Write-Host ""
Write-Host "Web build ready: $webOut"
Write-Host ""
Write-Host "Test locally (root base-href only):"
Write-Host "  flutter build web --release --base-href /"
Write-Host "  .\scripts\serve_web.ps1"
Write-Host ""
Write-Host "Deploy: push to GitHub (Actions workflow) or upload build\web to Pages."
