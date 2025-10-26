# Script de Deploy Rápido - Apenas Manifest
# Uso: .\deploy-quick.ps1 "1.3.11"

param(
    [Parameter(Mandatory=$true)]
    [string]$Version
)

$ErrorActionPreference = "Stop"

Write-Host "⚡ Deploy Rápido - Versão $Version" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

$StartTime = Get-Date
$RepoPath = "d:\ProjetosC#\WinFormsApp1\SangrisRepo"
$VRisingPath = "D:\SteamLibrary\steamapps\common\VRising"

# Verificar se a versão é válida
if ($Version -notmatch '^\d+\.\d+\.\d+$') {
    Write-Error "❌ Formato de versão inválido. Use formato: 1.0.0"
    exit 1
}

# Verificar se V Rising existe
Write-Host "`n🔍 Verificando diretório do V Rising..."
if (-not (Test-Path $VRisingPath)) {
    Write-Error "❌ Diretório do V Rising não encontrado: $VRisingPath"
    exit 1
}
Write-Host "✅ V Rising encontrado" -ForegroundColor Green

# Definir arquivos e pastas para incluir
$FilesToInclude = @(
    ".doorstop_version",
    "changelog.txt", 
    "doorstop_config.ini",
    "winhttp.dll"
)

$FoldersToInclude = @(
    "BepInEx",
    "dotnet"
)

# Mapeamento de nomes de arquivos para URLs (GitHub renomeia alguns arquivos automaticamente)
$FileNameMapping = @{
    ".doorstop_version" = "default.doorstop_version"
}

Write-Host "`n📁 Arquivos e pastas a serem incluídos:"
Write-Host "   📄 Arquivos: $($FilesToInclude -join ', ')" -ForegroundColor Yellow
Write-Host "   📁 Pastas: $($FoldersToInclude -join ', ')" -ForegroundColor Yellow

# Copiar arquivos para o repositório
Write-Host "`n📋 Copiando arquivos para o repositório..."

# Criar pasta files se não existir
$FilesPath = Join-Path $RepoPath "files"
if (-not (Test-Path $FilesPath)) {
    New-Item -ItemType Directory -Path $FilesPath -Force | Out-Null
}

# Limpar pasta files
Remove-Item "$FilesPath\*" -Recurse -Force -ErrorAction SilentlyContinue

$ManifestFiles = @()

# Copiar arquivos individuais
foreach ($file in $FilesToInclude) {
    $sourcePath = Join-Path $VRisingPath $file
    $destPath = Join-Path $FilesPath $file
    
    if (Test-Path $sourcePath) {
        Copy-Item $sourcePath $destPath -Force
        
        # Calcular hash e tamanho
        $hash = (Get-FileHash $destPath -Algorithm SHA256).Hash.ToLower()
        $size = (Get-Item $destPath).Length
        
        # Usar nome mapeado para URL se existir, senão usar nome original
        $urlFileName = if ($FileNameMapping.ContainsKey($file)) { $FileNameMapping[$file] } else { $file }
        
        $ManifestFiles += @{
            path = $file
            url = "https://github.com/duugagno/sangris-vrising-mod/releases/download/v$Version/$urlFileName"
            sha256 = $hash
            size = $size
            type = "file"
        }
        
        Write-Host "   ✅ $file -> $urlFileName ($size bytes)" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  $file não encontrado" -ForegroundColor Yellow
    }
}

# Copiar pastas
foreach ($folder in $FoldersToInclude) {
    $sourcePath = Join-Path $VRisingPath $folder
    $destPath = Join-Path $FilesPath $folder
    
    if (Test-Path $sourcePath) {
        Copy-Item $sourcePath $destPath -Recurse -Force
        
        # Para pastas, vamos zipar e calcular hash do zip
        $zipPath = "$destPath.zip"
        Compress-Archive -Path $destPath -DestinationPath $zipPath -Force
        
        $hash = (Get-FileHash $zipPath -Algorithm SHA256).Hash.ToLower()
        $size = (Get-Item $zipPath).Length
        
        $ManifestFiles += @{
            path = $folder
            url = "https://github.com/duugagno/sangris-vrising-mod/releases/download/v$Version/$folder.zip"
            sha256 = $hash
            size = $size
            type = "folder"
        }
        
        Write-Host "   ✅ $folder/ ($size bytes comprimido)" -ForegroundColor Green
        
        # Remover pasta descomprimida, manter só o zip
        Remove-Item $destPath -Recurse -Force
    } else {
        Write-Host "   ⚠️  $folder/ não encontrado" -ForegroundColor Yellow
    }
}

# Atualizar manifest.json
Write-Host "`n📄 Atualizando manifest.json..."
Set-Location $RepoPath

$ManifestData = @{
    version = $Version
    files = $ManifestFiles
}

