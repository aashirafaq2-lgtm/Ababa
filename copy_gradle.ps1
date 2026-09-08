$src = "C:\Users\Administrator\.gradle\wrapper\dists\gradle-9.3.1-all\9ot9r568e8zfvvd4mn8rbu1j0"
$dest = "E:\gradle_user_home\wrapper\dists\gradle-9.3.1-all\9ot9r568e8zfvvd4mn8rbu1j0"
New-Item -ItemType Directory -Path $dest -Force | Out-Null
Copy-Item -Path "$src\*" -Destination $dest -Recurse -Force
Write-Host "GRADLE DIST COPIED TO E DRIVE SUCCESSFULLY!"
