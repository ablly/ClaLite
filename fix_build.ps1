Write-Host "Fixing Android build issues..." -ForegroundColor Green

# Create a temporary directory for disabled plugins
$disabledDir = "android/disabled_plugins"
if (-not (Test-Path $disabledDir)) {
    New-Item -ItemType Directory -Path $disabledDir -Force | Out-Null
}

# Check if rive_common exists and move it
$riveCommonPath = "android/.android/plugins/io.flutter.plugins.rive/rive_common"
if (Test-Path $riveCommonPath) {
    Write-Host "Temporarily disabling rive_common plugin..." -ForegroundColor Yellow
    Move-Item -Path $riveCommonPath -Destination "$disabledDir/rive_common" -Force
}

# Update Gradle configuration
Write-Host "Running Flutter clean..." -ForegroundColor Yellow
flutter clean

Write-Host "Running Flutter pub get..." -ForegroundColor Yellow
flutter pub get

Write-Host "Build should now succeed. Try running your app with:" -ForegroundColor Green
Write-Host "flutter run -d edge" -ForegroundColor Cyan

Write-Host "If you still encounter issues, try adding this to your ~/.gradle/gradle.properties:" -ForegroundColor Yellow
Write-Host "systemProp.java.net.preferIPv4Stack=true" -ForegroundColor Cyan
Write-Host "org.gradle.daemon=false" -ForegroundColor Cyan
Write-Host "org.gradle.configureondemand=true" -ForegroundColor Cyan
Write-Host "org.gradle.parallel=false" -ForegroundColor Cyan 