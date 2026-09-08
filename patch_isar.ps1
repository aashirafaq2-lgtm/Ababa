$isarGradle = "$env:LOCALAPPDATA\Pub\Cache\hosted\pub.dev\isar_flutter_libs-3.1.0+1\android\build.gradle"
if (Test-Path $isarGradle) {
    $content = Get-Content $isarGradle -Raw
    if ($content -notmatch 'namespace') {
        $replacement = "android {" + [Environment]::NewLine + "    namespace 'dev.isar.isar_flutter_libs'"
        $newContent = $content.Replace("android {", $replacement)
        Set-Content -Path $isarGradle -Value $newContent -Force
        Write-Host "SUCCESS: Added namespace to isar_flutter_libs"
    } else {
        Write-Host "ALREADY HAS NAMESPACE"
    }
} else {
    Write-Host "NOT FOUND: $isarGradle"
}
