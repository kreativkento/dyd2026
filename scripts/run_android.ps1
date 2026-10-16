# Run DYD 2026 on a connected Android device (USB or wireless ADB).
#
# In the Flutter terminal:
#   r  = hot reload
#   R  = hot restart
#   q  = quit

$ErrorActionPreference = "Stop"

$FlutterBin = "C:\flutter\bin"
$PubCache = "C:\pub-cache"
$JdkHome = "C:\Program Files\Microsoft\jdk-17.0.19.10-hotspot"
$Adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
$ProjectRoot = if (Test-Path "C:\dyd2026\pubspec.yaml") { "C:\dyd2026" } else { Split-Path $PSScriptRoot -Parent }

function Get-AdbDeviceId {
    param([string]$AdbPath)

    $lines = & $AdbPath devices
    foreach ($line in $lines) {
        $trimmed = $line.Trim()
        if ($trimmed -match '^(\S+)\s+device(?:\s|$)') {
            return $Matches[1]
        }
    }
    return $null
}

if (-not (Test-Path "$FlutterBin\flutter.bat")) {
    Write-Error "Flutter not found at C:\flutter."
}

if (-not (Test-Path "$JdkHome\bin\java.exe")) {
    Write-Error "JDK not found at: $JdkHome`nInstall JDK 17 or update JdkHome in this script."
}

if (-not (Test-Path "$ProjectRoot\pubspec.yaml")) {
    Write-Error "pubspec.yaml not found in $ProjectRoot"
}

if (-not (Test-Path $Adb)) {
    Write-Error "adb not found at: $Adb"
}

Set-Location $ProjectRoot
$env:Path = "$FlutterBin;$env:Path"
$env:PUB_CACHE = $PubCache
$env:JAVA_HOME = $JdkHome

& $Adb start-server | Out-Null
$deviceId = Get-AdbDeviceId -AdbPath $Adb

if (-not $deviceId) {
    Write-Host "adb devices output:"
    & $Adb devices
    Write-Error @"
No Android device in 'device' state.

Check:
  - USB cable and File transfer / MTP mode
  - USB debugging enabled and Allow on phone
  - Run: adb devices
"@
}

Write-Host "JAVA_HOME = $env:JAVA_HOME"
Write-Host "Device    = $deviceId"
Write-Host ""
Write-Host "Building and launching on phone (first run can take several minutes)..."
Write-Host "  r  = hot reload"
Write-Host "  R  = hot restart"
Write-Host "  q  = quit"
Write-Host ""

& "$FlutterBin\flutter.bat" pub get
& "$FlutterBin\flutter.bat" run -d $deviceId
