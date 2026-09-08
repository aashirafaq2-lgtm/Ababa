Add-Type -AssemblyName System.Drawing

$sourcePath = "E:\Ahmedbaba-main\Ahmad-baba\assets\branding\logo.png"
$bmp = [System.Drawing.Image]::FromFile($sourcePath)

$sizes = @{
    "mipmap-mdpi" = 48
    "mipmap-hdpi" = 72
    "mipmap-xhdpi" = 96
    "mipmap-xxhdpi" = 144
    "mipmap-xxxhdpi" = 192
}

foreach ($folder in $sizes.Keys) {
    $dim = $sizes[$folder]
    $destDir = "E:\Ahmedbaba-main\Ahmad-baba\android\app\src\main\res\$folder"
    $destFile = Join-Path $destDir "ic_launcher.png"
    
    $newBmp = New-Object System.Drawing.Bitmap($dim, $dim)
    $g = [System.Drawing.Graphics]::FromImage($newBmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    
    # Fill pure white background
    $g.Clear([System.Drawing.Color]::White)
    
    # Precise crop of the orange AhmedBaba emblem only:
    $srcX = 72
    $srcY = 220
    $srcW = 192
    $srcH = 200
    
    $srcRect = New-Object System.Drawing.Rectangle($srcX, $srcY, $srcW, $srcH)
    
    $pad = [math]::Round($dim * 0.08)
    $innerDim = $dim - ($pad * 2)
    $destRect = New-Object System.Drawing.Rectangle($pad, $pad, $innerDim, $innerDim)
    
    $g.DrawImage($bmp, $destRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)
    $g.Dispose()
    
    $newBmp.Save($destFile, [System.Drawing.Imaging.ImageFormat]::Png)
    $newBmp.Dispose()
}

$bmp.Dispose()
Write-Host "PERFECT AHMEDBABA ICONS GENERATED!"
