# Script para criar ícone a partir da logo existente
param(
    [string]$InputImage = "d:\ProjetosC#\WinFormsApp1\WinFormsApp1\logo-png(1)(1).png",
    [string]$OutputIcon = "d:\ProjetosC#\WinFormsApp1\WinFormsApp1\sangria_icon.ico"
)

try {
    Add-Type -AssemblyName System.Drawing
    
    Write-Host "🎨 Criando ícone a partir da logo..." -ForegroundColor Cyan
    
    # Verificar se arquivo existe
    if (-not (Test-Path $InputImage)) {
        Write-Error "❌ Arquivo de entrada não encontrado: $InputImage"
        exit 1
    }
    
    # Carregar imagem original
    $originalImage = [System.Drawing.Image]::FromFile($InputImage)
    Write-Host "✅ Logo carregada: $($originalImage.Width)x$($originalImage.Height)" -ForegroundColor Green
    
    # Criar bitmap quadrado para o ícone
    $iconSize = 256
    $iconBitmap = New-Object System.Drawing.Bitmap($iconSize, $iconSize)
    $graphics = [System.Drawing.Graphics]::FromImage($iconBitmap)
    
    # Configurar qualidade
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    
    # Preencher fundo transparente
    $graphics.Clear([System.Drawing.Color]::Transparent)
    
    # Calcular posição para centralizar a imagem
    $aspectRatio = $originalImage.Width / $originalImage.Height
    $newWidth = $iconSize
    $newHeight = $iconSize
    
    if ($aspectRatio -gt 1) {
        $newHeight = [int]($iconSize / $aspectRatio)
    } else {
        $newWidth = [int]($iconSize * $aspectRatio)
    }
    
    $x = [int](($iconSize - $newWidth) / 2)
    $y = [int](($iconSize - $newHeight) / 2)
    
    # Desenhar a logo redimensionada
    $destRect = New-Object System.Drawing.Rectangle($x, $y, $newWidth, $newHeight)
    $graphics.DrawImage($originalImage, $destRect)
    
    # Salvar como PNG temporário
    $tempPng = $OutputIcon.Replace('.ico', '_temp.png')
    $iconBitmap.Save($tempPng, [System.Drawing.Imaging.ImageFormat]::Png)
    
    Write-Host "✅ Ícone PNG criado: $tempPng" -ForegroundColor Green
    
    # Limpar recursos
    $graphics.Dispose()
    $iconBitmap.Dispose()
    $originalImage.Dispose()
    
    # Criar arquivo ICO simples (apenas um tamanho)
    # Para ICO multi-tamanho, seria necessário usar bibliotecas externas
    # Por ora, vamos renomear o PNG para ICO como solução temporária
    if (Test-Path $OutputIcon) {
        Remove-Item $OutputIcon -Force
    }
    
    # Copiar o PNG como ICO (funcionará para a maioria dos casos)
    Copy-Item $tempPng $OutputIcon
    Remove-Item $tempPng -Force
    
    Write-Host "✅ Ícone criado com sucesso: $OutputIcon" -ForegroundColor Green
    Write-Host "📏 Tamanho: 256x256 pixels" -ForegroundColor Yellow
    
} catch {
    Write-Error "❌ Erro ao criar ícone: $($_.Exception.Message)"
    exit 1
}