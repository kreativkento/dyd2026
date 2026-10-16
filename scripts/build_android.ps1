# Build Android APK for sideload testing (release, signed with debug key)
#
# Prerequisites:
#   - Flutter at C:\flutter (path without spaces)
#   - Android SDK (Android Studio or cmdline-tools)
#   - JDK 17+ (e.g. winget install Microsoft.OpenJDK.17)

$ErrorActionPreference = "Stop"

$FlutterBin = "C:\flutter\bin"
$JdkHome = "C:\Program Files\Microsoft\jdk-17.0.19.10-hotspot"
$ProjectRoot = if (Test-Path "C:\dyd2026\pubspec.yaml") { "C:\dyd2026" } else { Split-Path $PSScriptRoot -Parent }

if (-not (Test-Path "$FlutterBin\flutter.bat")) {
    Write-Error "Flutter not found at C:\flutter"
}

if (-not (Test-Path "$JdkHome\bin\java.exe")) {
    Write-Error "JDK not found at $JdkHome. Install with: winget install Microsoft.OpenJDK.17"
}

$env:Path = "$FlutterBin;$JdkHome\bin;$env:Path"
$env:JAVA_HOME = $JdkHome

Set-Location $ProjectRoot

flutter pub get
flutter build apk --release

$apk = Join-Path $ProjectRoot "build\app\outputs\flutter-apk\app-release.apk"
Write-Host ""
Write-Host "APK ready: $apk"
Write-Host ""
Write-Host "Install on Android:"
Write-Host "  1. Copy the APK to your phone (USB, email, Drive, etc.)"
Write-Host "  2. Open the file and allow install from unknown sources if prompted"
Write-Host ""
