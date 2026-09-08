$zipPath = "E:\Ahmedbaba-main\ahmedbaba-backend-dist.zip"
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
Compress-Archive -Path "E:\Ahmedbaba-main\Ahmad-baba\backend\dist", "E:\Ahmedbaba-main\Ahmad-baba\backend\package.json" -DestinationPath $zipPath
Write-Host "Backend zip complete:" (Get-Item $zipPath).Length "bytes"