$ManifestJson = $ManifestData | ConvertTo-Json -Depth 10
$ManifestJson | Out-File -FilePath "manifest.json" -Encoding UTF8

Write-Host "✅ Manifest atualizado com $($ManifestFiles.Count) itens" -ForegroundColor Green

# Commit e push
Write-Host "`n📤 Fazendo commit e push..."
try {
    git add .
    git status --porcelain
    
    $commitMessage = @"
feat: Quick update to v$Version

- Updated $($FilesToInclude.Count) core files
- Updated $($FoldersToInclude.Count) directories (compressed)
- Complete V Rising mod installation
- All files verified with SHA256
- Ready for v$Version release
"@
    
    git commit -m $commitMessage
    git push
    
    Write-Host "✅ Alterações enviadas para GitHub" -ForegroundColor Green
} catch {
    Write-Error "❌ Falha no commit/push: $_"
    exit 1
}

# Gerar informações para release
Write-Host "`n📋 Gerando informações para release..."

$TotalSize = ($ManifestFiles | Measure-Object -Property size -Sum).Sum
$FilesInfo = $ManifestFiles | ForEach-Object {
    $sizeKB = [math]::Round($_.size / 1KB, 2)
    $urlFileName = [System.IO.Path]::GetFileName($_.url)
    "- **$($_.path)** ($($_.type)): $sizeKB KB → Upload como: $urlFileName"
}

$FilesList = $ManifestFiles | ForEach-Object { 
    $uploadName = [System.IO.Path]::GetFileName($_.url)
    "- $($_.path)$(if($_.type -eq 'folder'){'.zip'}) → Upload como: $uploadName" 
} | Sort-Object

$ReleaseInfo = @"
# 🎮 Sangris V Rising Mod Pack v$Version

## 📦 Conteúdo do Pack
$($FilesInfo -join "`n")

## 📊 Informações Técnicas
- Versão: $Version
- Data: $(Get-Date -Format 'dd/MM/yyyy HH:mm')
- Total de arquivos: $($ManifestFiles.Count)
- Tamanho total: $([math]::Round($TotalSize / 1MB, 2)) MB

## ⚠️ IMPORTANTE - Mapeamento de Nomes
GitHub renomeia automaticamente alguns arquivos:
- .doorstop_version → default.doorstop_version

## 🔗 URLs
- Manifest: https://raw.githubusercontent.com/duugagno/sangris-vrising-mod/main/manifest.json

## 📋 Checklist Manual
- [ ] Criar release no GitHub com tag v$Version
- [ ] Anexar todos os arquivos listados acima (com os nomes corretos)
- [ ] Verificar que .doorstop_version vira default.doorstop_version
- [ ] Testar download via launcher
- [ ] Verificar integridade SHA256

## 🎯 Arquivos para anexar na release:
$($FilesList -join "`n")
"@

Set-Location $RepoPath
$ReleaseInfo | Out-File -FilePath "release-info-v$Version.txt" -Encoding UTF8
Write-Host "✅ Informações salvas em: release-info-v$Version.txt" -ForegroundColor Green

# Resumo final
$EndTime = Get-Date
$Duration = $EndTime - $StartTime

Write-Host "`n⚡ Deploy Rápido Concluído!" -ForegroundColor Green
Write-Host "=========================" -ForegroundColor Green
Write-Host "⏱️  Tempo total: $($Duration.ToString('mm\:ss'))" -ForegroundColor Green
Write-Host "📋 Info Release: $RepoPath\release-info-v$Version.txt" -ForegroundColor Green
Write-Host "📁 Arquivos: $RepoPath\files\" -ForegroundColor Green
Write-Host "📊 Total: $([math]::Round($TotalSize / 1MB, 2)) MB em $($ManifestFiles.Count) arquivos" -ForegroundColor Green

Write-Host "`n🚀 Próximos passos manuais:" -ForegroundColor Yellow
Write-Host "1. 🌐 Criar release no GitHub:" -ForegroundColor Yellow
Write-Host "   https://github.com/duugagno/sangris-vrising-mod/releases/new" -ForegroundColor Yellow
Write-Host "2. 🏷️  Tag: v$Version" -ForegroundColor Yellow
Write-Host "3. 📎 Anexar arquivos da pasta: $RepoPath\files\" -ForegroundColor Yellow
Write-Host "4. ⚠️  ATENÇÃO: .doorstop_version será renomeado para default.doorstop_version automaticamente" -ForegroundColor Cyan

# Abrir URLs importantes
$response = Read-Host "`n❓ Abrir GitHub releases agora? (y/N)"
if ($response -eq 'y' -or $response -eq 'Y') {
    Start-Process "https://github.com/duugagno/sangris-vrising-mod/releases/new"
    Start-Process $RepoPath\files
}