Write-Host "Fixing rive_common plugin issues..." -ForegroundColor Green

# Define paths
$riveCommonPath = "android/.android/plugins/io.flutter.plugins.rive/rive_common"
$riveCommonGradlePath = "$riveCommonPath/android/build.gradle"

# Check if rive_common exists
if (Test-Path $riveCommonPath) {
    # Create a backup of the original file
    if (Test-Path $riveCommonGradlePath) {
        Copy-Item -Path $riveCommonGradlePath -Destination "$riveCommonGradlePath.bak" -Force
        
        # Read and modify the build.gradle file for rive_common
        $content = Get-Content -Path $riveCommonGradlePath -Raw
        
        # Fix the android plugin application
        $content = $content -replace "apply plugin: 'com.android.library'", @"
plugins {
    id 'com.android.library'
}
"@
        
        # Add proper android configuration if missing
        if ($content -notmatch "android {") {
            $content += @"

android {
    namespace "com.rive.rive_common"
    compileSdkVersion 33
    
    defaultConfig {
        minSdkVersion 16
        targetSdkVersion 33
    }
}
"@
        }
        
        # Save the modified file
        Set-Content -Path $riveCommonGradlePath -Value $content
        
        Write-Host "Fixed rive_common build.gradle file" -ForegroundColor Green
    } else {
        Write-Host "rive_common build.gradle file not found" -ForegroundColor Yellow
    }
} else {
    Write-Host "rive_common plugin not found" -ForegroundColor Yellow
}

Write-Host "Clean and rebuild the project..." -ForegroundColor Yellow
flutter clean
flutter pub get

Write-Host "Now try running your app again with:" -ForegroundColor Green
Write-Host "flutter run" -ForegroundColor Cyan 