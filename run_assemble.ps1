$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot"
$env:PATH = "$env:JAVA_HOME\bin;" + $env:PATH
Set-Location "E:\Ahmedbaba-main\Ahmad-baba"
mkdir -p "E:\Ahmedbaba-main\Ahmad-baba\build\aot_out"
& "E:\flutter\bin\flutter.bat" assemble --output="E:\Ahmedbaba-main\Ahmad-baba\build\aot_out" -dTargetFile=lib\main.dart -dTargetPlatform=android -dBuildMode=release -dAndroidArchs=android-arm64 android_aot_bundle_release_android-arm64 -v
