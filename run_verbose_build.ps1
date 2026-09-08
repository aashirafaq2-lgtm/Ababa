$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot"
$env:PATH = "$env:JAVA_HOME\bin;" + $env:PATH
Set-Location "E:\Ahmedbaba-main\Ahmad-baba"
& "E:\flutter\bin\flutter.bat" build apk --release -v
