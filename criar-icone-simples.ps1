# Script simplificado para criar um ícone para o SangriaLauncher
Add-Type -AssemblyName System.Drawing

Write-Host "🎨 Criando ícone personalizado para SangriaLauncher..." -ForegroundColor Cyan

# Criar um bitmap de 256x256 para o ícone
$bitmap = New-Object System.Drawing.Bitmap(256, 256)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)

# Configurar qualidade
$graphics.SmoothingMode = "AntiAlias"

# Cores do tema Sangria
$backgroundColor = [System.Drawing.Color]::FromArgb(27, 27, 27)    # #1B1B1B
$primaryColor = [System.Drawing.Color]::FromArgb(255, 40, 41)      # #FF2829  
$textColor = [System.Drawing.Color]::FromArgb(240, 240, 240)       # #F0F0F0

# Preencher fundo
$backgroundBrush = New-Object System.Drawing.SolidBrush($backgroundColor)
$graphics.FillRectangle($backgroundBrush, 0, 0, 256, 256)

# Criar círculo central vermelho
$primaryBrush = New-Object System.Drawing.SolidBrush($primaryColor)
$graphics.FillEllipse($primaryBrush, 40, 40, 176, 176)

# Adicionar borda mais escura
$borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200, 30, 30), 4)
$graphics.DrawEllipse($borderPen, 40, 40, 176, 176)

# Adicionar texto "S" centralizado
$font = New-Object System.Drawing.Font("Arial", 100, [System.Drawing.FontStyle]::Bold)
$textBrush = New-Object System.Drawing.SolidBrush($textColor)

# Medir o texto para centralizar
$textSize = $graphics.MeasureString("S", $font)
$x = (256 - $textSize.Width) / 2
$y = (256 - $textSize.Height) / 2

$graphics.DrawString("S", $font, $textBrush, $x, $y)

# Salvar como PNG primeiro (para verificação)
$pngPath = "d:\ProjetosC#\WinFormsApp1\WinFormsApp1\sangria_icon.png"
$bitmap.Save($pngPath, [System.Drawing.Imaging.ImageFormat]::Png)

Write-Host "✅ Ícone PNG criado: $pngPath" -ForegroundColor Green

# Criar versões menores
$bitmap48 = New-Object System.Drawing.Bitmap($bitmap, 48, 48)
$bitmap32 = New-Object System.Drawing.Bitmap($bitmap, 32, 32)
$bitmap16 = New-Object System.Drawing.Bitmap($bitmap, 16, 16)

$bitmap48.Save("d:\ProjetosC#\WinFormsApp1\WinFormsApp1\sangria_icon_48.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bitmap32.Save("d:\ProjetosC#\WinFormsApp1\WinFormsApp1\sangria_icon_32.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bitmap16.Save("d:\ProjetosC#\WinFormsApp1\WinFormsApp1\sangria_icon_16.png", [System.Drawing.Imaging.ImageFormat]::Png)

# Tentar criar ICO usando PowerShell
try {
    # Método simples: renomear PNG como ICO (funciona para casos básicos)
    $icoPath = "d:\ProjetosC#\WinFormsApp1\WinFormsApp1\sangria_icon.ico"
    Copy-Item $pngPath $icoPath
    Write-Host "✅ Ícone ICO criado: $icoPath" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Erro ao criar ICO: $_" -ForegroundColor Yellow
}

# Limpar recursos
$graphics.Dispose()
$bitmap.Dispose()
$bitmap48.Dispose()
$bitmap32.Dispose()
$bitmap16.Dispose()
$backgroundBrush.Dispose()
$primaryBrush.Dispose()
$textBrush.Dispose()
$borderPen.Dispose()
$font.Dispose()

Write-Host "🎯 Ícone criado com sucesso!" -ForegroundColor Green
Write-Host "📁 Localização: d:\ProjetosC#\WinFormsApp1\WinFormsApp1\sangria_icon.ico" -ForegroundColor Yellow