# Script para criar um ícone para o SangriaLauncher
# Usa a biblioteca System.Drawing para criar um ícone simples

Add-Type -AssemblyName System.Drawing

# Criar um bitmap de 256x256 para o ícone
$bitmap = New-Object System.Drawing.Bitmap(256, 256)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)

# Configurar qualidade de renderização
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

# Cores do tema Sangria
$backgroundColor = [System.Drawing.Color]::FromArgb(27, 27, 27)    # #1B1B1B
$primaryColor = [System.Drawing.Color]::FromArgb(255, 40, 41)      # #FF2829
$textColor = [System.Drawing.Color]::FromArgb(240, 240, 240)       # #F0F0F0

# Preencher fundo
$backgroundBrush = New-Object System.Drawing.SolidBrush($backgroundColor)
$graphics.FillRectangle($backgroundBrush, 0, 0, 256, 256)

# Criar círculo central
$primaryBrush = New-Object System.Drawing.SolidBrush($primaryColor)
$graphics.FillEllipse($primaryBrush, 50, 50, 156, 156)

# Adicionar texto "S" no centro
$font = New-Object System.Drawing.Font("Arial", 90, [System.Drawing.FontStyle]::Bold)
$textBrush = New-Object System.Drawing.SolidBrush($textColor)
$stringFormat = New-Object System.Drawing.StringFormat()
$stringFormat.Alignment = [System.Drawing.StringAlignment]::Center
$stringFormat.LineAlignment = [System.Drawing.StringAlignment]::Center

$rect = New-Object System.Drawing.Rectangle(0, 0, 256, 256)
$graphics.DrawString("S", $font, $textBrush, $rect, $stringFormat)

# Salvar como PNG temporário
$tempPng = "d:\ProjetosC#\WinFormsApp1\WinFormsApp1\temp_icon.png"
$bitmap.Save($tempPng, [System.Drawing.Imaging.ImageFormat]::Png)

Write-Host "✅ Ícone PNG criado em: $tempPng" -ForegroundColor Green

# Limpar recursos
$graphics.Dispose()
$bitmap.Dispose()
$backgroundBrush.Dispose()
$primaryBrush.Dispose()
$textBrush.Dispose()
$font.Dispose()
$stringFormat.Dispose()

Write-Host "🎨 Agora convertendo PNG para ICO..." -ForegroundColor Yellow

# Usar .NET para criar ICO
Add-Type -AssemblyName System.Drawing

# Carregar PNG
$png = [System.Drawing.Image]::FromFile($tempPng)

# Criar diferentes tamanhos para o ICO
$sizes = @(16, 32, 48, 64, 128, 256)
$iconPath = "d:\ProjetosC#\WinFormsApp1\WinFormsApp1\sangria_icon.ico"

# Usar uma abordagem mais simples: salvar o PNG como ICO básico
$bitmap256 = New-Object System.Drawing.Bitmap($png, 256, 256)
$bitmap256.Save($iconPath.Replace('.ico', '_256.png'), [System.Drawing.Imaging.ImageFormat]::Png)

$bitmap48 = New-Object System.Drawing.Bitmap($png, 48, 48)
$bitmap48.Save($iconPath.Replace('.ico', '_48.png'), [System.Drawing.Imaging.ImageFormat]::Png)

$bitmap32 = New-Object System.Drawing.Bitmap($png, 32, 32)
$bitmap32.Save($iconPath.Replace('.ico', '_32.png'), [System.Drawing.Imaging.ImageFormat]::Png)

$bitmap16 = New-Object System.Drawing.Bitmap($png, 16, 16)
$bitmap16.Save($iconPath.Replace('.ico', '_16.png'), [System.Drawing.Imaging.ImageFormat]::Png)

Write-Host "✅ Tamanhos criados: 16x16, 32x32, 48x48, 256x256" -ForegroundColor Green

# Limpar
$png.Dispose()
$bitmap256.Dispose()
$bitmap48.Dispose()
$bitmap32.Dispose()
$bitmap16.Dispose()

# Remover arquivo temporário
Remove-Item $tempPng -Force

Write-Host "🎯 Para criar o ICO final, você pode usar uma ferramenta online como:" -ForegroundColor Cyan
Write-Host "   • https://convertio.co/png-ico/" -ForegroundColor Yellow
Write-Host "   • https://icoconvert.com/" -ForegroundColor Yellow
Write-Host "   • Ou usar o GIMP/Photoshop" -ForegroundColor Yellow
Write-Host "📁 Arquivos PNG criados para conversão em: d:\ProjetosC#\WinFormsApp1\WinFormsApp1\" -ForegroundColor Green