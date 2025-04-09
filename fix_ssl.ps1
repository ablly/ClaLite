Write-Host "Fixing SSL certificate issues..." -ForegroundColor Green

# 检查并创建必要的目录
$certsDir = "android/app/src/main/res/raw"
if (-not (Test-Path $certsDir)) {
    New-Item -ItemType Directory -Path $certsDir -Force | Out-Null
}

# 复制系统证书到项目
$javaHome = $env:JAVA_HOME
if (-not $javaHome) {
    Write-Host "JAVA_HOME environment variable not found. Please set it and try again." -ForegroundColor Red
    exit 1
}

$cacertsPath = Join-Path $javaHome "lib\security\cacerts"
if (Test-Path $cacertsPath) {
    Copy-Item -Path $cacertsPath -Destination "$certsDir\cacerts" -Force
    Write-Host "Copied system certificates to project" -ForegroundColor Green
} else {
    Write-Host "Could not find system certificates at $cacertsPath" -ForegroundColor Red
    exit 1
}

# 更新 Gradle 配置
$gradleProperties = "android/gradle.properties"
if (Test-Path $gradleProperties) {
    $content = Get-Content -Path $gradleProperties -Raw
    $content = $content -replace "systemProp.javax.net.ssl.trustStore=.*", "systemProp.javax.net.ssl.trustStore=$certsDir\cacerts"
    Set-Content -Path $gradleProperties -Value $content
    Write-Host "Updated Gradle properties" -ForegroundColor Green
}

Write-Host "Running Flutter clean..." -ForegroundColor Yellow
flutter clean

Write-Host "Running Flutter pub get..." -ForegroundColor Yellow
flutter pub get

Write-Host "SSL certificate issues should now be fixed. Try running your app again with:" -ForegroundColor Green
Write-Host "flutter run" -ForegroundColor Cyan 