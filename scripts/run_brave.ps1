# Run DYD 2026 in Brave with hot reload.
#
# Flutter SDK must live in a path WITHOUT spaces (e.g. C:\flutter).
# This project can be opened via junction: C:\dyd2026
#
# In the Flutter terminal:
#   r  = hot reload (most Dart/UI edits)
#   R  = hot restart (assets, main(), global state)
#   q  = quit

$ErrorActionPreference = "Stop"

$FlutterBin = "C:\flutter\bin"
$PubCache = "C:\pub-cache"
$BravePath = "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"
$ProjectRoot = if (Test-Path "C:\dyd2026\pubspec.yaml") { "C:\dyd2026" } else { Split-Path $PSScriptRoot -Parent }

if (-not (Test-Path "$FlutterBin\flutter.bat")) {
    Write-Error "Flutter not found at C:\flutter."
}

if (-not (Test-Path $BravePath)) {
    Write-Error "Brave not found at: $BravePath"
}

if (-not (Test-Path "$ProjectRoot\pubspec.yaml")) {
    Write-Error "pubspec.yaml not found in $ProjectRoot"
}

Set-Location $ProjectRoot
$env:Path = "$FlutterBin;$env:Path"
$env:PUB_CACHE = $PubCache
$env:CHROME_EXECUTABLE = $BravePath

if (-not (Test-Path "$ProjectRoot\web")) {
    Write-Host "Generating web platform files..."
    & "$FlutterBin\flutter.bat" create . --platforms=web
}

Write-Host "Starting Flutter web in Brave..."
Write-Host "  r  = hot reload"
Write-Host "  R  = hot restart"
Write-Host "  q  = quit"
Write-Host ""

& "$FlutterBin\flutter.bat" pub get
& "$FlutterBin\flutter.bat" run -d chrome
