$zipAdmin = "E:\Ahmedbaba-main\ahmedbaba-admin-dist.zip"
if (Test-Path $zipAdmin) { Remove-Item $zipAdmin -Force }
Compress-Archive -Path "E:\Ahmedbaba-main\Ahmad-baba\apps\admin_panel_web\.next", "E:\Ahmedbaba-main\Ahmad-baba\apps\admin_panel_web\public", "E:\Ahmedbaba-main\Ahmad-baba\apps\admin_panel_web\package.json" -DestinationPath $zipAdmin
Write-Host "Admin Panel zip completed:" (Get-Item $zipAdmin).Length "bytes"
