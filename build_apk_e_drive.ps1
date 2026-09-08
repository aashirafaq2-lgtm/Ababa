$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot"
$env:PATH = "$env:JAVA_HOME\bin;" + $env:PATH
$env:GRADLE_USER_HOME = "E:\gradle_user_home"
Set-Location "E:\Ahmedbaba-main\Ahmad-baba"
& "E:\flutter\bin\flutter.bat" build apk --release --target-platform=android-arm64
if ($LASTEXITCODE -eq 0) {
    Copy-Item "E:\Ahmedbaba-main\Ahmad-baba\build\app\outputs\flutter-apk\app-release.apk" "E:\Ahmedbaba-main\Ahmad-baba\Ababa-release.apk" -Force
    Copy-Item "E:\Ahmedbaba-main\Ahmad-baba\build\app\outputs\flutter-apk\app-release.apk" "C:\Users\Administrator\Desktop\Ababa-release.apk" -Force
    Write-Host "SUCCESS: Copied to Desktop and project root!"
}
