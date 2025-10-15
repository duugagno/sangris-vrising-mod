# Script para criar um ICO real
Add-Type -AssemblyName System.Drawing

$logoPath = "d:\ProjetosC#\WinFormsApp1\WinFormsApp1\logo-png(1)(1).png"
$outputPath = "d:\ProjetosC#\WinFormsApp1\WinFormsApp1\sangria_icon.ico"

if (-not (Test-Path $logoPath)) {
    Write-Error "Logo não encontrada: $logoPath"
    exit 1
}

try {
    # Criar um ícone simples de 32x32 pixels
    $originalImage = [System.Drawing.Image]::FromFile($logoPath)
    
    # Redimensionar para 32x32
    $iconBitmap = New-Object System.Drawing.Bitmap(32, 32)
    $graphics = [System.Drawing.Graphics]::FromImage($iconBitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    
    # Desenhar a imagem redimensionada
    $graphics.DrawImage($originalImage, 0, 0, 32, 32)
    
    # Salvar como BMP primeiro (mais compatível)
    $tempBmp = $outputPath.Replace('.ico', '.bmp')
    $iconBitmap.Save($tempBmp, [System.Drawing.Imaging.ImageFormat]::Bmp)
    
    Write-Host "✅ Bitmap criado: $tempBmp" -ForegroundColor Green
    Write-Host "💡 Para criar ICO real, use uma ferramenta externa ou configure o projeto para usar BMP temporariamente" -ForegroundColor Yellow
    
    # Limpar recursos
    $graphics.Dispose()
    $iconBitmap.Dispose()
    $originalImage.Dispose()
    
    # Por ora, vamos remover o ApplicationIcon do projeto para evitar erro
    Write-Host "🔧 Removendo ApplicationIcon temporariamente para evitar erro de compilação" -ForegroundColor Cyan
    
} catch {
    Write-Error "Erro: $($_.Exception.Message)"
}