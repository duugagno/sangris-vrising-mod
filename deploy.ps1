# Script de Deploy Completo
# Uso: .\deploy.ps1 "1.1.0"

param(
    [Parameter(Mandatory=$true)]
    [string]$Version
)

$ErrorActionPreference = "Stop"

Write-Host "🚀 Iniciando Deploy Completo - Versão $Version" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan

$StartTime = Get-Date
$RepoPath = "d:\ProjetosC#\WinFormsApp1\SangrisRepo"
$LauncherPath = "d:\ProjetosC#\WinFormsApp1"

# Verificar se a versão é válida
if ($Version -notmatch '^\d+\.\d+\.\d+$') {
    Write-Error "❌ Formato de versão inválido. Use formato: 1.0.0"
    exit 1
}

# 1. Verificar sistema antes do deploy
Write-Host "`n🔍 Verificando sistema..."
Set-Location $RepoPath
& .\verificar-sistema.ps1

# 2. Fazer backup
Write-Host "`n💾 Criando backup..."
$BackupPath = "D:\Backups\Sangris-Deploy-$(Get-Date -Format 'yyyy-MM-dd-HHmm')"
try {
    Copy-Item $LauncherPath $BackupPath -Recurse -Force
    Write-Host "✅ Backup criado em: $BackupPath" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Falha no backup: $_" -ForegroundColor Yellow
}

# 3. Atualizar mod
Write-Host "`n🔄 Atualizando mod para versão $Version..."
try {
    & .\update-sangris.ps1 $Version
    Write-Host "✅ Mod atualizado com sucesso" -ForegroundColor Green
} catch {
    Write-Error "❌ Falha na atualização do mod: $_"
    exit 1
}

# 4. Recompilar launcher
Write-Host "`n🔨 Recompilando launcher..."
Set-Location $LauncherPath

try {
    # Limpar builds anteriores
    Write-Host "   🧹 Limpando builds anteriores..."
    dotnet clean --configuration Release | Out-Null
    
    # Build Release
    Write-Host "   🔨 Compilando Release..."
    dotnet build --configuration Release
    
    # Publish Standalone
    Write-Host "   📦 Criando versão standalone..."
    dotnet publish --configuration Release --self-contained true --runtime win-x64 --output publish
    
    Write-Host "✅ Launcher recompilado com sucesso" -ForegroundColor Green
} catch {
    Write-Error "❌ Falha na compilação do launcher: $_"
    exit 1
}

# 5. Executar testes básicos
Write-Host "`n🧪 Executando testes básicos..."

# Verificar se executável foi criado
if (Test-Path "$LauncherPath\publish\SangriaLauncher.exe") {
    Write-Host "✅ Executável standalone criado" -ForegroundColor Green
} else {
    Write-Host "❌ Executável standalone não encontrado" -ForegroundColor Red
}

# Verificar se DLL foi atualizada
Set-Location $RepoPath
$manifest = Get-Content "manifest.json" | ConvertFrom-Json
if ($manifest.version -eq $Version) {
    Write-Host "✅ Manifest atualizado para versão $Version" -ForegroundColor Green
} else {
    Write-Host "❌ Manifest não foi atualizado corretamente" -ForegroundColor Red
}

# 6. Gerar informações para release
Write-Host "`n📋 Gerando informações para release..."

$ReleaseInfo = @"
# Release v$Version

## 📊 Informações Técnicas
- **Versão**: $Version
- **Data**: $(Get-Date -Format 'dd/MM/yyyy HH:mm')
- **SHA256**: $($manifest.files[0].sha256)
- **Tamanho**: $($manifest.files[0].size) bytes

## 🔗 URLs
- **Download**: https://github.com/duugagno/sangris-vrising-mod/releases/download/v$Version/SangrisInterface.dll
- **Manifest**: https://raw.githubusercontent.com/duugagno/sangris-vrising-mod/main/manifest.json

## 📋 Checklist Manual
- [ ] Criar release no GitHub
- [ ] Anexar arquivo SangrisInterface.dll
- [ ] Testar download via launcher
- [ ] Atualizar CHANGELOG.md se necessário
"@

$ReleaseInfo | Out-File -FilePath "release-info-v$Version.txt" -Encoding UTF8
Write-Host "✅ Informações salvas em: release-info-v$Version.txt" -ForegroundColor Green

# 7. Resumo final
$EndTime = Get-Date
$Duration = $EndTime - $StartTime

Write-Host "`n🎉 Deploy Concluído!" -ForegroundColor Green
Write-Host "==================" -ForegroundColor Green
Write-Host "⏱️  Tempo total: $($Duration.ToString('mm\:ss'))" -ForegroundColor Green
Write-Host "📁 Backup: $BackupPath" -ForegroundColor Green
Write-Host "📦 Executável: $LauncherPath\publish\SangriaLauncher.exe" -ForegroundColor Green
Write-Host "📋 Info Release: $RepoPath\release-info-v$Version.txt" -ForegroundColor Green

Write-Host "`n🚀 Próximos passos manuais:" -ForegroundColor Yellow
Write-Host "1. 🌐 Criar release no GitHub:" -ForegroundColor Yellow
Write-Host "   https://github.com/duugagno/sangris-vrising-mod/releases/new" -ForegroundColor Yellow
Write-Host "2. 🏷️  Tag: v$Version" -ForegroundColor Yellow
Write-Host "3. 📎 Anexar: SangrisInterface.dll" -ForegroundColor Yellow
Write-Host "4. 🧪 Testar launcher com nova versão" -ForegroundColor Yellow

# Abrir URLs importantes
$response = Read-Host "`n❓ Abrir GitHub releases agora? (y/N)"
if ($response -eq 'y' -or $response -eq 'Y') {
    Start-Process "https://github.com/duugagno/sangris-vrising-mod/releases/new"
}